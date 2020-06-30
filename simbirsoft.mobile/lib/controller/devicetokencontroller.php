<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\MobileTokenTable;
use Simbirsoft\Mobile\General\Main;

class DeviceTokenController implements Routable {
    public $platforms = [
        'ios' => MobileTokenTable::SERVICE_IOS,
        'android' => MobileTokenTable::SERVICE_ANDROID,
    ];

    public function post() {
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $out = new \stdClass();
        if (!empty($postJson['token']) && !empty($postJson['platform'])) {
            if (self::setMobileToken($postJson))
                $out->success = true;
            else
                $out->success = false;
            return json_encode($out);
        } else {
            $out->errors[] = Main::addError('0x011','', 'Некорректные параметры запроса');
            print json_encode($out);
        }
        
        header("HTTP/1.1 200 OK");
        
        return \Bitrix\Main\Web\Json::encode($out,true);
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

    public function setMobileToken($postJson) {
        if (
            !empty($postJson['token'])
            && !empty($postJson['platform'])
            && in_array($postJson['platform'], array_keys($this->platforms))
        ) {
            $mobile_service = $this->platforms[$postJson['platform']];
            return MobileTokenTable::setToken($postJson['token'], $mobile_service);
        }
    }
}