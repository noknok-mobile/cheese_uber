<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;

class CheckMailcontroller implements Routable {
    public function post() {
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);

        $CUSER = new \CUser();
        if (!empty($postJson['email']) && empty($CUSER->GetEmail())) {
            if (\Bitrix\Main\UserTable::getRow(['filter' => ['EMAIL' => $postJson['email']]])) {
                $out = new \stdClass();
                $out->errors[] = Main::addError('0x018','', 'Пользователь с таким email уже зарегистрирован');
                print json_encode($out);
                return ;
            } else {
                $out = new \stdClass();
                $out->success = true;
                return json_encode($out);
            }
            $CUSER->Update($CUSER->GetID(),array('EMAIL' => $postJson['email']));
        }

        header("HTTP/1.1 200 OK");
        return;
    }
    
    private function getError($code) {
        switch ($code) {
            case 1:
                $maxStr = ini_get('upload_max_filesize');
                return 'Превышен допустимый размер файла - ' . $maxStr;
            break;
        }
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }
}
