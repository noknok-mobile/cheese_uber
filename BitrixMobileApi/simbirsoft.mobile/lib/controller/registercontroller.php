<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\MobileUserTokenTable;
use Simbirsoft\Mobile\MobileTokenTable;
use Simbirsoft\Mobile\General\Main;

class RegisterController implements Routable {
    private $application;

    public function __construct($app) {
        $this->application = $app;
    }

    public function post() {
        $USER = new \CUser();
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        if (
            !empty($postJson['email'])
            && !empty($postJson['pass'])
            && !empty($postJson['phone'])
        ) {
            $res = $this->checkUser($USER, strip_tags($postJson['email']),
                strip_tags($postJson['phone']));
            $out = new \stdClass();
            if ($res === true) {
                $fields = [
                    'LOGIN' => $postJson['email'],
                    'EMAIL' => $postJson['email'],
                    'NAME' => $postJson['name'],
                    'LAST_NAME' => $postJson['last_name'],
                    'PASSWORD' => $postJson['pass'],
                    'CONFIRM_PASSWORD' => $postJson['pass'],

                ];
                $user = new \CUser;
                $result = $user->add($fields);
                if (!$result){
                    $out->errors[] = Main::addError('0x002','', 'Ошибка регистрации');
                    print json_encode($out);
                } else {
                    $user->Update($result, ['ACTIVE' => 'Y', 'PERSONAL_PHONE' => $postJson['phone']]);
                    $user->Authorize($result);
                    GLOBAL $USER;
                    $current_user_id = $USER->GetID();
                    $out->id = $current_user_id;
                    $_SESSION['BX_SESSION_TERMINATE_TIME'] = strtotime('+1 day', $_SESSION['SESS_TIME']);

                    $platforms = [
                        'ios' => MobileTokenTable::SERVICE_IOS,
                        'android' => MobileTokenTable::SERVICE_ANDROID,
                    ];
                    if (
                        !empty($postJson['token'])
                        && !empty($postJson['platform'])
                        && in_array($postJson['platform'], array_keys($platforms))
                    ) {
                        $mobile_service = $platforms[$postJson['platform']];
                        $mobile_token_id = MobileTokenTable::setTokenForUser($postJson['token'], $mobile_service);
                    }

                    list($out->token, $out->refresh_token) = MobileUserTokenTable::createTokenForUser($USER->getId(), (int)$mobile_token_id);

                    print json_encode($out);
                }
                return;
            } else {
                $out->errors = [];
                if (!empty($res['MESSAGE'])) {
                    $out->errors[] = Main::addError('0x022', 'login', $res['MESSAGE']);
                }
                print json_encode($out);
            }
        } else {
            $out = new \stdClass();
            $out->errors[] = Main::addError('0x021','login', 'Не заполнены поля в запросе');
            print json_encode($out);
        }

        header("HTTP/1.1 200 OK");
        return;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

    private function checkUser(&$user, $email, $phone) {
        $message = 'Пользователь с таким email уже зарегистрирован';
        $user = \Bitrix\Main\UserTable::getList([
            'filter' => ["LOGIC" => "OR", '=EMAIL' => $email, '=LOGIN' => $email]
        ])->fetch();
        if (!$user){
            return true;
        } else {
            return ['MESSAGE' => $message];
        }
        return;
    }
}
