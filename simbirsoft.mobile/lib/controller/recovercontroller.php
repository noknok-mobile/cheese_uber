<?php

namespace Simbirsoft\Mobile\Controller;

use Bitrix\Main\UserTable;
use Respect\Rest\Routable;
use Bitrix\Main\Loader;
use Simbirsoft\Mobile\General\Main;


class RecoverController implements Routable {

    public function post() {
        $post_data = file_get_contents('php://input');
        $post_json = json_decode($post_data, true);
        $out = new \stdClass();

        if (empty($post_json['email']) || !check_email($post_json['email'])) {
            $out->errors[] = Main::addError('0x011','email', 'Не заполнены поля в запросе или неверно введен email');
            print json_encode($out);
            header("HTTP/1.1 200 OK");
            return false;
        }

        if (UserTable::getRow(['filter' => ['EMAIL' => $post_json['email']]])) {
            $result = \CUser::SendPassword("", htmlspecialchars($post_json['email']), SITE_ID);
            if ($result['TYPE'] == 'OK') {
                return json_encode(['success' => true]);
            } else {
                header('HTTP/1.1 404 Not Found');
                return false;
            }
        } else {
            $out->errors[] = Main::addError('0x011','email', 'Указанный email не найден в базе данных');
            print json_encode($out);
            header("HTTP/1.1 200 OK");
            return false;
        }

    }
}