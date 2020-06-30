<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;
use Bitrix\Sale;
use  Simbirsoft\Mobile\Push\CustomFCM;
class OrderController implements Routable {
    public $arParams = [
        'DISCOUNT_LEVELS_IBLOCK_CODE' => 'discount_levels',
        'USERS_DISCOUNT_LEVELS_IBLOCK_CODE' => 'users_discount_levels'
    ];

    public function post() {
       /* \Bitrix\Main\EventManager::getInstance()->UnRegisterEventHandler('sale', 'OnSaleStatusOrder', 'simbirsoft.mobile', 'Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange', 100000);*/
       /* \Bitrix\Main\EventManager::getInstance()->addEventHandler('sale', 'OnSaleStatusOrderChange', ['Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange']);*/
        GLOBAL $USER;
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $out = new \stdClass();
        $userFields = \Bitrix\Main\UserTable::getById($USER->GetID());
        if(\CModule::IncludeModule('sale')) {
            \CSaleBasket::DeleteAll(\CSaleBasket::GetBasketUserID());
        }
        if(!empty($postJson["cart"])){

            if ($arUser = $userFields->fetch()) {
                $out->id = $USER->GetID();
                //return json_encode("OK");
                foreach($postJson["cart"] as $key=>$value) {

                    $prices = \CCatalogProduct::GetByIDEx($key);
                   // $regionPriceId = get_region_price_id();
                    $price = $prices['PRICES'][$postJson["Region"]]['PRICE'];
                    $out->values["Price"] =  $price;
                    $product = array(
                        'PRODUCT_ID' => $key,
                        'QUANTITY' => $value,
                        'PRICE' => $price,
                        'CURRENCY' => \Bitrix\Currency\CurrencyManager::getBaseCurrency(),
                        'ELEMENT_IBLOCK_ID' => $key,
                        'CATALOG_GROUP_ID' => $postJson["Region"],
                        'CUSTOM_PRICE' => 'Y',
                    );

                    $basketResult = \Bitrix\Catalog\Product\Basket::addProduct($product);

                    if ($basketResult->isSuccess())
                    {
                        $out->status['success'] = true;
                        $data = $basketResult->getData();
                        $basket = \Bitrix\Sale\Basket::loadItemsForFUser(

                            \Bitrix\Sale\Fuser::getId(),

                            \Bitrix\Main\Context::getCurrent()->getSite()

                        );

                        $refreshStrategy = \Bitrix\Sale\Basket\RefreshFactory::create(\Bitrix\Sale\Basket\RefreshFactory::TYPE_FULL);

                        $basket->refresh($refreshStrategy);
                        $basket->save();
                    }
                    else
                    {

                        $out->errors[] = Main::addError('0x012','',  'Ошибка получения профиля');
                    }
                }



            } else {
                $out->errors[] = Main::addError('0x012','', 'Ошибка получения профиля');
                print json_encode($out);
            }
            if(!empty($postJson["address"])) {
                $basket = Sale\Basket::loadItemsForFUser(\Bitrix\Sale\Fuser::getId(), \Bitrix\Main\Context::getCurrent()->getSite());
                $arFields = array(
                    "LID" => SITE_ID,
                    "PERSON_TYPE_ID" => 1,
                    "PAYED" => "N",
                    "CANCELED" => "N",
                    "STATUS_ID" => "N",
                    "PRICE" => $basket->getPrice(),
                    "CURRENCY" => \CSaleLang::GetLangCurrency(SITE_ID),
                    "USER_ID" => IntVal($USER->GetID()),
                    "PAY_SYSTEM_ID" => $postJson["payment"],

                    "DELIVERY_ID" => $postJson["delivery"],
                    "TAX_VALUE" => 0.0,
                );
                $out->values["SendedBasket"] = $postJson["cart"];
                $out->values["Basket"] = $basket;

// add Guest ID

                if (\CModule::IncludeModule('sale')) {
                    $siteId = \Bitrix\Main\Context::getCurrent()->getSite();
                    $currencyCode = \Bitrix\Currency\CurrencyManager::getBaseCurrency();

// Создаёт новый заказ


                    $order = \Bitrix\Sale\Order::create($siteId, $USER->isAuthorized() ? $USER->GetID() : 539);
                    $order->setPersonTypeId(1);
                    $order->setField('CURRENCY', $currencyCode);
                    $comment = $postJson["comment"];
                    if ($comment) {
                        $order->setField('USER_DESCRIPTION', $comment); // Устанавливаем поля комментария покупателя
                    }
                         $order->setBasket($basket);

                 //   $orderId = \CSaleOrder::Add($arFields);
                  //  \CSaleBasket::OrderBasket($orderId,$USER->GetID(), SITE_ID,array());
                  //  $order = \Bitrix\Sale\Order::load($orderId);
                  //  $order = \Bitrix\Sale\OrderBase::load($orderId);



// Создаём одну отгрузку и устанавливаем способ доставки - "Без доставки" (он служебный)
                    $shipmentCollection = $order->getShipmentCollection();
                    $shipment = $shipmentCollection->createItem();
                    $service = \Bitrix\Sale\Delivery\Services\Manager::getById($postJson["delivery"]/*\Bitrix\Sale\Delivery\Services\EmptyDeliveryService::getEmptyDeliveryServiceId()*/);
                    $shipment->setFields(array(
                        'DELIVERY_ID' => $service['ID'],
                        'DELIVERY_NAME' => $service['NAME'],
                    ));

                    $shipmentItemCollection = $shipment->getShipmentItemCollection();
                    //  $shipmentItem = $shipmentItemCollection->createItem($item);
                    //  $shipmentItem->setQuantity($item->getQuantity());

// Создаём оплату со способом #1
                    $paymentCollection = $order->getPaymentCollection();
                    $payment = $paymentCollection->createItem();
                    $paySystemService = \Bitrix\Sale\PaySystem\Manager::getObjectById($postJson["payment"]);
                    $payment->setFields(array(
                        'PAY_SYSTEM_ID' => $paySystemService->getField("PAY_SYSTEM_ID"),
                        'PAY_SYSTEM_NAME' => $paySystemService->getField("NAME"),
                    ));
                    $payment->setField("SUM", $order->getPrice() - $postJson["usedBonuce"]);
                    $payment->setField("CURRENCY", $order->getCurrency());

                    \CSaleUserAccount::Pay(
                        $USER->GetID(),
                        $postJson["usedBonuce"],
                        $order->getCurrency(),
                         $order->getId());




// Устанавливаем свойства

                    $propertyCollection = $order->getPropertyCollection();

                    foreach ($postJson["address"] as $key => $value){


                        if(intval($key)) {
                            $propertyValue = $propertyCollection->getItemByOrderPropertyId(intval($key));

                            $out->address[]["key"] = $key;
                            $out->address[]["value"] = $value;
                            $out->address[]["value"] = $propertyValue ;

                            if ($propertyValue && $value) {
                                $propertyValue->setValue($value);

                            }
                        }

                    }
                   // return json_encode($out);
                    /*

                    $phoneProp = $propertyCollection->getPhone();
                    $phoneProp->setValue("12313123");
                    $nameProp = $propertyCollection->getPayerName();
                    $nameProp->setValue("qweqwewqe");*/

// Сохраняем
                    $order->doFinalAction(true);
                    $result = $order->save();
                    $orderId = $order->getId();

                    $out->propertyCollection = $propertyCollection;
                    $out->result = $result;
                    $out->order_id = $orderId;

                    $arFields = array(
                        "USER_ID" => IntVal($USER->GetID()),
                        "DELIVERY_ID" => $postJson["delivery"],
                    );
                    // $ORDER_ID = \CSaleOrder::Add($arFields);
                    ///  \CSaleBasket::OrderBasket($ORDER_ID);
                    //  $out->order_vars = $arFields;
                    // $out->order_id = $ORDER_ID;
                    //  \IntVal($ORDER_ID);

                }
            }
            return json_encode($out);

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

class OrderStatusHandler{
    
    public function OnSaleStatusOrderChange($event){
         $fcm_service = new CustomFCM();
         $fcm_service->pushNotification("qweqwe.qwe",array("Title"=>"testTitle"));
       
    }
    
}