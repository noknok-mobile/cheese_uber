<?
if (!defined("B_PROLOG_INCLUDED") || B_PROLOG_INCLUDED !== TRUE) die();
if (!CModule::IncludeModule("simbirsoft.mobile")) {
    ShowError(GetMessage("SIMBIRSOFT_MOBILE_MODULE_NOT_INSTALL"));
    return;
}
$context = \Bitrix\Main\HttpApplication::getInstance()->getContext();
$request = $context->getRequest();

$app = new Simbirsoft\Mobile\Application($request);
$arResult = [];
$arResult = $app->run();

$this->IncludeComponentTemplate();
