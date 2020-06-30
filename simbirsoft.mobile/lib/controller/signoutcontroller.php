<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\MobileUserTokenTable;
use Simbirsoft\Mobile\MobileTokenTable;

class SignOutController implements Routable {
    private $application;
    
    public function __construct($app) {
        $this->application = $app;
    }

    public function get() {
        global $USER;
        $USER->Logout();
        $out = new \stdClass();
        $token = htmlspecialchars($_SERVER['HTTP_TOKEN']);
        if ($token) {
            $out->success = true;
            return json_encode($out);
        } else {
            header("HTTP/1.1 401 Unauthorized");
        }
        return ;
    }

    public function post() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }
}
