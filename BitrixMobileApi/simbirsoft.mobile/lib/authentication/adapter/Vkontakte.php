<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;


class Vkontakte extends AbstractAdapter {

    protected $addCredentials = array(
        'scope' => 'email',
        'display' => 'popup',
    );

    protected $loginDialogUrl = 'https://oauth.vk.com/authorize';

    protected $loginDialogParams = array(
        'scope' => '%s',
        'display' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'response_type' => '%s'
    );

    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 378;


    protected $requestTokenUrl = 'https://oauth.vk.com/access_token';
    protected $requestTokenMethod = HTTP_METH_GET;
    protected $requestTokenResponseType = self::TOKEN_RESPONSE_TYPE_JSON;
    protected $requestTokenParams = array(
        'code' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'client_secret' => '%s',
    );

    protected $getUserInfoUrl = 'https://api.vk.com/method/users.get';
    protected $getUserInfoParams = array(
        'fields' => 'uid,first_name,last_name,sex,photo_big,bdate',
        'access_token' => 'access_token'
    );

    protected function parserUserInfo($arInfo) {

        $arFields = array(
            "UF_UID"      => 'uid',
            "UF_IDENTITY" => 'uid',
            "LOGIN"       => null,
            "EMAIL"       => null,
            "NAME"        => 'first_name',
            "LAST_NAME"   => 'last_name',
            "PERSONAL_BIRTHDAY" => 'bdate',
            "PERSONAL_GENDER"   => 'sex',
            "AVATAR" => 'photo_big',
        );

        $arSource = (array)$arInfo['response'][0];

        foreach ($arFields as $k => &$v) {
            $v = isset($arSource[$v]) ? $arSource[$v]: null;

            if(in_array($k, array('EMAIL', 'LOGIN'))) {
                $v = $this->email;
            }

            if($v === null) {
                unset($arFields[$k]);
                continue;
            }

            if($k == 'PERSONAL_BIRTHDAY') {
                $stamp = $this->getTimeStamp($v);
                if($stamp !== false) {
                    $v = date('d.m.Y', $stamp);
                }
            } elseif($k == 'UF_IDENTITY') {
                $v = 'https://vk.com/id'.$v;

            } elseif($k == 'PERSONAL_GENDER') {
                $v = $v == 2 ? 'M' : 'F';
            }
        }
		$class=new \ReflectionClass(__CLASS__);
        $arFields['UF_SERVICES'] = strtolower($class->getShortName());

        return $arFields;
    }
}