<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;


class MailRu extends AbstractAdapter {
    protected $addCredentials = array(
        'grant_type' => 'authorization_code',
    );

    protected $loginDialogUrl = 'https://connect.mail.ru/oauth/authorize';

    protected $loginDialogParams = array(
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'response_type' => '%s'
    );

    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 378;



    protected $requestTokenUrl = 'https://connect.mail.ru/oauth/token';
    protected $requestTokenMethod = HTTP_METH_POST;
    protected $requestTokenResponseType = self::TOKEN_RESPONSE_TYPE_JSON;
    protected $requestTokenParams = array(
        'code' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'client_secret' => '%s',
        'grant_type' => '%s',
    );


    protected $getUserInfoUrl = 'http://www.appsmail.ru/platform/api';
    protected $getUserInfoParams = array(
        'app_id' => '%s',
        'secure' => '1',
        'session_key' => '%s',
        'method' => 'users.getInfo',
    );


    public function getUserInfo($token, $callback=null) {

        $this->getUserInfoParams['app_id'] = $this->credentials['client_id'];
        $this->getUserInfoParams['session_key'] = $token;

        $sign = md5("app_id={$this->credentials['client_id']}method=users.getInfosecure=1session_key={$token}{$this->credentials['client_secret']}");

        $this->getUserInfoParams['sig'] = $sign;

        return parent::getUserInfo($token, $callback);

    }

    /**
     * @param $arInfo
     * @return array
     */
    protected function parserUserInfo($arInfo) {

        $arFields = array(
            "UF_UID"      => 'uid',
            "UF_IDENTITY" => 'link',
            "LOGIN"       => 'email',
            "EMAIL"       => 'email',
            "NAME"        => 'first_name',
            "LAST_NAME"   => 'last_name',
            "PERSONAL_BIRTHDAY" => 'birthday',
            "PERSONAL_GENDER"   => 'sex',
            "AVATAR" => 'pic_big',
        );

        $arSource = (array)$arInfo[0];

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
                $v = $v == 0 ? 'M' : 'F';
            }
        }

		$class=new \ReflectionClass(__CLASS__);
        $arFields['UF_SERVICES'] = strtolower($class->getShortName());
        
		
		return $arFields;


    }
}


