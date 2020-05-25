<?php
use \Bitrix\Main\Localization\Loc;
use \Bitrix\Main\Config as Conf;
use \Bitrix\Main\Config\Option;
use \Bitrix\Main\Loader;
use \Bitrix\Main\Entity\Base;
use \Bitrix\Main\Application;
use \Simbirsoft\Mobile\MobileUserTokenTable;
use \Simbirsoft\Mobile\MobileTokenTable;
use \Simbirsoft\Mobile\UsersocTable;

require dirname(__FILE__) . '/../lib/mobileusertoken.php';
require dirname(__FILE__) . '/../lib/mobiletoken.php';
require dirname(__FILE__) . '/../lib/usersoc.php';
Loc::loadMessages(__FILE__);

class simbirsoft_mobile extends CModule {
    public $arModuleVersion;
    public $MODULE_ID = "simbirsoft.mobile";

    function __construct() {
        $arModuleVersion = array();
        include(dirname(__FILE__) . "/version.php");
        $this->MODULE_PATH = $this->GetPath(FALSE);
        $this->MODULE_VERSION = $arModuleVersion["VERSION"];
        $this->MODULE_VERSION_DATE = $arModuleVersion["VERSION_DATE"];
        $this->MODULE_NAME = Loc::GetMessage("MOBILE_MODULE_NAME");
        $this->MODULE_DESCRIPTION = Loc::GetMessage("MODULE_DESCRIPTION");
        $this->MODULE_ID = 'simbirsoft.mobile';
        $this->PARTNER_NAME = Loc::GetMessage("PARTNER_NAME");
        $this->PARTNER_URI = Loc::GetMessage("PARTNER_URI");
        $this->MODULE_SORT = 1; /* для отладки */
    }

    /**
     * Устанавливаем модуль
     */
    public function DoInstall() {
        \Bitrix\Main\ModuleManager::registerModule($this->MODULE_ID);
        $this->InstallFiles();
        $this->createTables();
    }

    /**
     * Удаляем модуль
     */
    public function DoUninstall() {
        $this->UnInstallFiles();
        $this->dropTables();
        \Bitrix\Main\ModuleManager::unRegisterModule($this->MODULE_ID);
    }

    /**
     * Перенос всех необходимых файлов модуля
     * @param array $arParams
     * @return bool|void
     * @throws \Bitrix\Main\IO\InvalidPathException
     */
    function InstallFiles($arParams = array()) {
        $path = $this->GetPath()."/install/components";

        if (\Bitrix\Main\IO\Directory::isDirectoryExists($path))
            CopyDirFiles($path, $_SERVER["DOCUMENT_ROOT"]."/local/components/ss", true, true);

        $path = $this->GetPath()."/install/app";

        if (\Bitrix\Main\IO\Directory::isDirectoryExists($path))
            CopyDirFiles($path, $_SERVER["DOCUMENT_ROOT"]."/mobileapp/api", true, true);

        CopyDirFiles($path = $this->GetPath()."/img", $_SERVER["DOCUMENT_ROOT"]."/upload/ss", true, true);

        \CUrlRewriter::Add([
            'CONDITION' => '#^/mobileapp/api/#',
            'RULE' => '',
            'ID' => 'ss:simbirsoft.mobile.rest',
            'PATH' => '/mobileapp/api/index.php'
        ]);
    }

    /**
     * Удаление всех установленных файлов модуля
     * @return bool|void
     */
    function UnInstallFiles() {
        \Bitrix\Main\IO\Directory::deleteDirectory($_SERVER["DOCUMENT_ROOT"] . "/local/components/ss");
        \Bitrix\Main\IO\Directory::deleteDirectory($_SERVER["DOCUMENT_ROOT"] . "/upload/ss");
        \Bitrix\Main\IO\Directory::deleteDirectory($_SERVER["DOCUMENT_ROOT"] . "/mobileapp/api");

        \CUrlRewriter::Delete(array(
            'CONDITION' => '#^/mobileapp/api/#',
            'ID' => 'ss:simbirsoft.mobile.rest',
            'PATH' => '/mobileapp/api/index.php'
        ));
    }

    public function GetPath($notDocumentRoot = false) {
        if ($notDocumentRoot) {
            return str_ireplace(Application::getDocumentRoot(), '', str_replace("\\", "/", dirname(__DIR__)));
        } else {
            return dirname(__DIR__);
        }
    }

    public function createTables() {
        MobileUserTokenTable::getEntity()->createDbTable();
        MobileTokenTable::getEntity()->createDbTable();
        UsersocTable::getEntity()->createDbTable();
    }

    public function dropTables() {
        global $DB;
        $DB->Query('DROP TABLE IF EXISTS ' . MobileUserTokenTable::getTableName());
        $DB->Query('DROP TABLE IF EXISTS ' . MobileTokenTable::getTableName());
        $DB->Query('DROP TABLE IF EXISTS ' . UsersocTable::getTableName());
    }
}