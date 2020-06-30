<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;

class StorageElementController implements Routable {
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
        if (true) {
            $arOrder = array("DATE_ACTIVE_FROM" => "DESC", "SORT" => "ASC");
            if($postJson['sity_id']){
            
            $arFilter = [
                'ACTIVE' => 'Y',
                'IBLOCK_ID' => 	2,
                'timestamp_x' => $postJson['timestamp']?$postJson['timestamp']:null,
                'ID' => $postJson['id']?$postJson['id']:null,
                'SECTION_ID' => $postJson['sity_id']
            ];
            } else {
              $arFilter = [
                'ACTIVE' => 'Y',
                'IBLOCK_ID' => 	2,
                'timestamp_x' => $postJson['timestamp']?$postJson['timestamp']:null,
                'ID' => $postJson['id']?$postJson['id']:null,
               
                ];  
                
                
            }
            $arSelect = array('*');

            $cache_id = md5(serialize(['ib_getlistStorage1', $arSelect, $arFilter, $arOrder]));
            $cache_dir = "/ss_getlist";
            $arResult = [];
            $obCache = new \CPHPCache;
            if ($obCache->InitCache(3600, $cache_id, $cache_dir)) {
                $arResult = $obCache->GetVars();
            } elseif ($obCache->StartDataCache()) {
                global $CACHE_MANAGER;
                $res = \CIBlockElement::GetList($arOrder, $arFilter, false, false, $arSelect);
                $CACHE_MANAGER->StartTagCache($cache_dir);
                $CACHE_MANAGER->RegisterTag("iblock_id_". $cache_id);
                while ($ob = $res->GetNextElement(true, false)) {
                    $objFields = $ob->GetFields();
                    $resizedFile = "";
//                if ($file = \CFile::GetFileArray($arFields['PROPERTY_PREVIEW_PICTURE_OPTIONAL_VALUE']))
//                    $resizedFile = \CFile::ResizeImageGet($file, array('width'=>'750', 'height'=>'720'), BX_RESIZE_IMAGE_PROPORTIONAL_ALT, true);
                    $prorerties = $ob->GetProperties();
                  //  $arFields["values"][] = $prorerties;


                    $arFields['PRICE_ID'] = $prorerties['PRICES_LINK']['VALUE'];
                    $arFields['STORE_ID'] = $prorerties['STORES_LINK']['VALUE'];
                    $arFields['ADDRESS'] = $prorerties['ADDRESS']['VALUE']["TEXT"];
                    $arFields['PHONES'] = $prorerties['PHONES']['VALUE'];
                    $arFields['MAP_POINTS'] = $prorerties['REGION_TAG_YANDEX_MAP']['VALUE'];
                    $arFields['WORK_TIME'] = $prorerties['REGION_TAG_SHEDULLE']['VALUE']["TEXT"];
                    $arFields['DETAIL_TEXT'] = strip_tags($objFields['DETAIL_TEXT']);
                    $arFields['ID'] = $objFields['ID'];
                    $arFields['SITY_ID'] = $objFields['IBLOCK_SECTION_ID'];


                    $resizedFile = \CFile::GetFileArray($objFields['PREVIEW_PICTURE']);
                    $arFields['PREVIEW_PICTURE'] = $objFields['SRC'] ? $objFields['SRC'] : "";
                    $resizedFile = \CFile::GetFileArray($objFields['DETAIL_PICTURE']);
                    $arFields['DETAIL_PICTURE'] = $resizedFile['SRC'] ? $resizedFile['SRC'] : "";
                    $arFields['NAME'] = strip_tags($objFields['NAME']);   
                   
                     
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

        header("HTTP/1.1 201 OK");
        return ;
    }

    public function delete() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
}