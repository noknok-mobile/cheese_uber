<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;


class GooglePlus extends AbstractAdapter {

    protected $addCredentials = array(
        'scope' => 'https://www.googleapis.com/auth/userinfo.profile email',
        'display' => 'popup',
        'access_type' => 'offline',
        'approval_prompt' => 'force',
        'grant_type' => 'authorization_code',
    );

    protected $loginDialogUrl = 'https://accounts.google.com/o/oauth2/auth';

    protected $loginDialogParams = array(
        'scope' => '%s',
        'display' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'response_type' => '%s'
    );

    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 448;



    protected $requestTokenUrl = 'https://accounts.google.com/o/oauth2/token';
    protected $requestTokenMethod = HTTP_METH_POST;
    protected $requestTokenResponseType = self::TOKEN_RESPONSE_TYPE_JSON;
    protected $requestTokenParams = array(
        'code' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'client_secret' => '%s',
        'grant_type' => '%s',
    );


    protected $getUserInfoUrl = 'https://www.googleapis.com/plus/v1/people/me';
    protected $getUserInfoParams = array(
        'access_token' => 'access_token'
    );

    protected function parserUserInfo($arInfo) {
        $arFields = array(
            "UF_UID"      => 'id',
            "UF_IDENTITY" => 'url',
            "LOGIN"       => 'emails',
            "EMAIL"       => 'emails',
            "NAME"        => 'name',
            "LAST_NAME"   => 'name',
            "PERSONAL_GENDER"   => 'gender',
            "AVATAR" => 'image'
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
            } elseif($k == 'NAME') {
                $v = $v->givenName;
            } elseif($k == 'LAST_NAME') {
                $v = $v->familyName;
            } elseif($k == 'PERSONAL_GENDER') {
                $v = $v == 'male' ? 'M' : 'F';
            } elseif(in_array($k, array('EMAIL', 'LOGIN'))) {
                $v = $v[0]->value;
            } elseif ($k == 'AVATAR') {
                $v = stristr($v->url, '?', true);
            }
        }

        $class=new \ReflectionClass(__CLASS__);
        $arFields['UF_SERVICES'] = strtolower($class->getShortName());

        return $arFields;

    }


}
