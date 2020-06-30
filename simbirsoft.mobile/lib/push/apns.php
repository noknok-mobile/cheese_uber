<?php

namespace Simbirsoft\Mobile\Push;


use Bitrix\Main\Config\Option;
use Simbirsoft\Mobile\Logger;
use Simbirsoft\Mobile\MobileTokenTable;

/**
 * Description of FCM
 *
 * @author rodial
 */
class APNS {
    private $cert_path;
    private $root_cers_path;


    public function __construct($cert_path, $root_cers_path) {
        $this->cert_path = $cert_path;
        $this->root_cers_path = $root_cers_path;
    }

    public function pushNotification(array $params) {
        require_once dirname(__FILE__) . '/../ApnsPHP/Autoload.php';

        if (Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_LOG', 'N') == 'Y') {
            $logger =  new \stdClass();
            $logger = new Logger('mobileapi.log', Logger::DEBUG_LEVEL_LOG, $_SERVER['DOCUMENT_ROOT'] . '/_log');
        }
        ob_start();
        if (extension_loaded('curl')) {
            $apns_server = \ApnsPHP_Abstract::ENVIRONMENT_PRODUCTION;
            if (\COption::GetOptionString('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_APNS_SERVER', 'prod') == 'sandbox') {
                $apns_server = \ApnsPHP_Abstract::ENVIRONMENT_SANDBOX;
            }
            // Instantiate a new ApnsPHP_Push object
            $push = new \ApnsPHP_Push(
                $apns_server,
                $this->cert_path
            );
            // Set the Provider Certificate passphrase
            // $push->setProviderCertificatePassphrase('test');
            // Set the Root Certificate Autority to verify the Apple remote peer
            $push->setRootCertificationAuthority($this->root_cers_path);

            // Connect to the Apple Push Notification Service
            try {
                $push->connect();
                foreach ($params['tokens']['tokens_ios'] as $device_token) {
                    // Instantiate a new Message with a single recipient
                    $message = new \ApnsPHP_Message($device_token);
                    // Set a custom identifier. To get back this identifier use the getCustomIdentifier() method
                    // over a ApnsPHP_Message object retrieved with the getErrors() message.
                    $message->setCustomIdentifier("Test-notification");
                    // Set a simple welcome text
                    $message->setText($params['title']);
                    // Play the default sound
                    $message->setSound();
                    // Set a custom property
                    foreach ($params['property'] as $property => $val) {
                        $message->setCustomProperty($property, $val);
                    }
                    //$message->setCustomProperty('task', $task_id);
                    // Set the expiry value to 30 seconds
                    $message->setExpiry(30);
                    // Add the message to the message queue
                    $push->add($message);
                }
                // Send all messages in the message queue
                $push->send();
                // Disconnect from the Apple Push Notification Service
                $push->disconnect();

                /* #109290 APNS push recheck ----------------------- */

                $invalidTokens = array();
                $aErrorQueue = $push->getErrors();
                if (!empty($aErrorQueue)) {
                    foreach ($aErrorQueue as $err) {
                        foreach ($err['ERRORS'] as $errCode) {
                            if ($errCode['statusMessage'] == 'Invalid token') {
                                $invalidTokens[] = $err['MESSAGE']->getRecipient();
                                break;
                            }
                        }
                    }
                }

                if (!empty($invalidTokens)) {
                    // remove from tokens array
                    $params['tokens']['tokens_ios'] = array_diff($params['tokens']['tokens_ios'], $invalidTokens);

                    // resend clear push
                    if (!empty($params['tokens']['tokens_ios'])) {
                        $push->connect();
                        foreach ($params['tokens']['tokens_ios'] as $device_token) {
                            $message = new \ApnsPHP_Message($device_token);
                            $message->setCustomIdentifier("Test-notification");
                            $message->setText($params['title']);
                            $message->setSound();
                            foreach ($params['property'] as $property => $val) {
                                $message->setCustomProperty($property, $val);
                            }
                            $message->setExpiry(30);
                            $push->add($message);
                        }
                        $push->send();
                        $push->disconnect();
                    }

                    // remove from DB table
                    MobileTokenTable::deleteByTokens($invalidTokens);
                }

                /*---------------------------------------------------*/

                if (Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_LOG', 'N') == 'Y') {
                    $output = 'APNS Request: message - ' . $params['title'] . ' tokens:' . implode(' ', $params['tokens']['tokens_ios']) . "\n";

                    // Examine the error message container
                    $aErrorQueue = $push->getErrors();
                    if (!empty($aErrorQueue)) {
                        ob_start();
                        print_r($aErrorQueue);
                        $error_arr = ob_get_clean();
                        $output .= 'Response: ' . $error_arr . "\n";
                    } else {
                        $output .= "Response: Ok\n";
                    }
                    $logger->log($output);
                }
            } catch (\Exception $exc) {
                if (Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_LOG', 'N') == 'Y') {
                    $logger->log('APNS Error: ' . $exc->getMessage());
                }
            }
        } else {
            if (Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_LOG', 'N') == 'Y') {
                $logger->log('Curl not enabled');
            }
        }

        $buffer = ob_get_clean();
        if (!empty($buffer)) {
            if (Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_LOG', 'N') == 'Y') {
                $logger->log($buffer);
            }
        }
    }
}