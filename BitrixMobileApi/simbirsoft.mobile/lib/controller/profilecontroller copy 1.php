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
            $out->name = $arUser['NAME'];
            $out->lastName = $arUser['LAST_NAME'];
            $out->phone = $arUser['PERSONAL_PHONE'];
            $out->birthday = $arUser['PERSONAL_BIRTHDAY'] ? $arUser['PERSONAL_BIRTHDAY']->toString() : null;
            if (!empty($arUser['PERSONAL_PHOTO'])) {
                $arUser['PERSONAL_PHOTO'] = \CFile::GetFileArray($arUser['PERSONAL_PHOTO'])['SRC'];
            }
            $out->photo = $arUser['PERSONAL_PHOTO']?$arUser['PERSONAL_PHOTO']:null;
            $out->gender = $arUser['PERSONAL_GENDER'];
            $out->login = $arUser['LOGIN'];
            $out->email = $arUser['EMAIL'];
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
