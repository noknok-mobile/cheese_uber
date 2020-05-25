<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;


class Odnoklassniki extends AbstractAdapter {
    protected $addCredentials = array(
        'grant_type' => 'authorization_code',
        'scope' => 'VALUABLE_ACCESS'
    );

    protected $loginDialogUrl = 'http://www.odnoklassniki.ru/oauth/authorize';

    protected $loginDialogParams = array(
        'scope' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'response_type' => '%s'
    );

    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 378;



    protected $requestTokenUrl = 'http://api.odnoklassniki.ru/oauth/token.do';
    protected $requestTokenMethod = HTTP_METH_POST;
    protected $requestTokenResponseType = self::TOKEN_RESPONSE_TYPE_JSON;
    protected $requestTokenParams = array(
        'code' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'client_secret' => '%s',
        'grant_type' => '%s',
    );


    protected $getUserInfoUrl = 'http://api.odnoklassniki.ru/fb.do';
    protected $getUserInfoParams = array(
        'method' => 'users.getCurrentUser',
        'access_token' => 'access_token',
        'application_key' => '%s',
        'format' => 'json',

    );


    public function getUserInfo($token, $callback = null) {
        $this->getUserInfoParams['application_key'] = $this->credentials['public_key'];
        $sign = md5("application_key={$this->credentials['public_key']}format=jsonmethod=users.getCurrentUser" . md5("{$token}{$this->credentials['client_secret']}"));
        $this->getUserInfoParams['sig'] = $sign;
        $this->getUserInfoParams['access_token'] = $token;

        return parent::getUserInfo($token, $callback);

    }

    protected function parserUserInfo($arInfo) {

        /**
         * Не дают email
         */

        $arFields = array(
            "UF_UID"      => 'uid',
            "UF_IDENTITY" => 'link',
            "LOGIN"       => 'email',
            "EMAIL"       => 'email',
            "NAME"        => 'first_name',
            "LAST_NAME"   => 'last_name',
            "PERSONAL_BIRTHDAY" => 'birthday',
            "PERSONAL_GENDER"   => 'gender',
            "AVATAR" => 'pic_3',
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
            } elseif ($k == 'AVATAR') {
                $arFile = array_merge(\CFile::MakeFileArray($v), ["MODULE_ID" => "main"]);
                $ext = end(explode('/', $arFile["type"]));
                $arFile["name"] .= '.'.$ext;
                $rer = \CFile::SaveFile($arFile, "simbirsoft");
                $arFile = \CFile::MakeFileArray($rer);
                $v = $arFile['tmp_name'];
            }

        }
		$class=new \ReflectionClass(__CLASS__);
        $arFields['UF_SERVICES'] = strtolower($class->getShortName());

        return $arFields;


    }

} 