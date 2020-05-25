<? if (!defined("B_PROLOG_INCLUDED") || B_PROLOG_INCLUDED !== TRUE) {
  die();
}

header('Content-Type: application/json; charset=utf-8', TRUE);
if (!empty($arResult["code"]) && !empty($arResult["message"])) {
  header("HTTP/1.1 " . $arResult["code"] . " " . $arResult["message"], TRUE);
} else {
    echo $arResult;
}

die();