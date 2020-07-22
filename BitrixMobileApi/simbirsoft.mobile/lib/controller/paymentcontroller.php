<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;
use Bitrix\Sale;
use
    Bitrix\Main\Loader,
    Bitrix\Sale\Order,
    Bitrix\Sale\PaySystem,
    Bitrix\Sale\Payment;
class PaymentController implements Routable {
    public $arParams = [
        'DISCOUNT_LEVELS_IBLOCK_CODE' => 'discount_levels',
        'USERS_DISCOUNT_LEVELS_IBLOCK_CODE' => 'users_discount_levels'
    ];

    public function post() {
        GLOBAL $USER;
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $out = new \stdClass();

        $userFields = \Bitrix\Main\UserTable::getById($USER->GetID());
        if(\CModule::IncludeModule('sale')) {
            \CSaleBasket::DeleteAll(\CSaleBasket::GetBasketUserID());
        }
        if(!empty($postJson["order"])){

            if ($arUser = $userFields->fetch()) {
                $out->id = $USER->GetID();
                //return json_encode("OK");

                Loader::includeModule("sale");
                $registry = Sale\Registry::getInstance(Sale\Registry::REGISTRY_TYPE_ORDER);
                $orderClassName = $registry->getOrderClassName();
                $order = $orderClassName::loadByAccountNumber($postJson["order"]);// id заказа

                if ($order->isAllowPay()) {
                    $paymentCollection = $order->getPaymentCollection();
                    foreach ($paymentCollection as $payment) {
                       // $arResult["PAYMENT"][$payment->getId()] = $payment->getFieldValues();
                        if (intval($payment->getPaymentSystemId()) > 0 && !$payment->isPaid()) {
                            $paySystemService = PaySystem\Manager::getObjectById($payment->getPaymentSystemId());
                           // return json_encode( $arResult["PAYMENT"]);
                            if (!empty($paySystemService)) {
                                $arPaySysAction = $paySystemService->getFieldsValues();
                                if ($paySystemService->getField('NEW_WINDOW') === 'N' || $paySystemService->getField('ID') == PaySystem\Manager::getInnerPaySystemId()){
                                    $initResult = $paySystemService->initiatePay($payment, null, PaySystem\BaseServiceHandler::STRING);
                                    if ($initResult->isSuccess()) {
                                        $arResult["PAYMENT"] = $initResult->getTemplate();
                                        $regexp = "<a\s[^>]*href=(\"??)([^\" >]*?)\\1[^>]*>(.*)<\/a>";
                                        if(preg_match_all("/$regexp/siU", $arResult["PAYMENT"], $matches)) {
                                            $arResult["href"] = $matches[2];
                                        }
                                        $arResult["PAYMENT"] = "";

                                        $arPaySysAction['BUFFERED_OUTPUT'] = $initResult->getTemplate(); // получаем форму оплаты из обработчика
                                        return json_encode($arResult);
                                    }else
                                        $arPaySysAction["ERROR"] = $initResult->getErrorMessages();
                                }
                            }
                        }
                    }
                }


               // return json_encode( $arResult["PAYMENT"]);
            } else {
                $out->errors[] = Main::addError('0x012','', 'Ошибка получения профиля');
                print json_encode($out);
            }
        } else {
            /*
            if(\CModule::IncludeModule('sale')) {
                \CSaleBasket::DeleteAll(\CSaleBasket::GetBasketUserID());
            }
            $out->basket
             print json_encode($out);*/
        }
        header("HTTP/1.1 200 OK");
        return ;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

}
