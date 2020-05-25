<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;


class ProfileController implements Routable {
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

        if ($arUser = $userFields->fetch()) {
            $out->id = $USER->GetID();
            $out->name = $arUser['NAME'];
            $out->lastName = $arUser['LAST_NAME'];
            $out->phone = $arUser['PERSONAL_PHONE'];

            $out->login = $arUser['LOGIN'];
            $out->email = $arUser['EMAIL'];
            $dbAccountCurrency = \CSaleUserAccount::GetList(
                array(),
                array("USER_ID" => $USER->GetID()),
                false,
                false,
                array("CURRENT_BUDGET")
            );
            $out->bonuse = "0";
            while ($arAccountCurrency = $dbAccountCurrency->Fetch())
            {
                $out->bonuse= $arAccountCurrency["CURRENT_BUDGET"];

            }

            if(\CModule::IncludeModule("sale"))
            {
                $db_sales = \CSaleOrderUserProps::GetList(
                    array("DATE_UPDATE" => "DESC"),
                    array("USER_ID" => $USER->GetID()),
                    false,
                    false,
                    array("ID","NAME")
                );

                while ($ar_sales = $db_sales->Fetch())
                {

                    $userProps = \CSaleOrderUserPropsValue
                        ::GetList(
                            array("DATE_UPDATE" => "DESC"),
                            array('USER_PROPS_ID' => $ar_sales['ID']),
                            false,
                            false,
                            array("ORDER_PROPS_ID","NAME","VALUE","ID")
                        );
                    while($arFields = $userProps->fetch()){
                        $out->userProps[$ar_sales['NAME']]['name'] = $ar_sales['NAME'];
                        $out->userProps[$ar_sales['NAME']]['id'] = $ar_sales['ID'];
                        $out->userProps[$ar_sales['NAME']]['user_id'] = $USER->GetID();
                        //$out->userProps[$ar_sales['NAME']]['profileData'][$arFields['ID']] = $arFields['ID'];
                        $out->userProps[$ar_sales['NAME']]['data'][$arFields['ORDER_PROPS_ID']]['id'] = $arFields['ID'];
                        $out->userProps[$ar_sales['NAME']]['data']['name'] = $arFields['NAME'];
                        $out->userProps[$ar_sales['NAME']]['data'][$arFields['ORDER_PROPS_ID']] = $arFields['VALUE'];
                       // $out->userProps[$ar_sales['NAME']]['data'][$arFields['ORDER_PROPS_ID']]['NAME'] = $arFields['NAME'];
                        //$out->userProps[$ar_sales['NAME']]['profileData']['rowdata'][] = $arFields;
                    }
                }
            }

            return json_encode($out);
        } else {
            $out->errors[] = Main::addError('0x012','', 'Ошибка получения профиля');
            print json_encode($out);
        }

        header("HTTP/1.1 200 OK");
        return ;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

}
