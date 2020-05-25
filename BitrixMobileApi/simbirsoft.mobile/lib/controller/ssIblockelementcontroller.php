<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;

class SSIblockElementController implements Routable {
    /* @var $mobile_app \Simbirsoft\Mobile\Application */
    private $mobile_app;
    /* @var $request \Bitrix\Main\HttpRequest */
    private $request;

    public function __construct($mobile_app) {
        $this->mobile_app = $mobile_app;
        $this->request = $mobile_app->getRequest();
    }

    public function post() {
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $out = new \stdClass();
        if (!\Bitrix\Main\Loader::includeModule("iblock")) {
            $out->errors[] = Main::addError('0x005','', 'Не подключён модуль "iblock"');
            print json_encode($out);
        }
        if (!empty($postJson['code']) && !empty($postJson['type'])) {
            $ib = Main::getIBByCode($postJson['code'], $postJson['type']);
            $arOrder = array("DATE_ACTIVE_FROM" => "DESC", "SORT" => "ASC");
            $arFilter = [
                'ACTIVE' => 'Y',
                //'!PREVIEW_PICTURE' => false,
                'IBLOCK_ID' => array($ib),
                'ID' => $postJson['id']?$postJson['id']:null
            ];
            $arSelect = array('ID', 'NAME', 'PREVIEW_TEXT', 'ACTIVE_FROM', 'PREVIEW_PICTURE');

            $cache_id = md5(serialize(['ib_getlist', $arSelect, $arFilter, $arOrder]));
            $cache_dir = "/ss_getlist";
            $arResult = [];
            $obCache = new \CPHPCache;
            if ($obCache->InitCache(3600, $cache_id, $cache_dir)) {
                $arResult = $obCache->GetVars();
            } elseif ($obCache->StartDataCache()) {
                global $CACHE_MANAGER;
                $res = \CIBlockElement::GetList($arOrder, $arFilter, false, false, $arSelect);
                $CACHE_MANAGER->StartTagCache($cache_dir);
                $CACHE_MANAGER->RegisterTag("iblock_id_".$ib);
                while ($ob = $res->GetNextElement(true, false)) {
                    $arFields = $ob->GetFields();
                    $resizedFile = "";
//                if ($file = \CFile::GetFileArray($arFields['PROPERTY_PREVIEW_PICTURE_OPTIONAL_VALUE']))
//                    $resizedFile = \CFile::ResizeImageGet($file, array('width'=>'750', 'height'=>'720'), BX_RESIZE_IMAGE_PROPORTIONAL_ALT, true);
                    $resizedFile = \CFile::GetFileArray($arFields['PREVIEW_PICTURE']);
                    $arFields['PREVIEW_TEXT'] = strip_tags($arFields['PREVIEW_TEXT']);
                    $arFields["PREVIEW_PICTURE"] = $resizedFile['SRC'] ? $resizedFile['SRC'] : "";
                    $arResult[] = $arFields;
                    $CACHE_MANAGER->RegisterTag("element_".$arFields["ID"]);
                }
                $CACHE_MANAGER->RegisterTag("iblock_list");
                $CACHE_MANAGER->EndTagCache();
                $obCache->EndDataCache($arResult);
            } else {
                global $CACHE_MANAGER;
                $CACHE_MANAGER->ClearByTag('iblock_list');
            }
            print json_encode($arResult);
            return ;
        } else {
            $out->errors[] = Main::addError('0x031','', 'Некорректные параметры запроса');
            print json_encode($out);
        }

        header("HTTP/1.1 200 OK");
        return;
    }

    public function delete() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
}