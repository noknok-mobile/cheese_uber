<?
// Пример добавления событий
 $eventManager = \Bitrix\Main\EventManager::getInstance();
// $eventManager->registerEventHandler('sale', 'OnSaleStatusOrder', 'simbirsoft.mobile', 'Simbirsoft\Mobile\General\Events', 'OnSaleStatusOrder', 100000);
// $eventManager->registerEventHandler('iblock', 'OnAfterIBlockElementAdd', 'simbirsoft.mobile', 'Simbirsoft\Mobile\General\Events', 'OnAfterIBlockElementAdd', 100000);
$eventManager->registerEventHandler('sale', 'OnSaleStatusOrder', 'simbirsoft.mobile', 'Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange', 100000);
