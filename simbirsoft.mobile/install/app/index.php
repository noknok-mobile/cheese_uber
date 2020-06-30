<?
define('BX_SECURITY_SESSION_VIRTUAL', true);
define("NOT_CHECK_PERMISSIONS", true);

require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");

$APPLICATION->IncludeComponent(
    'ss:simbirsoft.mobile.rest',
    ".default",
    [
        "SEF_MODE" => "Y",
        "SEF_FOLDER" => "/mobileapp/api/",
    ],
    false,
    array('HIDE_ICONS' => 'Y')
);

require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/epilog_after.php");
?>