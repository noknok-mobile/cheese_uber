<?php

namespace Simbirsoft\Mobile\Push;

use Simbirsoft\Mobile\Logger;
use Bitrix\Main\Config\Option;

/**
 * Description of FCM
 *
 * @author rodial
 */
class CustomFCM {
    private $url = "http://fcm.googleapis.com/fcm/send";
    private $token;

    public function pushNotification(string $userEmail, array $params) {
        $header = [
            "Authorization: key=" . $this->token,
            "Content-Type: application/json; charset=utf-8"
        ];

        $logger = new Logger('mobileapi.log', Logger::DEBUG_LEVEL_LOG, $_SERVER['DOCUMENT_ROOT'] . '/_log');

        if (extension_loaded('curl')) {
			$token = Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_FCM_TOKEN');
            // create curl resource 
            $ch = curl_init(); 
            curl_setopt($ch, CURLOPT_URL, $this->url); 
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
            curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
            //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);


                $postData = [];
                $postData["to"] = "/topics/".$userEmail;

                $notification = [];
                $postData["data"]["title"] = $params['title'];
                $postData["data"]["body"] = $params['body'];
                $postData["data"]['sound'] = 'default';
                $postData["data"]['icon'] = 'ic_notification';
                //$notification["click_action"] = $action;
                //$notification["text"] = $description;
                if (!empty($params['property']['action'])) {
                    $postData["data"]['action'] = 'action';
                    $postData["data"]['id'] = (string)$params['property']['action'];
                } elseif (!empty($params['property']['order'])) {
                    $postData["data"]['action'] = 'order';
                    $postData["data"]['id'] = (string)$params['property']['order'];
                }

                $json_a = json_encode($postData, JSON_UNESCAPED_UNICODE);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $json_a);
                // $output contains the output string 
                $response = curl_exec($ch);

                if (Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_LOG', 'N') == 'Y') {
                    $output = 'Request: ' . $json_a . "\n";
                    if ($response === false) {
                        $response = 'Error';
                    }
                    $output .= 'Response: ' . $response . "\n";
                    $logger->log($output);
                }
            return json_encode($response);

            // close curl resource to free up system resources 
            curl_close($ch);
        } else {
            $logger->log('Curl not enabled');
        }
    }
}
