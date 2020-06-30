<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Bitrix\Main\UserTable;
use Simbirsoft\Mobile\General\Main;
use function MongoDB\BSON\toJSON;

class AddreseEditController implements Routable {
    public function post() {
        GLOBAL $USER;
        $request = \Bitrix\Main\Context::getCurrent()->getRequest();
        $files = $request->getFileList()->toArray();

        $post_data = file_get_contents('php://input');
        $postJson =  json_decode($post_data, true);
        $out = new \stdClass();
        if (!empty($postJson['token']) && !empty($postJson['platform'])) {
            $sigmController = new SignInController();
            $sigmController->setMobileToken($postJson);
            return json_encode(['success' => true]);
        }

        if(!empty($postJson)&&!empty($postJson["USER_ID"]) && $postJson["USER_ID"] == $USER->GetID()) {

            $USER_PROPS_ID = $postJson["ID"];
            if(empty($USER_PROPS_ID) || $USER_PROPS_ID == 0) {
                $arFields = array(
                    "NAME" => $postJson["NAME"],
                    "USER_ID" => $USER->GetID(),
                    "PERSON_TYPE_ID" => 1
                );

                $USER_PROPS_ID = \CSaleOrderUserProps::Add($arFields);
                if (!$USER_PROPS_ID){
                    $out->errors[] = Main::addError('0x016','', 'Ошибка создания профиля');
                    print json_encode($out);
                }
                $propsValue = \CSaleOrderProps::GetList(
                    array("DATE_UPDATE" => "DESC"),
                    array(),
                            false,
                                false,
                                        array("ID","ORDER_PROPS_ID","NAME","VALUE")
                                    );


                $newOut["ID"] = $USER_PROPS_ID.'';

                while($values =$propsValue->fetch()) {

                    if ($postJson[$values["ID"]]!=null) {

                        $arFields = array(
                            "USER_PROPS_ID" => $USER_PROPS_ID,
                            "ORDER_PROPS_ID" => $values["ID"],
                            "NAME" => $values["NAME"],
                            "VALUE" => $postJson[$values["ID"]]
                        );

                        //$newOut["PROPERTY_ID"][$values["ID"]]=$values["NAME"];
                        $newOut["PROPERTY_ID"][$values["ID"]]=$arFields;

                        if (!\CSaleOrderUserPropsValue::Add($arFields)){
                            $out->errors[] = Main::addError('0x016','', 'Ошибка создания');
                            print json_encode($out);
                        }
                       // \CSaleOrderUserPropsValue::Update($values["ID"], $values);
                    }

                }
               //
                return json_encode($newOut);
            } else {

                    $newOut["ID"] = $USER_PROPS_ID;

                    $userProps = \CSaleOrderUserPropsValue
                        ::GetList(
                            array("DATE_UPDATE" => "DESC"),
                            array('USER_PROPS_ID' => $USER_PROPS_ID),
                            false,
                            false,
                            array("ID", "ORDER_PROPS_ID", "NAME", "VALUE")
                        );

                    while ($values = $userProps->fetch()) {


                        if ($postJson[$values["ORDER_PROPS_ID"]] != null) {

                            $newOut["VALUE"][$values["ORDER_PROPS_ID"]]["OLD"] = $values["VALUE"];
                            $newOut["VALUE"][$values["ORDER_PROPS_ID"]]["NEW"] = $postJson[$values["ORDER_PROPS_ID"]];
                            $values["VALUE"] = $postJson[$values["ORDER_PROPS_ID"]];

                            if (!\CSaleOrderUserPropsValue::Update($values["ID"], $values)){
                                $out->errors[] = Main::addError('0x016','', 'Ошибка изменения свойств');
                                print json_encode($out);
                            }

                        } else{
                            $arFields = array(
                                "USER_PROPS_ID" => $USER_PROPS_ID,
                                "ORDER_PROPS_ID" => $values["ID"],
                                "NAME" => $values["NAME"],
                                "VALUE" => $postJson[$values["ID"]]
                            );
                            $newOut["VALUE"][$values["ORDER_PROPS_ID"]] = $arFields;
                             if (!\CSaleOrderUserPropsValue::Add($arFields)){
                                 $out->errors[] = Main::addError('0x016','', 'Ошибка создания');
                                 print json_encode($out);
                             }
                        }

                    }
                    $arFields = array(
                        "NAME" => $postJson["NAME"]
                    );
                    if (!\CSaleOrderUserProps::Update($USER_PROPS_ID, $arFields)){
                        $out->errors[] = Main::addError('0x016','', 'Ошибка изменения свойств');
                        print json_encode($out);
                    }

                    return json_encode($newOut);
                    //return json_encode($newOut);
                }


        } else {
            $out->errors[] = Main::addError('0x016','', 'Нет данных');
            print json_encode($out);
        }

        header("HTTP/1.1 200 OK");
        return json_encode($out);
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