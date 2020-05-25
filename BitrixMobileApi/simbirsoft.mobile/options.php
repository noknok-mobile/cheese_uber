<?php
use \Bitrix\Main\Localization;
use \Bitrix\Main\Localization\Loc;
use \Bitrix\Main\Loader;
use \Bitrix\Main\Config\Option;
Loc::loadMessages($_SERVER["DOCUMENT_ROOT"].BX_ROOT . "/modules/main/options.php");
Loc::loadMessages(__FILE__);
$module_id = "simbirsoft.mobile";
$field_gcm_token = "SIMBIRSOFT_MOBILE_FCM_TOKEN";
$field_log = "SIMBIRSOFT_MOBILE_LOG";
$field_apns_sert = "SIMBIRSOFT_MOBILE_APNS_SERT";
$field_apns_root_sert = "SIMBIRSOFT_MOBILE_APNS_ROOT_SERT";
$field_apns_server = 'SIMBIRSOFT_MOBILE_APNS_SERVER';
$RIGHT = $APPLICATION->GetGroupRight($module_id);
if ($RIGHT >= "R") :
///// Читаем данные и формируем для вывода
$arAllOptions = [
    [$field_gcm_token, Loc::getMessage("MOBILE_MODULE_FCM"), ["text"], ""],
    [$field_log, Loc::getMessage("MOBILE_MODULE_LOG"), ["checkbox"], ""],
];

$field_files = [
    $field_apns_sert => Loc::getMessage("MOBILE_MODULE_APNS_CERT"),
    $field_apns_root_sert => Loc::getMessage("MOBILE_MODULE_APNS_ROOT_CERT"),
];

