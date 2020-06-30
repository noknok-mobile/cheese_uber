<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;


class DiscountElementController implements Routable {
    public $arParams = [
        'DISCOUNT_LEVELS_IBLOCK_CODE' => 'discount_levels',
        'USERS_DISCOUNT_LEVELS_IBLOCK_CODE' => 'users_discount_levels'
    ];

    public function post() {
        GLOBAL $USER;
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $out = new \stdClass();
        $userFields = \Bitrix\Main\UserTable::getById($USER->GetID());



        if ($postJson['promocode'] != null){
			\Bitrix\Sale\Compatible\DiscountCompatibility::stopUsageCompatible();
            $getCoupon = \Bitrix\Sale\DiscountCouponsManager::getData($postJson['promocode'], true);
           // $out->coupon = $getCoupon;

            if (!$getCoupon['ACTIVE']) {
                $out->status = 'NOT_ACTIVE';
                $out->errors[]["message"] = "Мы не нашли такого купона";
            } else {
                $out->status = 'ACTIVE';
				 $siteId = \Bitrix\Main\Context::getCurrent()->getSite();
                    $currencyCode = \Bitrix\Currency\CurrencyManager::getBaseCurrency();
			/*
			$order = \Bitrix\Sale\Order::create($siteId, $USER->isAuthorized() ? $USER->GetID() : 539);
                    $order->setPersonTypeId(1);
                    $order->setField('CURRENCY', $currencyCode);
				*/	/*
			\Bitrix\Sale\DiscountCouponsManager::init(
				\Bitrix\Sale\DiscountCouponsManager::MODE_ORDER, [
					"userId" => $USER->GetID(),
					"orderId" => $order->getId()
				]
			);*/
		
			
			\Bitrix\Main\Loader::includeModule('sale');
			
			$siteId = \Bitrix\Main\Context::getCurrent()->getSite();
			$userId = $USER->GetID();
			
			$currencyCode = \Bitrix\Currency\CurrencyManager::getBaseCurrency();
			
			$this->orderVirtual = \Bitrix\Sale\Order::create($siteId, $userId);
			$this->orderVirtual->setPersonTypeId(1);
			$this->orderVirtual->setField('CURRENCY', $currencyCode);
			// получаем корзину
			//$basketStorage = $this->getBasketStorage();
			
			$basket = \Bitrix\Sale\Basket::loadItemsForFUser(

                            \Bitrix\Sale\Fuser::getId(),

                            \Bitrix\Main\Context::getCurrent()->getSite()

                        );
			
			$result = $basket->refresh();
			if ($result->isSuccess()) {
				$basket->save();
			}
			
			$availableBasket = $basket;
	
	//$this->setOrderProps();
	
	// прикрепляем корзину к заказу

	$this->orderVirtual->setBasket($basket);
	$basket = $this->orderVirtual->getBasket();
	$shipmentCollection = $this->orderVirtual->getShipmentCollection();
	// добавляем отгрузки
	$shipment = $shipmentCollection->createItem();
                    $service = \Bitrix\Sale\Delivery\Services\Manager::getById(1);
                    $shipment->setFields(array(
                        'DELIVERY_ID' => $service['ID'],
                        'DELIVERY_NAME' => $service['NAME'],
                    ));

                   
	
	$shipmentItemCollection = $shipment->getShipmentItemCollection();
	$shipment->setField('CURRENCY', $this->orderVirtual->getCurrency());
	
	foreach ($this->orderVirtual->getBasket()->getOrderableItems() as $item) {
		$shipmentItem = $shipmentItemCollection->createItem($item);
		$shipmentItem->setQuantity($item->getQuantity());
	}
	
	// добавляем оплату
	if (!empty($this->orderRequest['pay_system'])) {
		$paymentCollection = $this->orderVirtual->getPaymentCollection();
		$payment = $paymentCollection->createItem(
			Bitrix\Sale\PaySystem\Manager::getObjectById(
				$this->orderRequest['pay_system']
			)
		);
		$payment->setField("SUM", $this->orderVirtual->getPrice());
		$payment->setField("CURRENCY", $this->orderVirtual->getCurrency());
	}
	\Bitrix\Sale\DiscountCouponsManager::clear(true);
			\Bitrix\Sale\DiscountCouponsManager::clearApply();
	// применяем купоны
	\Bitrix\Sale\DiscountCouponsManager::init(
		\Bitrix\Sale\DiscountCouponsManager::MODE_ORDER, [
			"userId" => $this->orderVirtual->getUserId(),
			"orderId" => $this->orderVirtual->getId()
		],
		true
	);
	
	\Bitrix\Sale\DiscountCouponsManager::clear();
	
	
			\Bitrix\Sale\DiscountCouponsManager::add($postJson['promocode']);

	
	// рассчитываем скидки отдельно. эти данные нам пригодятся
	$discounts = $this->orderVirtual->getDiscount();
	$discounts->setApplyResult(array(
			'COUPON_LIST' => 
			array (
			   $postJson['promocode'] => 'Y', // код купона, который нужно отключить
			),
			)
			);
	$res = $basket->refreshData(["PRICE", "COUPONS"]);
	$discountsRes = $discounts->calculate();
	$res = $basket->refreshData(["PRICE", "COUPONS"]);
	

	
	if ($discountsRes->isSuccess()) {
		$this->discountData = \Bitrix\Sale\DiscountCouponsManager::getForApply([]);	
	}
	    if (\CCatalogDiscountCoupon::SetCoupon($postJson['promocode'])) {
			//$out->CCatalogDiscountCoupon = $postJson['promocode'];
			
			   $dbBasketItems = \CSaleBasket::GetList(
					array(
						"NAME" => "ASC",
						"ID" => "ASC"
					),
					array(
						"FUSER_ID" => \CSaleBasket::GetBasketUserID(),
						"LID" => SITE_ID,
						"ORDER_ID" => "NULL"
					),
					false,
					false,
					 array("ID", "NAME", "CALLBACK_FUNC", "MODULE", 'PRODUCT_PRICE_ID',
							  "PRODUCT_ID", "QUANTITY", "DELAY", 
							  "CAN_BUY", "PRICE", "WEIGHT")
				);
			   while ($arItems = $dbBasketItems->Fetch()) {
				    $prices = \CCatalogProduct::GetByIDEx($arItems["PRODUCT_ID"]);
                   // $regionPriceId = get_region_price_id();
                  
						$res = \CPrice::GetList(
								array(),
								array(
									"PRODUCT_ID" =>  $arItems["PRODUCT_ID"],
									"CATALOG_GROUP_ID" => $postJson["Region"]
								)
							);
						 $PRODUCT_PRICE_ID = 1;
						
						 while ($res1 = $res->fetch()) {
							// $out->res[] = $res1;
							  $arItems['PRODUCT_PRICE_ID'] = $res1["ID"];
							  $arItems['PRICE'] = $res1["PRICE"];
							 //  $arItems['CUSTOM_PRICE'] = 'Y';
						 }
						//$out->Region = $postJson["Region"];
					 
				
				  $arOrder['BASKET_ITEMS'][] = $arItems;
			
				
					$arBasketItems[] = $arItems;

			   }
			   $arOrder['SITE_ID'] = SITE_ID;
			   $arOrder['USER_ID'] = $USER->GetID();
			  
			   
			  
			   
			   foreach ($arBasketItems as $basketItem) { 
					
					\CSaleBasket::Update(
					 $basketItem["ID"],
					 $basketItem
					);
				
				} 
				  \CSaleBasket::UpdateBasketPrices(\CSaleBasket::GetBasketUserID(), SITE_ID); 
			   \CSaleDiscount::DoProcessOrder($arOrder,array(),$arErrors);
			   \CSaleBasket::UpdateBasketPrices(\CSaleBasket::GetBasketUserID(), SITE_ID); 
			   
				$basket->refreshData(array('PRICE', 'COUPONS','DISCOUNT_PRICE'));
				//$basket = \Bitrix\Sale\Basket::loadItemsForFUser(\Bitrix\Sale\Fuser::getId(), \Bitrix\Main\Context::getCurrent()->getSite());
				
				$basket->save();
				$res = $basket->refreshData(["PRICE", "COUPONS"]);
				
				//	$out->basketItem[] =$basket->getItemById($basketItem["ID"]) ;
				
			
      // $dbBasketItems = CSaleBasket::GetList (..)
    }	
	
	
	// производим финальную обработку

			$result =  $discounts->getApplyResult();
			if($result["DISCOUNT_LIST"]){
				
				foreach($result["DISCOUNT_LIST"] as $discountResult){
					
					if($discountResult["ACTIONS_DESCR_DATA"]){
						if($discountResult["ACTIONS_DESCR_DATA"]["BASKET"]){
							$out->name =$discountResult["NAME"];
							foreach($discountResult["ACTIONS_DESCR_DATA"]["BASKET"] as $BASKET){
								$out->discountValue += $BASKET["VALUE"];
								$out->discountType =  $BASKET["VALUE_TYPE"]; 
							}
						}
						
					}
				}
					
			}
			
			$out->result = $result;
			$basket->refreshData(["PRICE", "COUPONS"]);
			$out->resultDiscount = 0;
			foreach($result["ORDER"] as $order){
				if($order["RESULT"]["BASKET"]){
					
					foreach($order["RESULT"]["BASKET"] as $key => $discountBasket){
						
						if($discountBasket["DESCR_DATA"]){
							foreach($discountBasket["DESCR_DATA"] as $discountval){
								$quantity = $basket->getItemById($discountBasket["BASKET_ID"])->getQuantity();
								$out->resultDiscount =doubleval($out->resultDiscount + $discountval["RESULT_VALUE"] * $quantity);
									///$out->discountType =  $BASKET["VALUE_TYPE"]; 
							}
							
						}
					}
						
				}
			}
			
			  $out->price = doubleval(ceil( $basket->getPrice() - $out->resultDiscount));
			   $out->basePrice =  doubleval(ceil($basket->getBasePrice()));
			  // $out->getBasePrice =  $basket->getBasePrice();
			/*
			$out->basketprices = $basket->getPrice();
				$out->prices = $this->orderVirtual->getPrice();
				//
			
			*/
			
			
			/*
			$basket = \Bitrix\Sale\Basket::loadItemsForFUser(
				$uid,
				 \Bitrix\Main\Context::getCurrent()->getSite()
			);
			
			\Bitrix\Sale\DiscountCouponsManager::init();
			\Bitrix\Sale\DiscountCouponsManager::clear(true);
			\Bitrix\Sale\DiscountCouponsManager::clearApply();
			\Bitrix\Sale\DiscountCouponsManager::add($postJson['promocode']);		     
	
*/

			/*
			
			$discount = \Bitrix\Sale\Discount::loadByBasket($basket);
			$discount->setApplyResult(array(
			'COUPON_LIST' => 
			array (
			   $postJson['promocode'] => 'Y', // код купона, который нужно отключить
			),
			)
			);
			
			
			$res = $basket->refreshData(["PRICE", "COUPONS"]);
			$discountResult = $discount->calculate();
			if ($discountResult->isSuccess()) {
			  $out->BB = $discount->getShowPrices();
			} else {
			  $out->BB = false;
			}
			
			
			$result = $discount->getApplyResult(true);
			$prices = $result['PRICES']['BASKET'];
			$basket = \Bitrix\Sale\Basket::loadItemsForFUser(    \CSaleBasket::GetBasketUserID(), "s1")->getOrderableItems();
			$discounts = \Bitrix\Sale\Discount::buildFromBasket($basket, new \Bitrix\Sale\Discount\Context\Fuser($basket->getFUserId(true)));
			$discountsRes = $discounts->calculate();
			if ($discountsRes->isSuccess()) {
				$discountData = \Bitrix\Sale\DiscountCouponsManager::getForApply([]);
			}
			$arBasketDiscounts = $discounts->getApplyResult(true);

			$sum = 0;
			$basketItems = $basket->getBasketItems();
			foreach ($basketItems  as $basketItem ) {
				$basketCode = $basketItem->getBasketCode();
				if (isset($arBasketDiscounts["PRICES"]['BASKET'][$basketCode]))
				{
					$sum += $arBasketDiscounts["PRICES"]['BASKET'][$basketCode]["PRICE"]*$basketItem->getQuantity();
				} else {
					$sum += $basketItem->getFinalPrice();
				}
				
			}	
			$out->sum = 	$sum ;
			
			$out->res = $res;
			$out->r = $prices;
			$out->prices = $basket->getPrice();
			$out->basePrices = $basket->getBasePrice();
			$basket->refreshData();
			$basket->save();*/
			\Bitrix\Sale\Compatible\DiscountCompatibility::revertUsageCompatible();
			/*
			$order->setBasket($basket);
			$discount->setOrderRefresh(true);
			$discount = $order->getDiscount();
				$out->result = $discount->setApplyResult(array(
			'COUPON_LIST' => 
			array (
			$postJson['promocode'] => 'Y',
			)
			));
			
			
		
		
				
				$order->doFinalAction(true);
				
				$out->values["Basket"] = $basket;
									
				$out->order = $order;			
				$out->discount =$order->getDiscount();
				$out->prices = $order->getPrice();
					
				
				*/

			\Bitrix\Sale\DiscountCouponsManager::clear(true);
			\Bitrix\Sale\DiscountCouponsManager::clearApply();
				\Bitrix\Sale\DiscountCouponsManager::clearApplyCoupon(
					$postJson['promocode']
					);
					
}
            if ($_SESSION['CATALOG_USER_COUPONS']){
                $out->status = 'USED';
                $out->errors[]["message"] = "Купон уже активирован";

            }
            print json_encode($out);
            return;
        } else{
            $arOrder = array( "SORT" => "ASC");
            if($postJson['section_id']){

                $arFilter = [
                    'ACTIVE' => 'Y',
                    'IBLOCK_ID' => 	19,
                    'timestamp_x' => $postJson['timestamp']?$postJson['timestamp']:null,
                    'ID' => $postJson['id']?$postJson['id']:null,
                    'SECTION_ID' => $postJson['section_id']
                ];
            } else {
                $arFilter = [
                    'ACTIVE' => 'Y',
                    'IBLOCK_ID' => 	19,
                    'timestamp_x' => $postJson['timestamp']?$postJson['timestamp']:null,
                    'ID' => $postJson['id']?$postJson['id']:null

                ];


            }
            $arSelect = array(/*'ID', 'NAME', 'PREVIEW_TEXT', 'DETAIL_TEXT', 'PREVIEW_PICTURE','DETAIL_PICTURE','PROPERTY'*/);

            $cache_id = md5(serialize(['ib_getlistDiscount2', $arSelect, $arFilter, $arOrder]));
            $cache_dir = "/ss_getlist";
            $arResult = [];
            $obCache = new \CPHPCache;
            if ($obCache->InitCache(1, $cache_id, $cache_dir)) {
                $arResult = $obCache->GetVars();
            } elseif ($obCache->StartDataCache()) {
                global $CACHE_MANAGER;
                $res = \CIBlockElement::GetList($arOrder, $arFilter, false, false, $arSelect);
                $CACHE_MANAGER->StartTagCache($cache_dir);
                $CACHE_MANAGER->RegisterTag("iblock_id_".$cache_id);

                while ($ob = $res->GetNextElement(true, false)) {
                    $arFields = [];
                    $arFieldsTmp = $ob->GetFields();
                    $arFields['ID'] = $arFieldsTmp['ID'];
                    $arFields['NAME'] = $arFieldsTmp['NAME'];
                    $arFields['PREVIEW_TEXT'] = $arFieldsTmp['PREVIEW_TEXT'];
                    $arFields['DETAIL_TEXT'] = $arFieldsTmp['DETAIL_TEXT'];
                    $arFields['PREVIEW_PICTURE'] = $arFieldsTmp['PREVIEW_PICTURE'];
                    $arFields['DETAIL_PICTURE'] = $arFieldsTmp['DETAIL_PICTURE'];
                    $props = $ob->GetProperties();
                    $arFields["COUPON_ID"] =  $props["COUPON"]["VALUE"];
                    $arFields["COUPON"] = "";

                    if($arFields["COUPON_ID"]){
                        $arCouponFilter = array("ID" => $arFields["COUPON_ID"]);
                        $arCouponSelect = array('COUPON');
                        $coupons = \Bitrix\Sale\Internals\DiscountCouponTable::getList(array(
                            'select'=>$arCouponSelect, 'filter'=>$arCouponFilter));
                        // $arFields["COUPON"] = $coupons;
                        while ($coupon = $coupons->fetch()) {
                            $arFields["COUPON"] = $coupon['COUPON'];
                        }
                    }



                    $resizedFile = \CFile::GetFileArray($arFields['PREVIEW_PICTURE']);
                    $arFields['PREVIEW_PICTURE'] =  $resizedFile['SRC'] ? "https://".$_SERVER['SERVER_NAME'].$resizedFile['SRC'] : "";
                    $resizedFile = \CFile::GetFileArray($arFields['DETAIL_PICTURE']);
                    $arFields['DETAIL_PICTURE'] =  $resizedFile['SRC'] ? "https://".$_SERVER['SERVER_NAME'].$resizedFile['SRC'] : "";
                    $arFields['NAME'] = strip_tags($arFields['NAME']);
                    $arFields['PREVIEW_TEXT'] = strip_tags($arFields['PREVIEW_TEXT']);

                    $arResult[] = $arFields;
                    $CACHE_MANAGER->RegisterTag("element_".$arFields["ID"]);
                }
                $CACHE_MANAGER->RegisterTag("iblock_list");
                $CACHE_MANAGER->EndTagCache();
                $obCache->EndDataCache($arResult);
            } else {
                global $CACHE_MANAGER;
                $CACHE_MANAGER->ClearByTag('iblock_list');
            }

            print json_encode($arResult);
            return ;
        }
        $out->errors[] = Main::addError('0x031','', 'Некорректные параметры запроса');
        print json_encode($out);


        header("HTTP/1.1 201 OK");
        return ;
    }

    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

}
