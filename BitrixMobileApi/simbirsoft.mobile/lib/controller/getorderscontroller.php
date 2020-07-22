<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;
use Bitrix\Sale;

class GetOrdersController implements Routable {
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
            $arFilter = Array(
                "USER_ID" => $USER->GetID(),
                "CANCELED"=> "N"
            );

            $db_sales = \CSaleOrder::GetList(array("DATE_INSERT" => "ASC"), $arFilter,false,false,array("ID","STATUS_ID","DATE_INSERT","DATE_UPDATE","PRICE","DELIVERY_ID", "PRICE_DELIVERY"));

            while($ord = $db_sales->fetch()){

                $arr["ID"] = $ord["ID"];
                $arr["STATUS_ID"] = $ord["STATUS_ID"];
                $arr["DATE_INSERT"] = $ord["DATE_INSERT"];
                $arr["DATE_UPDATE"] = $ord["DATE_UPDATE"];
                $arr["PRICE"] = $ord["PRICE"];
                $arr["DELIVERY_ID"] = $ord["DELIVERY_ID"];
				$arr["PRICE_DELIVERY"] = $ord[ "PRICE_DELIVERY"];


                $basketItems = \CSaleBasket::GetList(array(), array("ORDER_ID" => $ord["ID"]), false, false, array("ORDER_ID","PRODUCT_ID","QUANTITY","PRICE"));

                while ($arItems = $basketItems->Fetch()) {
                        $product['ORDER'] = $ord['ID'];
                        $product['ORDER_ID'] = $arItems['ORDER_ID'];
                        $product['ID'] = $arItems['PRODUCT_ID'];
                        $product['QUANTITY'] = $arItems['QUANTITY'];
                        $product['PRICE'] = floatval($arItems['PRICE']);
                        $tmp[$ord['ID']][]  = $product;

                }
                $arr['BASKET']  =  $tmp[$ord['ID']];
                $userProps = \CSaleOrderPropsValue::GetList(
                    array("DATE_INSERT" => "ASC"),
                    array("ORDER_ID" => $ord["ID"]), false, false, array("ORDER_PROPS_ID","NAME","VALUE","ID"));

                while($arFields = $userProps->fetch()){
                    $arr ['profile']['id'] = $arFields['ID'];
                    $arr ['profile']["user_id"] = $USER->GetID();
                    $arr ['profile']['data'][$arFields['ORDER_PROPS_ID']] = $arFields['ID'];
                    $arr ['profile']['name'] = $arFields['NAME'];
                    $arr ['profile']['data'][$arFields['ORDER_PROPS_ID']] = $arFields['VALUE'];
                }
                $out->orders[] = $arr;
            }

            return json_encode($out);
        }

        header("HTTP/1.1 200 OK");
        return ;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

}
