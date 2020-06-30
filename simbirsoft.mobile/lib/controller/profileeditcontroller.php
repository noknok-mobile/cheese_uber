<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Bitrix\Main\UserTable;
use Simbirsoft\Mobile\General\Main;

class ProfileEditController implements Routable {
    public function post() {
        GLOBAL $USER;
        $request = \Bitrix\Main\Context::getCurrent()->getRequest();
        $files = $request->getFileList()->toArray();
        $postJson = $request->toArray();
        $out = new \stdClass();
        if (!empty($postJson['token']) && !empty($postJson['platform'])) {
            $sigmController = new SignInController();
            $sigmController->setMobileToken($postJson);
            return json_encode(['success' => true]);
        }
        foreach ($postJson as $key => $val) {
            if ($key == 'phone')
                continue;
            $postJson[$key] = urldecode($val);
        }
        if (!empty($files['photo'])) {
            $tmpF = $files['photo'];
            if ($tmpF['error'] == 0) {
                $tmpF['MODULE_ID'] = 'main';
                $tmpF['del'] = 'N';
                $maxFileSizeStr = ini_get('upload_max_filesize');// * 1024 * 1024;
                $max = intval($maxFileSizeStr);
                $c = substr($maxFileSizeStr, -1);
                switch ($c){
                    case 'G': $max *= 1024;
                    case 'M': $max *= 1024;
                    case 'K': $max *= 1024;
                }
                $files['photo']['del'] = "Y";
                $files['photo']['MODULE_ID'] = "main";
                $data['PERSONAL_PHOTO'] = $files['photo'];
                $clUser = new \CUser();
                $result = $clUser->Update($USER->GetID(), $data);
                if ($result === true) {
                    return json_encode(['success' => $result]);
                } else {
                    $out->errors[] = Main::addError('0x013','', 'Не удалось сохранить, попробуйте позже');
                    print json_encode($out);
                }
            } else {
                $out->errors[] = Main::addError('0x017','', $this->getError($tmpF['error']));
                print json_encode($out);
            }
        } elseif (!empty($postJson)) {

            $data = [
                'NAME' => $postJson['name'],
                'LAST_NAME' =>  $postJson['last_name'],
                'PERSONAL_GENDER' => $postJson['gender'],
                'PERSONAL_PHONE' => $postJson['phone']
            ];

            if (strlen($postJson['birthday']) == 10) {
                $strBD = strtotime($postJson['birthday']);
                $data['PERSONAL_BIRTHDAY'] = \ConvertTimeStamp($strBD,"SHORT");
            }

            if (!empty($postJson['email'])) {
                $data['EMAIL'] = $postJson['email'];
            }

            if (!empty($postJson['pass'])) {
                $data['PASSWORD'] = $postJson['pass'];
                $data['CONFIRM_PASSWORD'] = $postJson['confirm_pass'];
            }

            if (!empty($data)) {
                $clUser = new \CUser();
                $result = $clUser->Update($USER->GetID(), $data);
                if ($result === true) {
                    return json_encode(['success' => $result]);
                } else {
                    $user_db = UserTable::getRow([
                        'filter' => [
                            'EMAIL' => $data['EMAIL']
                        ]
                    ]);
                    if (empty(!$user_db)) {
                        $out->errors[] = Main::addError('0x013','', 'Пользователь с таким email уже зарегистрирован');
                        print json_encode($out);
                        return;
                    }
                    $out->errors[] = Main::addError('0x013','', 'Не удалось сохранить, попробуйте позже');
                    print json_encode($out);
                }
            } else {
                $out->errors[] = Main::addError('0x011','', 'Некорректные параметры запроса');
                print json_encode($out);
            }
        } else {
            $out->errors[] = Main::addError('0x016','', 'Нет данных');
            print json_encode($out);
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