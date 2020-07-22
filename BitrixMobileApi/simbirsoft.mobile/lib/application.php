<?php

namespace Simbirsoft\Mobile;

//require_once dirname(__FILE__).'/Respect/Rest/Router.php';

use Respect\Rest\Router;

/**
 * Class Application
 * @package Simbirsoft\Mobile
 */
Class Application {

    private $request;
    const DIRPATH = '/mobileapp/api';
    private $namespace = '\Simbirsoft\Mobile\Controller\\';

    // Register route controllers
    private $controllers = [
        '/elements' => 'SSIblockElementController',
        '/checkmail' => 'CheckMailcontroller',
        '/devicetoken' => 'DeviceTokenController',
        '/basket' => 'BasketController',
        '/order' => 'OrderController',
        '/getorders' => 'GetOrdersController',
        '/recover' => 'RecoverController',
        '/signin' => 'SignInController',
        '/signout' => 'SignOutController',
        '/register' => 'RegisterController',
        '/profile' => 'ProfileController',
        '/editProfile' => 'ProfileEditController',
        '/editAddrese' => 'AddreseEditController',
        '/category' => 'CategoryElementController',
        '/product' => 'ProductElementController',
        '/storage' =>'StorageElementController',
        '/sity' =>'SityElementController',
        '/payment' =>'PaymentController',
        '/discount' =>'DiscountElementController'

    ];
    private $controllersSign = [
        '/profile/edit' => 'ProfileEditController',
        '/profile' => 'ProfileController',
    ];

    public function __construct($req) {
        $this->request = $req;
    }

    public function run() {
        $r3 = new Router(self::DIRPATH);
        $r3->isAutoDispatched = false;

        $authRoutine = function() {
            global $USER;

            if (!empty($_SERVER['HTTP_TOKEN'])) {
                $token = htmlspecialchars($_SERVER['HTTP_TOKEN']);
                $user_id = MobileUserTokenTable::findUserIdForToken($token);
                if ($user_id && $USER->Authorize($user_id)) {
                    return true;
                }
            }

            header("HTTP/1.1 401 Unauthorized");
            return false;
        };
        $curpage = $this->getRequest()->getRequestedPage();
        $curpageShort = str_replace(self::DIRPATH, '', $curpage);

        if ($curpage == self::DIRPATH . '/register'){
            $r3->post('/register', $this->namespace . 'RegisterController', [$this]);
        } elseif(key_exists($curpageShort, $this->controllers)) {
            foreach ($this->controllers as $path => $controller) {
                if (!empty($_SERVER['HTTP_TOKEN'])) {
                    $r3->post('/signin', $this->namespace . 'SignInController', [$this]);
                    $r3->post('/refreshtoken', $this->namespace . 'RefreshTokenController');
                    $r3->post('/recover', $this->namespace . 'RecoverController');
                    $r3->any($path, $this->namespace . $controller, [$this])->by($authRoutine);
                } else {
                    $r3->any($path, $this->namespace . $controller, [$this]);
                }
            }
        } else {
            $r3->post('/signin', $this->namespace . 'SignInController', [$this]);
            $r3->post('/refreshtoken', $this->namespace . 'RefreshTokenController');
            $r3->post('/recover', $this->namespace . 'RecoverController');
            foreach ($this->controllersSign as $path => $controller) {
                $r3->any($path, $this->namespace . $controller, [$this])->by($authRoutine);
            }

        }
        $out = $r3->run();

        $dis = $r3->routeDispatch();
        if (empty($dis->route)) {
            return [
                'code' => 404,
                'message' => 'Not Found',
            ];
        }

        return $out;
    }
    
    public function getRequest() {
        return $this->request;
    }
}