$aTabs = [
    ["DIV" => "edit1", "TAB" => Loc::getMessage("MAIN_TAB_SET"), "ICON" => "perfmon_settings", "TITLE" => Loc::getMessage("MAIN_TAB_TITLE_SET")],
    ["DIV" => "edit2", "TAB" => Loc::getMessage("MOBILE_MODULE_INFO"), "ICON" => "perfmon_settings", "TITLE" => Loc::getMessage("MOBILE_MODULE_INFO")],
    ["DIV" => "edit3", "TAB" => Loc::getMessage("MAIN_TAB_RIGHTS"), "ICON" => "perfmon_settings", "TITLE" => Loc::getMessage("MAIN_TAB_TITLE_RIGHTS")],
];
$tabControl = new CAdminTabControl("tabControl", $aTabs);
Loader::includeModule($module_id);
$module_path = '/upload/ss/';
if ($REQUEST_METHOD=="POST" && strlen($Update.$Apply.$RestoreDefaults) > 0 && $RIGHT=="W" && check_bitrix_sessid()) {
    require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/perfmon/prolog.php");
    if (strlen($RestoreDefaults)>0) {
        COption::RemoveOption($field_gcm_token);
        COption::RemoveOption($field_log);
        COption::RemoveOption($field_apns_server);
    } else {
        foreach ($arAllOptions as $arOption) {
            $name = $arOption[0];
            $val = $_REQUEST[$name];
            COption::SetOptionString($module_id, $name, $val);
        }
        if (empty($_REQUEST[$field_log])) {
            COption::SetOptionString($module_id, $field_log, 'N');
        }

        foreach ($field_files as $field_file => $field_file_label) {
            if (empty($_REQUEST[$field_file])) {
                COption::RemoveOption($module_id, $field_file);
            }
            $apns_file = $_FILES[$field_file . '_FILE'];
            if (!empty($apns_file)) {
                $apns_file["MODULE_ID"] = $module_id;
                if (strlen($apns_file["name"]) > 0) {
                    $fid_old = COption::GetOptionInt($module_id, $field_file, 0);
                    if ($fid_old > 0) {
                        CFile::Delete($fid_old);
                        COption::RemoveOption($module_id, $field_file);
                    }
                    $fid = CFile::SaveFile($apns_file, $module_id);
                    COption::SetOptionInt($module_id, $field_file, $fid);
                }
            }
        }
        
        if (!empty($_REQUEST[$field_apns_server])) {
            COption::SetOptionString($module_id, $field_apns_server, $_REQUEST[$field_apns_server]);
        }
    }
    ob_start();
    $Update = $Update.$Apply;
    require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/admin/group_rights.php");
    ob_end_clean();
}
?>
<form method="post" enctype="multipart/form-data" action="<?echo $APPLICATION->GetCurPage()?>?mid=<?=urlencode($module_id)?>&amp;lang=<?=LANGUAGE_ID?>">
    <?php
    $tabControl->Begin();
    $tabControl->BeginNextTab();
        $arNotes = array();
        if (!extension_loaded('curl')) : ?>
            <span class="required">Curl extension required for push to android devices</span>
            <br />
        <?php endif;
        foreach($arAllOptions as $arOption):
            $val = COption::GetOptionString($module_id, $arOption[0], $arOption[3]);
            $type = $arOption[2];
            if(isset($arOption[4]))
                $arNotes[] = $arOption[4];
            ?>
            <? if($type[0] != "hidden"): ?>
                <tr>
                    <td width="40%" nowrap <? if($type[0]=="textarea") echo 'class="adm-detail-valign-top"' ?> >
                        <? if(isset($arOption[4])): ?>
                            <span class="required"><sup><?echo count($arNotes)?></sup></span>
                        <? endif; ?>
                        <label for="<?= $arOption[0] ?>"><? echo $arOption[1] ?>:</label>
                    </td>
                    <td width="60%">
                        <? if($type[0] == "checkbox"): ?>
                            <input type="checkbox" name="<?= $arOption[0] ?>" id="<?= $arOption[0] ?>" value="Y"<?if($val=="Y")echo" checked";?>>
                        <? elseif($type[0] == "text"): ?>
                            <input type="text" size="<?= $type[1] ?>" maxlength="255" value="<?= htmlspecialcharsbx($val)?>" name="<?= $arOption[0]?>" id="<?= $arOption[0]?>">
                        <? elseif($type[0] == "textarea"): ?>
                            <textarea rows="<?echo $type[1]?>" cols="<?echo $type[2]?>" name="<?= $arOption[0] ?>" id="<?= $arOption[0] ?>"><?echo htmlspecialcharsbx($val)?></textarea>
                        <? endif ?>
                    </td>
                </tr>
            <? endif; ?>
        <? endforeach; ?>
                
        <? foreach ($field_files as $field_file => $field_file_label) : ?>
            <? $field_apns_sert_value = COption::GetOptionInt($module_id, $field_file, 0);
            if (!empty($field_apns_sert_value)) {
                $field_apns_sert_file_arr = CFile::GetFileArray((int)$field_apns_sert_value);
                $field_apns_sert_file_name = $field_apns_sert_file_arr['FILE_NAME'];
            }
            ?>
            <tr>
                <td width="40%" nowrap >
                    <label for="<?= $field_file . '_FILE'; ?>"><?= $field_file_label ?>:</label>
                </td>
                <td width="60%">
                    <input
                        type="hidden"
                        name="<?= $field_file ?>"
                        id="<?= $field_file ?>"
                        value="<?= $field_apns_sert_value ?>">
                    <input type="file" name="<?= $field_file . '_FILE'; ?>">
                </td>
            </tr>

            <? if (!empty($field_apns_sert_file_name)): ?>
                <tr id="<?= $field_file ?>_saved_file">
                    <td width="40%" nowrap >
                        &nbsp;
                    </td>
                    <td width="60%">
                        <?= $field_apns_sert_file_name ?> 
                        <span onclick="document.getElementById('<?= $field_file ?>').value = 0; var file = document.getElementById('<?= $field_file ?>_saved_file'); file.parentNode.removeChild(file);">x</span>
                    </td>
                </tr>
            <? endif; ?>
        <? $field_apns_sert_file_name = ''; ?>
        <? endforeach; ?>

        <tr>
            <td width="40%" nowrap >
                <label for="SIMBIRSOFT_MOBILE_APNS_SERVER">APNS server:</label>
            </td>
            <td width="60%">
              <select id="SIMBIRSOFT_MOBILE_APNS_SERVER" name="SIMBIRSOFT_MOBILE_APNS_SERVER">
                <option value="sandbox" <?=COption::GetOptionString($module_id, $field_apns_server, 'prod') == 'sandbox' ? 'selected' : '' ?>>Sandbox</option>
                <option value="prod" <?=COption::GetOptionString($module_id, $field_apns_server, 'prod') == 'prod' ? 'selected' : '' ?>>Production</option>
              </select>
            </td>
        </tr>
    <? $tabControl->BeginNextTab(); ?>
    <tr><td colspan="2"><h2><?=Loc::getMessage("MOBILE_MODULE_INFO");?></h2></td></tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_INSTALL");?>:</td></tr>
    <tr>
        <td><img src="<?=$module_path?>install.png" alt="<?=Loc::getMessage("MOBILE_MODULE_INSTALL");?>"></td>
        <td>
            <?=Loc::getMessage("MOBILE_MODULE_INSTALL_TEXT");?>
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_STRUCT");?>:</td></tr>
    <tr>
        <td><img src="<?=$module_path?>struct.png" alt="><?=Loc::getMessage("MOBILE_MODULE_STRUCT");?>"></td>
        <td>
            <?=Loc::getMessage("MOBILE_MODULE_STRUCT_TEXT");?>
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_AUTH");?>:</td></tr>
    <tr>
        <td><img src="<?=$module_path?>auth.png" alt="<?=Loc::getMessage("MOBILE_MODULE_AUTH");?>"></td>
        <td>
            <?=Loc::getMessage("MOBILE_MODULE_AUTH_TEXT");?>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <?=Loc::getMessage("MOBILE_MODULE_AUTH_TEXT_2");?>
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_REGISTER");?>:</td></tr>
    <tr>
        <td colspan="2">
            <?=Loc::getMessage("MOBILE_MODULE_REGISTER_TEXT");?>
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_PROFILE");?>:</td></tr>
    <tr>
        <td colspan="2">
            
            <img src="<?=$module_path?>profile.png" alt="<?=Loc::getMessage("MOBILE_MODULE_PROFILE");?>">
            <?=Loc::getMessage("MOBILE_MODULE_PROFILE_TEXT");?>
            
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_IB");?>:</td></tr>
    <tr>
        <td colspan="2">
            <?=Loc::getMessage("MOBILE_MODULE_IB_TEXT");?>
            <img src="<?=$module_path?>elements.png" alt="<?=Loc::getMessage("MOBILE_MODULE_IB");?>">
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_NEW_REQUEST");?>:</td></tr>
    <tr>
        <td colspan="2">
            <?=Loc::getMessage("MOBILE_MODULE_NEW_REQUEST_TEXT");?>
            <img src="<?=$module_path?>appprops.png" alt="Запросы">
            <?=Loc::getMessage("MOBILE_MODULE_NEW_REQUEST_TEXT_2");?>
        </td>
    </tr>
    <tr class="heading"><td colspan="2"><?=Loc::getMessage("MOBILE_MODULE_TOKENS");?>:</td></tr>
    <tr>
        <td colspan="2">
            <?=Loc::getMessage("MOBILE_MODULE_TOKENS_TEXT");?>
        </td>
    </tr>

    <? $tabControl->BeginNextTab(); ?>
        <? require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/admin/group_rights.php"); ?>
        <? $tabControl->Buttons(); ?>
        <input <? if ($RIGHT<"W") echo "disabled" ?> type="submit" name="Update" value="<?= Loc::getMessage("MAIN_SAVE") ?>" title="<?= Loc::getMessage("MAIN_OPT_SAVE_TITLE") ?>" class="adm-btn-save">
        <input <? if ($RIGHT<"W") echo "disabled" ?> type="submit" name="Apply" value="<?= Loc::getMessage("MAIN_OPT_APPLY") ?>" title="<?= Loc::getMessage("MAIN_OPT_APPLY_TITLE") ?>">
        <? if (strlen($_REQUEST["back_url_settings"]) > 0):?>
            <input <?if ($RIGHT<"W") echo "disabled" ?> type="button" name="Cancel" value="<?= Loc::getMessage("MAIN_OPT_CANCEL") ?>" title="<?= Loc::getMessage("MAIN_OPT_CANCEL_TITLE") ?>" onclick="window.location='<?echo htmlspecialcharsbx(CUtil::addslashes($_REQUEST["back_url_settings"]))?>'">
            <input type="hidden" name="back_url_settings" value="<?=htmlspecialcharsbx($_REQUEST["back_url_settings"])?>">
        <? endif ?>
        <input type="submit" name="RestoreDefaults" title="<?= Loc::getMessage("MAIN_HINT_RESTORE_DEFAULTS") ?>" OnClick="confirm('<?= Loc::getMessage("MAIN_HINT_RESTORE_DEFAULTS_WARNING") ?>')" value="<?= Loc::getMessage("MAIN_RESTORE_DEFAULTS") ?>">
        <?= bitrix_sessid_post(); ?>
    <? $tabControl->End();?>
</form>
<?
if (!empty($arNotes)) {
    echo BeginNote();
    foreach($arNotes as $i => $str)
    {
        ?><span class="required"><sup><?echo $i+1?></sup></span><?echo $str?><br><?
    }
    echo EndNote();
}
?>
<?endif;?>