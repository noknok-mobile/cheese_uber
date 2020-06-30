<?
// Пример удаления событий
 $eventManager = \Bitrix\Main\EventManager::getInstance();
// $eventManager->unRegisterEventHandler('sale', 'OnSaleStatusOrder', 'simbirsoft.mobile', 'Simbirsoft\Mobile\General\Events', 'OnSaleStatusOrder');
// $eventManager->unRegisterEventHandler('iblock', 'OnAfterIBlockElementAdd', 'simbirsoft.mobile', 'Simbirsoft\Mobile\General\Events', 'OnAfterIBlockElementAdd', 100000);
$eventManager->unRegisterEventHandler('sale', 'OnSaleStatusOrder', 'simbirsoft.mobile', 'Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange', 100000);
