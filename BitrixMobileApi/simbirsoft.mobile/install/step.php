<?
use \Bitrix\Main\Localization\Loc;

if (!check_bitrix_sessid())
    return;
?>

<form action="<? echo $APPLICATION->GetCurPage() ?>">
    <input type="hidden" name="lang" value="<?=LANG?>">
    <input type="submit" name="" value="<?=Loc::getMessage("MOD_BACK") ?>">
<form>