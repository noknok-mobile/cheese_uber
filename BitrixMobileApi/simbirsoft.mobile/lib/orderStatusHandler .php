<?php
namespace Bitrix\Sale;
class OrderStatusHandler {
	  function OnSaleStatusOrderChange($event)
	  {
			//$parameters = $event->getParameters();
			$fcm_service = new CustomFCM();
			$fcm_service->pushNotification("qweqwe.qwe",array("title"=>"TEST","body"=>"TEST_BODY"));
			//\Bitrix\Main\EventManager::getInstance()->addEventHandler('sale', 'OnSaleOrderSaved', ['Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange']);
			//\Bitrix\Main\EventManager::getInstance()->addEventHandler('sale', 'OnSaleStatusOrderChange', ['Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange']);
	  }
	}