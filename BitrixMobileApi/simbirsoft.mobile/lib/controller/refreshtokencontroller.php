<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\MobileUserTokenTable;
use Simbirsoft\Mobile\General\Main;

class RefreshTokenController implements Routable {

    public function post() {
        global $USER;
        $USER = new \CUser();
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);

        if (!empty($postJson['refresh_token'])) {
            $tokens = MobileUserTokenTable::createTokenForRefresh($postJson['refresh_token']);
            if($tokens) {
                $out = new \stdClass();
                //$out->token = $token;
                list($out->token, $out->refresh_token) = $tokens;
                print json_encode($out);
                return;
            } else {
                header("HTTP/1.1 401 Unauthorized");
            }
        } else {
            header("HTTP/1.1 200 OK");
            $out = new \stdClass();
            $out->errors[] = Main::addError('0x011','refresh_token', 'Не заполнены поля в запросе');
            print json_encode($out, JSON_UNESCAPED_UNICODE);
        }
        return ;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }
}