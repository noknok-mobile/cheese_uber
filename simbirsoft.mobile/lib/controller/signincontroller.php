<?php

namespace Simbirsoft\Mobile\Controller;

use Bitrix\Main\DB\Exception;
use Respect\Rest\Routable;
use Simbirsoft\Mobile\MobileUserTokenTable;
use Simbirsoft\Mobile\MobileTokenTable;
use Bitrix\Main\UserTable;
use Simbirsoft\Mobile\UsersocTable;
use Simbirsoft\Mobile\Authentication\Adapter\AdapterFactory;
use Simbirsoft\Mobile\General\Main;

class SignInController implements Routable {
    public $platforms = [
        'ios' => MobileTokenTable::SERVICE_IOS,
        'android' => MobileTokenTable::SERVICE_ANDROID,
    ];
    private $_arSocials = [];

    public function post() {
        $USER = new \CUser();
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $folder = \Simbirsoft\Mobile\General\Main::getModuleFolder(__DIR__);
        $path = $_SERVER['DOCUMENT_ROOT'].'/'.$folder.'/modules/simbirsoft.mobile/social.json';
        if (file_exists($path) && is_readable($path)) {
            $socialConf = file_get_contents($path, FILE_USE_INCLUDE_PATH);
            $this->_arSocials = json_decode($socialConf, true);
        }
        $out = new \stdClass();
        if (!empty($postJson['login']) && !empty($postJson['pass'])) {
            //$res = $USER->Login(strip_tags($postJson['login']), strip_tags($postJson['pass']), 'Y');
            $res = $this->checkUser($USER, strip_tags($postJson['login']), strip_tags($postJson['pass']));
            $out = new \stdClass();
            if ($res === true) {
                $current_user_id = $USER->GetID();
                $out->id = $current_user_id;
                $_SESSION['BX_SESSION_TERMINATE_TIME'] = strtotime('+1 day', $_SESSION['SESS_TIME']);
                if (
                    !empty($postJson['token'])
                    && !empty($postJson['platform'])
                    && in_array($postJson['platform'], array_keys($this->platforms))
                ) {
                    $mobile_service = $this->platforms[$postJson['platform']];
                    $mobile_token_id = MobileTokenTable::setTokenForUser($postJson['token'], $mobile_service);
                }

                list($out->token, $out->refresh_token) = MobileUserTokenTable::createTokenForUser($USER->getId(), (int)$mobile_token_id);
                print json_encode($out);
                return;
            } else {
                $out->errors = [];
                $out->errors[] = Main::addError('0x001','login', $res['MESSAGE']);
                print json_encode($out);
            }
        } elseif (!empty($postJson['social'])) {
            \Bitrix\Main\Loader::IncludeModule('socialservices');
            if (!empty($this->_arSocials[$postJson['social']])) {
                $arSocial = $this->_arSocials[$postJson['social']];
                $clientID = $this->GetSocServOptionValue($arSocial['id'], $arSocial['default_id']);
                $clientSecret = $this->GetSocServOptionValue($arSocial['secret'], $arSocial['default_secret']);
                if (empty($clientID) || empty($clientSecret)) {
                    $out->errors = [];
                    $out->errors[] = Main::addError('0x015','', 'Отсутствует APP_ID или APP_SECRET');
                    print json_encode($out);
                }

                if ($postJson['get_params']) {
                    $arResult = array(
                        "ID" => $clientID,
                        "SECRET" => $clientSecret
                    );
                    print json_encode($arResult);
                } elseif(!empty($postJson["social_token"])) {
                    $that = $this;
                    $obSocUser = AdapterFactory::createUserObject($postJson['social'], array("client_id" => $clientID, "client_secret" => $clientSecret, "public_key" => $arSocial['public_key'] ));
                    $obSocUser->getUserInfo($postJson["social_token"], function($arFields) use($that, $postJson){
                        if (!empty($postJson['email'])) {
                            $arFields["EMAIL"] = $arFields["LOGIN"] = $postJson['email'];
                        } else {
                            $arFields["LOGIN"] = md5($postJson['social_token']);
                            $arFields["EMAIL"] = $arFields["LOGIN"]."@email.test";
                        }

                        $user = new \CUser();
                        if ($USER_ID = $that->isLinkedUser($arFields['UF_UID'], $arFields['UF_SERVICES'])) {
                            $user->Authorize($USER_ID);
                            self::setMobileToken($postJson);
                            $that->afterAvtorize($user, $postJson);
                        } else {
                            $rsUser = $user->GetByLogin($arFields['EMAIL']);
                            $arUser = $rsUser->Fetch();
                            if (!$arUser) {
                                if ($USER_ID = $that->registerNewUser($user, $arFields)) {
                                    $user->Authorize($USER_ID);
                                    self::setMobileToken($postJson);
                                    $that->afterAvtorize($user, $postJson, true);
                                } else {
                                    $out = new \stdClass();
                                    $out->errors[] = Main::addError('0x002','', 'Ошибка привязки пользователя к системе');
                                    print json_encode($out);
                                }
                            } else {
                                $out = new \stdClass();
                                $out->errors[] = Main::addError('0x022','', 'Пользователь с данным email уже зарегистрирован в системе');
                                print json_encode($out);
                            }
                        }
                    });
                } else {
                    $out->errors[] = Main::addError('0x021','', 'Отсутствует праметр social_token или email');
                    print json_encode($out);
                }
            } else {
                $out->errors[] = Main::addError('0x031','', "Некорректный параметр social. Доступные значения: " . implode(array_keys($this->_arSocials), ', '));
                print json_encode($out);
            } 
        }else {
				$out->errors[] = Main::addError('0x001','login', 'No login info');
                print json_encode($out);
				
		}
        header("HTTP/1.1 200 OK");
        return ;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

    protected function GetSocServOptionValue($sOptionCode, $sDefValue = '') {
        $sReturn = strlen($sOptionCode) ? trim(\CSocServAuth::GetOption($sOptionCode)) : '';
        $sReturn = strlen($sReturn) ? $sReturn : $sDefValue;
        return $sReturn;
    }

    public function isLinkedUser($uid, $service) {
        $mReturn = false;
        // получаем привязку к аккаунту из соц сети
        $dbItems =  UsersocTable::GetList(
            array(
                'order' => array(
                    'ID' => 'DESC'
                ),
                'filter' => array(
                    '=UF_UID' => $uid,
                    '=UF_SERVICES' => $service,
                    '!UF_USER_ID' => false
                ),
            )
        );
        while ($arItem = $dbItems->Fetch()) {
            if ($arItem['UF_USER_ID']) {
                $mReturn = $arItem['UF_USER_ID'];
                break;
            }
        }
        return $mReturn;
    }

    public function linkUser($iUserId, $arFields) {
        $arSocData = array(
            'UF_USER_ID' => $iUserId,
            'UF_UID' => isset($arFields['UF_UID']) ? $arFields['UF_UID'] : '',
            'UF_SERVICES' => isset($arFields['UF_SERVICES']) ? $arFields['UF_SERVICES'] : '',
            'UF_IDENTITY' => isset($arFields['UF_IDENTITY']) ? $arFields['UF_IDENTITY'] : ''
        );

        return UsersocTable::add($arSocData);
    }

    public function registerNewUser($user, $arData) {
        $password = randString(8);
        if (!empty($arData['AVATAR'])) {
            $arFile = array_merge(\CFile::MakeFileArray($arData['AVATAR']), ["MODULE_ID" => "main"]);
            $fid = \CFile::SaveFile($arFile, "simbirsoft");
        }

        $arFields = array(
            'LOGIN' => $arData['LOGIN'],
            'EMAIL' => $arData['EMAIL'],
            'NAME' => $arData['NAME'],
            'LAST_NAME' => $arData['LAST_NAME'],
            'PERSONAL_GENDER' => $arData['PERSONAL_GENDER'],
            'PASSWORD' => $password,
            'CONFIRM_PASSWORD' => $password,
            'ACTIVE' => 'Y',
            'PERSONAL_PHOTO' => $arData['AVATAR'] ? \CFile::MakeFileArray($fid) : ""
        );

        $def_group = \COption::GetOptionString('main', 'new_user_registration_def_group', '');
        if (strlen($def_group)) {
            $arUserParam['GROUP_ID'] = explode(',', $def_group);
        }

        if (isset($arData['PERSONAL_BIRTHDAY'])) {
            $arFields['PERSONAL_BIRTHDAY'] = $arData['PERSONAL_BIRTHDAY'];
        }

        $GLOBALS['DB']->StartTransaction();

        $iUserId = intval($user->Add($arFields));

        if ($iUserId) {
            $obAdd = $this->linkUser($iUserId, $arData);
            if (!$obAdd->isSuccess()) {
                $GLOBALS['DB']->Rollback();
                throw new \Exception(join(';', $obAdd->getErrors()));
            }
            \CFile::Delete($fid);
            $GLOBALS['DB']->Commit();

            $arEventHandlers = GetModuleEvents('main', 'OnAfterSocUserRegister', true);
            foreach ($arEventHandlers as $arEvent) {
                ExecuteModuleEventEx($arEvent, array($iUserId, $arData));
            }

            \CUser::SendUserInfo($iUserId, 's1', 'Приветствуем Вас как нового пользователя нашего сайта!', true, 'USER_INVITE');

            return $iUserId;
        }

    }

    private function checkUser(&$user, $login, $pass) {
        $message = 'Некорректный логин или пароль';
        $user_db = UserTable::getRow([
            'filter' => [
                'LOGIN' => $login,
                'ACTIVE' => 'Y',
            ],
        ]);
        if (empty($user_db)) {
            return ['MESSAGE' => $message];
        }

        if (strlen($user_db['PASSWORD']) > 32) {
            $salt = substr($user_db['PASSWORD'], 0, strlen($user_db['PASSWORD']) - 32);
            $db_password = substr($user_db['PASSWORD'], -32);
        } else {
            $salt = '';
            $db_password = $user_db['PASSWORD'];
        }

        $user_password = md5($salt . $pass);

        if ($db_password === $user_password) {
            return $user->Authorize($user_db['ID']);
        } else {
            return ['MESSAGE' => $message];
        }

        return false;
    }

    private function afterAvtorize($USER, $postJson) {
        $out = new \stdClass();
        $current_user_id = $USER->GetID();
        $out->id = $current_user_id;

        $_SESSION['BX_SESSION_TERMINATE_TIME'] = strtotime('+1 day', $_SESSION['SESS_TIME']);

        if (
            !empty($postJson['token'])
            && !empty($postJson['platform'])
            && in_array($postJson['platform'], array_keys($this->platforms))
        ) {
            $mobile_service = $this->platforms[$postJson['platform']];
            $mobile_token_id = MobileTokenTable::setTokenForUser($postJson['token'], $mobile_service);
        }

        list($out->token, $out->refresh_token) = MobileUserTokenTable::createTokenForUser($USER->getId(), (int)$mobile_token_id);
        print json_encode($out);
        return;
    }

    public function setMobileToken($postJson) {
        if (
            !empty($postJson['token'])
            && !empty($postJson['platform'])
            && in_array($postJson['platform'], array_keys($this->platforms))
        ) {
            $mobile_service = $this->platforms[$postJson['platform']];
            MobileTokenTable::setTokenForUser($postJson['token'], $mobile_service);
        }
    }
}