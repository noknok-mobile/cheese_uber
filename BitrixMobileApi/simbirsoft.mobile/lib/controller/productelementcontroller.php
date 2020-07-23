<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;

class ProductElementController implements Routable {
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
            $arOrder = array( "SORT" => "ASC");
            if($postJson['section_id']){
            
            $arFilter = [
                'ACTIVE' => 'Y',
                'IBLOCK_ID' => 	25,
                'timestamp_x' => $postJson['timestamp']?$postJson['timestamp']:null,
                'ID' => $postJson['id']?$postJson['id']:null,
                'SECTION_ID' => $postJson['section_id']
            ];
            } else {
              $arFilter = [
                'ACTIVE' => 'Y',
                'IBLOCK_ID' => 	25,
                'timestamp_x' => $postJson['timestamp']?$postJson['timestamp']:null,
                'ID' => $postJson['id']?$postJson['id']:null
              
                ];  
                
                
            }
            $arSelect = array('ID', 'NAME', 'PREVIEW_TEXT', 'DETAIL_TEXT','IBLOCK_SECTION_ID', 'PREVIEW_PICTURE','DETAIL_PICTURE');

            $cache_id = md5(serialize(['ib_getlistProducts5', $arSelect, $arFilter, $arOrder]));
            $cache_dir = "/ss_getlist";
            $arResult = [];
            $obCache = new \CPHPCache;
            if ($obCache->InitCache(1, $cache_id, $cache_dir)) {
                $arResult = $obCache->GetVars();
            } elseif ($obCache->StartDataCache()) {
                global $CACHE_MANAGER;
                $res = \CIBlockElement::GetList($arOrder, $arFilter, false, false, $arSelect);
                $CACHE_MANAGER->StartTagCache($cache_dir);
                $CACHE_MANAGER->RegisterTag("iblock_id_".$cache_id);
                while ($ob = $res->GetNextElement(true, false)) {
                    $arFields = $ob->GetFields();
                    $prorerties = $ob->GetProperties();
                    $resizedFile = "";
//                if ($file = \CFile::GetFileArray($arFields['PROPERTY_PREVIEW_PICTURE_OPTIONAL_VALUE']))
//                    $resizedFile = \CFile::ResizeImageGet($file, array('width'=>'750', 'height'=>'720'), BX_RESIZE_IMAGE_PROPORTIONAL_ALT, true);
                $arPriceSelect = array('CATALOG_GROUP_ID','PRICE', 'CURRENCY');
                $prices = \CPrice::GetListEx( array(),
                array(
                        "PRODUCT_ID" => $arFields["ID"],

                    ), false, false,$arPriceSelect );

                while($price =  $prices->Fetch())
                    $arFields['PRICES'][$price['CATALOG_GROUP_ID']] =$price;
                    $arFields['MEASURE'] = \Bitrix\Catalog\ProductTable::getCurrentRatioWithMeasure($arFields["ID"])[$arFields["ID"]]['MEASURE']['SYMBOL_RUS']; 
                    $resizedFile = \CFile::GetFileArray($arFields['PREVIEW_PICTURE']);
                     $arFields['PREVIEW_PICTURE'] =  $resizedFile['SRC'] ? "https://".$_SERVER['SERVER_NAME'].$resizedFile['SRC'] : "";
                     $resizedFile = \CFile::GetFileArray($arFields['DETAIL_PICTURE']); 
                    $arFields['DETAIL_PICTURE'] =  $resizedFile['SRC'] ? "https://".$_SERVER['SERVER_NAME'].$resizedFile['SRC'] : "";
                    $arFields['NAME'] = strip_tags($arFields['NAME'] );
                    $arFields['PREVIEW_TEXT'] = strip_tags($arFields['PREVIEW_TEXT']?$arFields['PREVIEW_TEXT']:"");
                      $arFields['DETAIL_TEXT'] = strip_tags($arFields['DETAIL_TEXT'] && $arFields['DETAIL_TEXT'] != ""?$arFields['DETAIL_TEXT']:$arFields['PREVIEW_TEXT']);
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