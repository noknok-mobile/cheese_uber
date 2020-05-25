<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;
use Bitrix\Sale;

class BasketController implements Routable {
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
        if(!empty($postJson["cart"])){

            if ($arUser = $userFields->fetch()) {
                $out->id = $USER->GetID();
                //return json_encode("OK");
                foreach($postJson["cart"] as $key=>$value) {
                    $product = array(
                        'PRODUCT_ID' => $key,
                        'QUANTITY' => $value,
                    );

                    $basketResult = \Bitrix\Catalog\Product\Basket::addProduct($product);

                    $out->status = $basketResult->isSuccess();
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


                return json_encode($out);
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
