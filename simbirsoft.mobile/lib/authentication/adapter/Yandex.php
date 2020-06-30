<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;


class Yandex extends AbstractAdapter {

    protected $addCredentials = array(
        'display' => 'popup',
        'grant_type' => 'authorization_code',
    );

    protected $loginDialogUrl = 'https://oauth.yandex.ru/authorize';

    protected $loginDialogParams = array(
        'scope' => '%s',
        'display' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'response_type' => '%s'
    );


    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 378;


    protected $requestTokenUrl = 'https://oauth.yandex.ru/token';
    protected $requestTokenMethod = HTTP_METH_POST;
    protected $requestTokenResponseType = self::TOKEN_RESPONSE_TYPE_JSON;
    protected $requestTokenParams = array(
        'code' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'client_secret' => '%s',
        'grant_type' => '%s',
    );

    protected $getUserInfoUrl = 'https://login.yandex.ru/info';
    protected $getUserInfoParams = array(
        'format' => 'json',
        'oauth_token' => 'access_token'
    );

    protected function parserUserInfo($arInfo) {

        $arFields = array(
            "UF_UID"      => 'id',
            "UF_IDENTITY" => 'link',
            "LOGIN"       => 'default_email',
            "EMAIL"       => 'default_email',
            "NAME"        => 'first_name',
            "LAST_NAME"   => 'last_name',
            "PERSONAL_BIRTHDAY" => 'birthday',
            "PERSONAL_GENDER"   => 'sex',
        );

        $arSource = (array)$arInfo;

        foreach ($arFields as $k => &$v) {
            $v = isset($arSource[$v]) ? $arSource[$v]: null;

            if($v === null) {
                unset($arFields[$k]);
                continue;
            }

            if($k == 'PERSONAL_BIRTHDAY') {
                $stamp = $this->getTimeStamp($v);
                if($stamp !== false) {
                    $v = date('d.m.Y', $stamp);
                }
            } elseif($k == 'PERSONAL_GENDER') {
                $v = $v == 'male' ? 'M' : 'F';
            }
        }

        $class=new \ReflectionClass(__CLASS__);
        $arFields['UF_SERVICES'] = strtolower($class->getShortName());
		
        return $arFields;
    }
} 