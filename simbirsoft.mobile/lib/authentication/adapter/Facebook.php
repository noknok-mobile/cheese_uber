<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;



class Facebook extends AbstractAdapter {

    protected $addCredentials = array(
        'scope' => "public_profile,email",
        //'display' => 'popup',
    );

    protected $loginDialogUrl = 'https://www.facebook.com/v2.9/dialog/oauth';

    protected $loginDialogParams = array(
        'scope' => '%s',
        'display' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'response_type' => '%s'
    );

    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 378;

    protected $requestTokenUrl = 'https://graph.facebook.com/oauth/access_token';
    protected $requestTokenMethod = HTTP_METH_GET;
    protected $requestTokenResponseType = self::TOKEN_RESPONSE_TYPE_JSON;
    protected $requestTokenParams = array(
        'code' => '%s',
        'client_id' => '%s',
        'redirect_uri' => '%s',
        'client_secret' => '%s',
    );


    protected $getUserInfoUrl = 'https://graph.facebook.com/me';
    protected $getUserInfoParams = array(
        'fields' => 'id,gender,picture.type(large),first_name,last_name,email,link',
        'access_token' => 'access_token'
    );

    protected function parserUserInfo($arInfo) {
        $arFields = [
            "UF_UID"      => 'id',
            "UF_IDENTITY" => 'link',
            "LOGIN"       => 'email',
            "EMAIL"       => 'email',
            "NAME"        => 'first_name',
            "LAST_NAME"   => 'last_name',
            "PERSONAL_GENDER"   => 'gender',
            "AVATAR" => 'pict'
        ];

        $arSource = (array)$arInfo;
        if (is_object($arSource['picture'])) {
            $arSource['pict'] = $arSource['picture']->data->url;
        }

        foreach ($arFields as $k => &$v) {
            $v = isset($arSource[$v]) ? $arSource[$v]: null;

            if($v === null) {
                unset($arFields[$k]);
                continue;
            }

            if($k == 'PERSONAL_GENDER') {
                $v = $v == 'male' ? 'M' : 'F';
            }
        }

		$class=new \ReflectionClass(__CLASS__);
        $arFields['UF_SERVICES'] = strtolower($class->getShortName());

        return $arFields;
    }
} 