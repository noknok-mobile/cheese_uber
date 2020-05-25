<?php

namespace Simbirsoft\Mobile\General;

use Simbirsoft\Mobile\General\Registry;
use Simbirsoft\Mobile\MobileTokenTable;
use Simbirsoft\Mobile\Push\FCM;
use Simbirsoft\Mobile\Push\APNS;
use Bitrix\Main\Config\Option;

\CModule::IncludeModule("catalog");
\CModule::IncludeModule("sale");
\CModule::IncludeModule("iblock");

/**
 * Class Events
 * @package Simbirsoft\Mobile\General
 */
Class Events {
    public static $iEventHandlerKey = null;

    public function OnAfterIBlockElementAdd($arFields) {
        $promoIB = 1; // test IB ID
        $settingsIB = 2; // test IB ID
        if ($arFields['IBLOCK_ID'] == $promoIB || $arFields['IBLOCK_ID'] == $settingsIB) {
            $tokens = MobileTokenTable::getUsersTokens();
            if ($tokens) {
                $tokens_android = [];
                $tokens_ios = [];
                foreach ($tokens as $row) {
                    switch ($row['SERVICE']) {
                        case MobileTokenTable::SERVICE_ANDROID:
                            $tokens_android[] = $row['TOKEN'];
                            break;
                        case MobileTokenTable::SERVICE_IOS:
                            $tokens_ios[] = $row['TOKEN'];
                            break;
                    }
                }
            }
            $params = [];
            $params['tokens']['tokens_ios'] = $tokens_ios;
            $params['tokens']['tokens_android'] = $tokens_android;

            if ($arFields['IBLOCK_ID'] == $promoIB)
                $params['property']['action'] = $arFields['ID'];

            $params['title'] = 'Новая акция! '.$arFields['NAME'];
            $params['body'] = $arFields['PREVIEW_TEXT'];

            if ($arFields['IBLOCK_ID'] == $settingsIB) {
                $params['title'] = $arFields['NAME'];
                $props = array_keys($arFields['PROPERTY_VALUES']);
                if (!empty($props)) {
                    $filter = array("PROPERTY_ID" => $props, 'VALUE' => 'Отправленное');
                    $ar_prop = \Bitrix\Iblock\PropertyEnumerationTable::getList(array(
                        'filter' => $filter,
                        'select' => array("ID"),
                    ))->fetch();
                    \CIBlockElement::SetPropertyValueCode($arFields['ID'], "STATUS", $ar_prop['ID']);
                }
            }
            self::sendPush($params);
        }
    }

    function sendPush(array $params)
    {
        if (!empty($params['tokens']['tokens_android'])) {
            $fcm_token = Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_FCM_TOKEN');
            if (!empty($fcm_token)) {
                $fcm_service = new FCM($fcm_token);
                $fcm_service->pushNotification($params);
            }
        }

        if (!empty($params['tokens']['tokens_ios'])) {
            $apns_cert = (int)Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_APNS_SERT');
            $apns_root_cert = (int)Option::get('simbirsoft.mobile', 'SIMBIRSOFT_MOBILE_APNS_ROOT_SERT');
            if ($apns_cert > 0 && $apns_root_cert > 0) {
                $apns_cert_path = $_SERVER["DOCUMENT_ROOT"] . \CFile::getPath($apns_cert);
                $apns_root_cert_path = $_SERVER["DOCUMENT_ROOT"] . \CFile::getPath($apns_root_cert);
                if (!empty($apns_cert_path) && !empty($apns_cert_path) && file_exists($apns_root_cert_path) && file_exists($apns_root_cert_path)) {
                    $apns_service = new APNS($apns_cert_path, $apns_root_cert_path);
                    $apns_service->pushNotification($params);
                }
            }
        }
    }
}
