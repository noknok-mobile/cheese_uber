<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;

class CategoryElementController implements Routable {
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
            $arOrder = array("IBLOCK_SECTION_ID"=>"ASC", "SORT" => "ASC");
            $arFilter = array('IBLOCK_ID' => 25, 'ACTIVE' => 'Y','ID' => $postJson['id']?$postJson['id']:null,); 
            $arSelect = array('ID', 'NAME',"IBLOCK_ID","PICTURE","IBLOCK_SECTION_ID");
        
            $cache_id = md5(serialize(['ib_categorye', $arSelect, $arFilter, $arOrder]));
            $cache_dir = "/ss_getcategory";
            $arResult = [];
            $obCache = new \CPHPCache;
            if ($obCache->InitCache(3600, $cache_id, $cache_dir)) {
                $arResult = $obCache->GetVars();
            } elseif ($obCache->StartDataCache()) {
                global $CACHE_MANAGER;
                $rsSection = \CIBlockSection::GetList($arOrder, $arFilter, false, $arSelect, false); 
                $CACHE_MANAGER->StartTagCache($cache_dir);
                $CACHE_MANAGER->RegisterTag("iblock_id_".$ib);
                while ($ob = $rsSection->GetNextElement(true, false)) {
                    $arFields = $ob->GetFields();
                    
                    $resizedFile = "";
                    $resizedFile = \CFile::GetFileArray($arFields['PICTURE']);
                    $arFields['PICTURE'] = $resizedFile['SRC'] ?  "https://".$_SERVER['SERVER_NAME'].$resizedFile['SRC'] : "";
                       
                     
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