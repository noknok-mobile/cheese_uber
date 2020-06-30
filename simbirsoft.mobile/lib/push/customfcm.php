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
    private $url = "https://fcm.googleapis.com/fcm/send";
    private $token;

    public function pushNotification(string $userEmail, array $params) {
       

        $logger = new Logger('mobileapi.log', Logger::DEBUG_LEVEL_LOG, $_SERVER['DOCUMENT_ROOT'] . '/_log');

        if (extension_loaded('curl')) {
			$token = Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_FCM_TOKEN');
			 $header = [
				"Authorization: key=" . $token,
				"Content-Type: application/json; charset=utf-8"
			];
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
                $postData["notification"]["title"] = $params['title'];
                $postData["notification"]["body"] = $params['body'];
                $postData["notification"]['sound'] = 'default';
                $postData["notification"]['icon'] = 'ic_notification';
                //$notification["click_action"] = $action;
                //$notification["text"] = $description;
                if (!empty($params['property']['action'])) {
                    $postData["notification"]['action'] = 'action';
                    $postData["notification"]['id'] = (string)$params['property']['action'];
                } elseif (!empty($params['property']['order'])) {
                    $postData["notification"]['action'] = 'order';
                    $postData["notification"]['id'] = (string)$params['property']['order'];
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
				     $out = new \stdClass();
					 $out->postData = $postData;
					 $out->headers = $header;
					 $out->url = $this->url;
				$out->response = $response;
            return $out;

            // close curl resource to free up system resources 
            curl_close($ch);
        } else {
            $logger->log('Curl not enabled');
        }
    }
}
