<?php
/**
 * Created by PhpStorm.
 * User: dmsk
 * Date: 28.12.2017
 * Time: 15:21
 */

namespace Simbirsoft\Mobile\Authentication\Adapter;


use Bitrix\Main\DB\Exception;

if(!defined('HTTP_METH_GET')) {
    define('HTTP_METH_GET', 1);
}
if(!defined('HTTP_METH_POST')) {
    define('HTTP_METH_POST', 3);
}


abstract class AbstractAdapter {

    const TOKEN_RESPONSE_TYPE_JSON  = 2;
    const TOKEN_RESPONSE_TYPE_QUERY = 4;

    /**
     * Создатели api vk решили передавать email пользователя вместе с token'ом.
     * Из всех соц. сетей так делают только они.
     * ...
     */
    protected $email;

    /**
     * @var array параметры объекта
     */
    protected $credentials = array(
        'client_id'     => '%s',
        'client_secret' => '%s',
        'public_key'    => '%s',
        'redirect_uri'  => '%s',
        'response_type' => 'code'
    );

    //дополнительные параметры из родительского класса
    protected $addCredentials = array();

    protected $loginDialogUrl = '';
    protected $loginDialogParams = array();

    public $loginDialogWidth  = 656;
    public $loginDialogHeight = 378;


    //ссылка на запрос токена
    protected $requestTokenUrl;
    protected $requestTokenMethod;
    protected $requestTokenResponseType;
    protected $requestTokenParams = array();


    protected $getUserInfoUrl;
    protected $getUserInfoParams = array();



    public function __construct(array $params) {
        $this->setCredentials($params);
    }

    public function setRedirectUri($uri) {
        $this->credentials['redirect_uri'] = $uri;
    }

    /**
     * @return string url to open login dialog
     */
    public function getLoginDialogUrl() {
        $loginDialogParams = $this->getParams($this->loginDialogParams);

        return $this->loginDialogUrl .'?'. \http_build_query($loginDialogParams);
    }


    /**
     * Параметры приложения в соц сети
     *
     * @param array $params
     */
    private function setCredentials($params) {
        foreach($this->credentials as $k => &$v) {
            if(isset($params[$k])) {
                $v = $params[$k];
            }
        }

        $this->credentials = array_merge($this->credentials, $this->addCredentials);

    }

    protected function getParams($needKeys) {
        return array_intersect_key($this->credentials, $needKeys);
    }

    protected function makeRequest($url, $params, $method, $requestTokenResponseType=null) {
        if(is_array($params)) {
            $params = http_build_query($params);
        }

        if( $curl = curl_init() ) {
            if($method === HTTP_METH_GET) {
                curl_setopt($curl, CURLOPT_URL, $url .'?'. $params);
            } elseif($method === HTTP_METH_POST) {
                curl_setopt($curl, CURLOPT_URL, $url);
                curl_setopt($curl, CURLOPT_POST, true);
                curl_setopt($curl, CURLOPT_POSTFIELDS, $params);
                curl_setopt($curl, CURLOPT_HTTPHEADER, array("Content-Type: application/x-www-form-urlencoded", "Content-length: ". strlen($params)));
            } else {
                throw new \Exception('http method error');
            }

            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

            if(!$response = curl_exec($curl)) {
                throw new \Exception(curl_error($curl));
            }

            $http_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);

            //ловим ошибки
            if($http_code !== 200) {
                $error = 'http code is:'. $http_code;
                switch($http_code) {
                    case 400:
                        $error = "400 Bad Request";break;
                    case 403:
                        $error = "403 Forbidden";break;
                    case 500:
                        $error = "500 Internal Server Error";break;
                    case 501:
                        $error = "501 Not Implemented";break;
                }
                throw new \Exception($error .'; response:('. $response .')');
            }

            curl_close($curl);

            switch($requestTokenResponseType) {
                case self::TOKEN_RESPONSE_TYPE_QUERY:
                    return $this->queryDecodeCallback($response);

                case self::TOKEN_RESPONSE_TYPE_JSON:
                    return $this->jsonDecodeCallback($response);
            }

        } else {
            throw new \Exception("curl_init error!");
        }

        return false;
    }

    private function jsonDecodeCallback($string) {
        $obJson = json_decode($string);
        if($obJson === null || json_last_error()) {
            throw new \Exception("JSON decode error");
        }

        return (array)$obJson;
    }

    private function queryDecodeCallback($string) {

        $arResponse = null;
        if (parse_url($string, PHP_URL_QUERY)){
            parse_str($string, $arResponse);
        } else {
            $arResponse = json_decode($string);
            if(empty($arResponse)){
                throw new \Exception('get token error. input string not json or query');
            }

        }

        if(!isset($arResponse['access_token'])) {
            throw new \Exception('get token error');
        }

        return $arResponse;
    }


    /**
     * Функция получает токен авторизации по коду
     * @param $code
     * @param null $callback
     * @return mixed
     * @throws Exception
     * @throws YandexMoneyException
     * @throws \Exception
     */
    public function getToken($code, $callback=null) {

        $requestTokenParams = $this->getParams($this->requestTokenParams);

        $requestTokenParams['code'] = $code;

        //Получаем токен
        $arResponse = $this->makeRequest($this->requestTokenUrl, $requestTokenParams, $this->requestTokenMethod, $this->requestTokenResponseType);

        if(!is_array($arResponse) || !isset($arResponse['access_token'])) {
            throw new Exception('Get token error');
        }

        if(isset($arResponse['email'])) {
            $this->email = $arResponse['email'];
        }

        //передаем полученные данные в колбек
        if(is_callable($callback)) {
            return call_user_func($callback, $arResponse['access_token']);
        }


        return $arResponse['access_token'];
    }

    /**
     * Получаем данные пользователя
     *
     * @param $token
     * @param null $callback
     * @return array|bool|mixed
     * @throws Exception
     * @throws YandexMoneyException
     * @throws \Exception
     */
    public function getUserInfo($token, $callback=null) {
        $params = array();
        foreach($this->getUserInfoParams as $k=>$v) {

            if($v === 'access_token') {
                $params[$k] = $token;
            } else {
                $params[$k] = $v;
            }
        }

        //выполняем запрос на API и получаем данные пользователя
        try {
            $arInfo = $this->makeRequest($this->getUserInfoUrl, $params, HTTP_METH_GET, AbstractAdapter::TOKEN_RESPONSE_TYPE_JSON);
        }
        catch (\Exception $e) {
            $out = new \stdClass();
            $out->errors[] = \Simbirsoft\Mobile\General\Main::addError('0x001','', 'Ошибка авторизации через соцсеть');
            print json_encode($out);
            die();
        }


        //сопоставляем поля
        $arFields = $this->parserUserInfo($arInfo);
        //передаем полученные данные в колбек
        if(is_callable($callback)) {
            return call_user_func($callback, $arFields);
        }

        return $arFields;
    }

    abstract protected function parserUserInfo($arInfo);



    protected function getTimeStamp($dateString) {
        $arDate = date_parse($dateString);
        if(sizeof($arDate['errors']) === 0) {
            if(checkdate($arDate['month'], $arDate['day'], $arDate['year'])) {
                return  mktime($arDate['hour'], $arDate['minute'], $arDate['second'], $arDate['month'], $arDate['day'], $arDate['year']);
            }
        }

        return false;
    }


}