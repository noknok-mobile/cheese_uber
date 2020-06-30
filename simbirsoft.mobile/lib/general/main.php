<?php
namespace Simbirsoft\Mobile\General;
/**
 * Class Main Содержит набор дополнительных функций
 * @package Simbirsoft\Mobile\General
 */
Class Main  {
  public function decode($data) {
    return json_decode($data, TRUE);
  }

  /**
   * Кодирует данные
   * @param $data
   * @return string
   */
  public function encode($data) {
    return json_encode($data);
  }

  /**
   * @param $url - относительный url страницы
   * @return string - полный url страницы
   */
  public function getUrl($url) {
    $result = '';
    if (!empty($url)) {
      $default_port = 80;
      if (isset($_SERVER['HTTPS']) && ($_SERVER['HTTPS'] == 'on')) {
        $result .= 'https://';
        $default_port = 443;
      }
      else {
        $result .= 'http://';
      }
      $result .= $_SERVER['SERVER_NAME'];
      if ($_SERVER['SERVER_PORT'] != $default_port) {
        $result .= ':' . $_SERVER['SERVER_PORT'];
      }
      $result .= $url;
    }
    return $result;
  }

    public function getAdressFromIB(array $address) {
        \CModule::IncludeModule('iblock');
        $retAddr = [];
        foreach ($address as $key => $val) {
            $address[$key] = trim($val);
        }

        $cityFilter = array("NAME" => "{$address['city']}%");
        $arCities = \CNiyamaIBlockCities::GetCities($cityFilter);
        if (!empty($arCities)) {
            $city = array_shift($arCities);
            $retAddr['city'] = $city['NAME'];
        } else {
            $retAddr['city'] = $address['city'];
        }
        $ibStreets = \CProjectUtils::GetIBlockIdByCode('streets', 'data');
        $streets = \Bitrix\Iblock\ElementTable::getList([
            'filter' => ["IBLOCK_ID" => $ibStreets, "=NAME" => $address['street']],
            'select' => ["ID", "NAME"]
        ])->fetchAll();
        if (!empty($streets)) {
            $street = array_shift($streets);
            $retAddr['street'] = $street['NAME'];
        } else {
            $retAddr['street'] = $address['street'];
        }
        $retAddr['house'] = $address['house'];
        return $retAddr;
    }

    public static function addError($code, $key, $message) {
        $newErr = new \stdClass();
        $newErr->code = $code;
        $newErr->key = $key;
        $newErr->message = $message;
        return $newErr;
    }

    /**
     * @param bool $notDocumentRoot
     * @return null|string|string[]
     */
    public static function getModuleFolder($dir)
    {
        $pos = strpos($dir, 'local');
        if ($pos === false)
            return 'bitrix';
        else
            return 'local';
    }

    public static function getIBByCode($code, $type) {
        \Bitrix\Main\Loader::includeModule('iblock');
        $ib = 0;
        $cache_id = md5(serialize(['iblocks', $code, $type]));
        $cache_dir = "/ss_ibbycode";
        $obCache = new \CPHPCache;
        if ($obCache->InitCache(604800, $cache_id, $cache_dir)) {
            $ib = $obCache->GetVars();
        } elseif ($obCache->StartDataCache()) {
            global $CACHE_MANAGER;
            $CACHE_MANAGER->StartTagCache($cache_dir);
            $ib = \Bitrix\Iblock\IblockTable::getRow(['filter'=>['CODE'=> $code, 'IBLOCK_TYPE_ID' => $type],'select'=>['ID']]);
            $ib = $ib['ID'];
            $CACHE_MANAGER->RegisterTag("iblockID_".$ib);
            $CACHE_MANAGER->EndTagCache();
            $obCache->EndDataCache($ib);
        } else {
            global $CACHE_MANAGER;
            $CACHE_MANAGER->ClearByTag('iblockID');
        }
        global $CACHE_MANAGER;
        $CACHE_MANAGER->ClearByTag('iblockID');
        return $ib;
    }
}
