<?php

namespace Simbirsoft\Mobile\Controller;

use Respect\Rest\Routable;
use Simbirsoft\Mobile\General\Main;
use Bitrix\Sale;
use Simbirsoft\Mobile\Push;
use Simbirsoft\Mobile\Push\CustomFCM; 
//\Bitrix\Main\EventManager::getInstance()->registerEventHandler('sale', 'OnSaleStatusOrder', 'simbirsoft.mobile', 'Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange', 100000);
	//\Bitrix\Main\EventManager::getInstance()->addEventHandler('sale', 'OnSaleStatusOrder', ['Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange']);
class OrderController implements Routable {
    public $arParams = [
        'DISCOUNT_LEVELS_IBLOCK_CODE' => 'discount_levels',
        'USERS_DISCOUNT_LEVELS_IBLOCK_CODE' => 'users_discount_levels'
    ];

    public function post() {
		
		//$fcm_service = new CustomFCM();
			//$fcm_service->pushNotification("qweqwe.qwe",array("title"=>"TEST","body"=>$event));
			
	//\Bitrix\Main\EventManager::getInstance()->unRegisterEventHandler('sale', 'OnSaleStatusOrder',  'simbirsoft.mobile', 'Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChanges', 1);
        GLOBAL $USER;
        $post_data = file_get_contents('php://input');
        $postJson = json_decode($post_data, true);
        $out = new \stdClass();
        $userFields = \Bitrix\Main\UserTable::getById($USER->GetID());
        if(\CModule::IncludeModule('sale')) {
            \CSaleBasket::DeleteAll(\CSaleBasket::GetBasketUserID());
        }
        if(!empty($postJson["cart"])){

            if ($arUser = $userFields->fetch()) {
                $out->id = $USER->GetID();
                //return json_encode("OK");
                foreach($postJson["cart"] as $key=>$value) {

                    $prices = \CCatalogProduct::GetByIDEx($key);
                   // $regionPriceId = get_region_price_id();
                    $price = $prices['PRICES'][$postJson["Region"]]['PRICE'];
                    $out->values["Price"] =  $price;
					
						$res = \CPrice::GetList(
								array(),
								array(
									"PRODUCT_ID" =>  $key,
									"CATALOG_GROUP_ID" => $postJson["Region"]
								)
							);
						 $PRODUCT_PRICE_ID = 1;
						 $out->Region = $postJson["Region"];
						 while ($res1 = $res->fetch()) {
							 $out->res[] = $res1;
							 $PRODUCT_PRICE_ID = $res1["ID"];
						 }
					
					
                    $product = array(
                        'PRODUCT_ID' => $key,
                        'QUANTITY' => $value,
                        'PRICE' => $price,
                        'CURRENCY' => \Bitrix\Currency\CurrencyManager::getBaseCurrency(),
                        'ELEMENT_IBLOCK_ID' => $key,
                        //'CATALOG_GROUP_ID' => $postJson["Region"],
                        'CUSTOM_PRICE' => 'Y',
						"CALLBACK_FUNC" => "",
						'BASE_PRICE'	    => $price,
						'PRODUCT_PROVIDER_CLASS' => '',
						"IGNORE_CALLBACK_FUNC"  => "Y",
						//'PRODUCT_PROVIDER_CLASS' => \Bitrix\Catalog\Product\Basket::getDefaultProviderName(),
						'PRODUCT_PRICE_ID' => $PRODUCT_PRICE_ID,
                    );

                   $basketResult = \Bitrix\Catalog\Product\Basket::addProduct($product);

                    if ($basketResult->isSuccess())
                    {
						
                        $out->status['success'] = true;
                        $data = $basketResult->getData();
                        $basket = \Bitrix\Sale\Basket::loadItemsForFUser(

                            \Bitrix\Sale\Fuser::getId(),

                            \Bitrix\Main\Context::getCurrent()->getSite()

                        );

                        $refreshStrategy = \Bitrix\Sale\Basket\RefreshFactory::create(\Bitrix\Sale\Basket\RefreshFactory::TYPE_FULL);

                        $basket->refresh($refreshStrategy);
                        $basket->save();
                    }
                    else
                    {

                        $out->errors[] = Main::addError('0x012','',  'Ошибка получения профиля');
                    }
                }



            } else {
                $out->errors[] = Main::addError('0x012','', 'Ошибка получения профиля');
                print json_encode($out);
            }
            if(!empty($postJson["address"])) {
                $basket = Sale\Basket::loadItemsForFUser(\Bitrix\Sale\Fuser::getId(), \Bitrix\Main\Context::getCurrent()->getSite());
                $arFields = array(
                    "LID" => SITE_ID,
                    "PERSON_TYPE_ID" => 1,
                    "PAYED" => "N",
                    "CANCELED" => "N",
                    "STATUS_ID" => "N",
                    "PRICE" => $basket->getPrice(),
                    "CURRENCY" => \CSaleLang::GetLangCurrency(SITE_ID),
                    "USER_ID" => IntVal($USER->GetID()),
                    "PAY_SYSTEM_ID" => $postJson["payment"],
					'PRODUCT_PROVIDER_CLASS' => \Bitrix\Catalog\Product\Basket::getDefaultProviderName(),
                    "DELIVERY_ID" => $postJson["delivery"],
                    "TAX_VALUE" => 0.0,
					
                );
                $out->values["SendedBasket"] = $postJson["cart"];
                $out->values["Basket"] = $basket;

// add Guest ID

                if (\CModule::IncludeModule('sale')) {
                    $siteId = \Bitrix\Main\Context::getCurrent()->getSite();
                    $currencyCode = \Bitrix\Currency\CurrencyManager::getBaseCurrency();

// Создаёт новый заказ


                    $order = \Bitrix\Sale\Order::create($siteId, $USER->isAuthorized() ? $USER->GetID() : 539);
                    $order->setPersonTypeId(1);
                    $order->setField('CURRENCY', $currencyCode);
                    $comment = $postJson["comment"];
                    if ($comment) {
                        $order->setField('USER_DESCRIPTION', $comment); // Устанавливаем поля комментария покупателя
                    }
                         $order->setBasket($basket);

                 //   $orderId = \CSaleOrder::Add($arFields);
                  //  \CSaleBasket::OrderBasket($orderId,$USER->GetID(), SITE_ID,array());
                  //  $order = \Bitrix\Sale\Order::load($orderId);
                  //  $order = \Bitrix\Sale\OrderBase::load($orderId);



// Создаём одну отгрузку и устанавливаем способ доставки - "Без доставки" (он служебный)
                    $shipmentCollection = $order->getShipmentCollection();
                    $shipment = $shipmentCollection->createItem();
                    $service = \Bitrix\Sale\Delivery\Services\Manager::getById($postJson["delivery"]/*\Bitrix\Sale\Delivery\Services\EmptyDeliveryService::getEmptyDeliveryServiceId()*/);
                    $shipment->setFields(array(
                        'DELIVERY_ID' => $service['ID'],
                        'DELIVERY_NAME' => $service['NAME'],
                        'PRICE_DELIVERY' => 200,
                        'CUSTOM_PRICE_DELIVERY' => 'Y'
                    ));

                    $shipmentItemCollection = $shipment->getShipmentItemCollection();
                    //  $shipmentItem = $shipmentItemCollection->createItem($item);
                    //  $shipmentItem->setQuantity($item->getQuantity());

// Создаём оплату со способом #1
                    $paymentCollection = $order->getPaymentCollection();
                    $payment = $paymentCollection->createItem();
                    $paySystemService = \Bitrix\Sale\PaySystem\Manager::getObjectById($postJson["payment"]);
                    $payment->setFields(array(
                        'PAY_SYSTEM_ID' => $paySystemService->getField("PAY_SYSTEM_ID"),
                        'PAY_SYSTEM_NAME' => $paySystemService->getField("NAME"),
                    ));
                    $payment->setField("SUM", $order->getPrice() - $postJson["usedBonuce"]);
                    $payment->setField("CURRENCY", $order->getCurrency());

                    \CSaleUserAccount::Pay(
                        $USER->GetID(),
                        $postJson["usedBonuce"],
                        $order->getCurrency(),
                         $order->getId());


// Применяем купон
                    if (\CModule::IncludeModule("sale") && \CModule::IncludeModule("catalog")) {
						\Bitrix\Sale\Compatible\DiscountCompatibility::stopUsageCompatible();
                        $number_coupon = $postJson['coupon']; // номер купона
						$out->number_coupon = $number_coupon;
                        $getCoupon = \Bitrix\Sale\DiscountCouponsManager::getData($number_coupon, true); // получаем информацио о купоне
						
							\CCatalogDiscountCoupon::SetCoupon(
							 $number_coupon
							);
                        if ($getCoupon['ACTIVE'] == "Y") {
                            \Bitrix\Sale\DiscountCouponsManager::init(
                                \Bitrix\Sale\DiscountCouponsManager::MODE_ORDER, [
                                    "userId" => $order->getUserId(),
                                    "orderId" => $order->getId()
                                ]
                            );
							  \CSaleBasket::UpdateBasketPrices(\CSaleBasket::GetBasketUserID(), SITE_ID); 
							\Bitrix\Sale\DiscountCouponsManager::useSavedCouponsForApply(true);
							$discounts = $order->getDiscount();
								$discounts->setOrderRefresh(true);
                            $discountName = $getCoupon['DISCOUNT_NAME'];
                            $takeCoupon = \Bitrix\Sale\DiscountCouponsManager::add($number_coupon); // true - купон есть / false - его нет
							\Bitrix\Sale\DiscountCouponsManager::saveApplied();
							$order->refreshData([ 'PRICE' ,  'COUPONS',]);
							//$discounts = $order->getDiscount() ;
							//$discounts->calculate();
	
						
							
							//$order->doFinalAction(true);
							//$order->save();
					
							  
                           
							 $dbBasketItems = \CSaleBasket::GetList(
										array(
											"NAME" => "ASC",
											"ID" => "ASC"
										),
										array(
												"FUSER_ID" => \CSaleBasket::GetBasketUserID(),
												"LID" => SITE_ID,
											"ORDER_ID" => $order->getId()
										),
										false,
										false,
										 array("ID", "NAME", "CALLBACK_FUNC", "MODULE", 'PRODUCT_PRICE_ID',
												  "PRODUCT_ID", "QUANTITY", "DELAY", 
												  "CAN_BUY", "PRICE", "WEIGHT","PRICE","BASE_PRICE","DISCOUNT_PRICE")
									);
								   while ($arItems = $dbBasketItems->Fetch()) {
										$prices = \CCatalogProduct::GetByIDEx($arItems["PRODUCT_ID"]);
											$res = \CPrice::GetList(
													array(),
													array(
														"PRODUCT_ID" =>  $arItems["PRODUCT_ID"],
														"CATALOG_GROUP_ID" => $postJson["Region"]
													)
												);
											 $PRODUCT_PRICE_ID = 1;
											
											 while ($res1 = $res->fetch()) {
													$out->Res2 = $res1;
												  $arItems['PRODUCT_PRICE_ID'] = $res1["ID"];
												  
												  $arItems['PRICE'] = $res1["PRICE"];
											 }
									
										$arOrder['BASKET_ITEMS'][] = $arItems;
										$arBasketItems[] = $arItems;

								   }
								   $arOrder['SITE_ID'] = SITE_ID;
								   $arOrder['USER_ID'] = $USER->GetID();
								  
								   
								  
								   
								 
								   \CSaleDiscount::DoProcessOrder($arOrder,array(),$arErrors);
								   \CSaleBasket::UpdateBasketPrices(\CSaleBasket::GetBasketUserID(), SITE_ID); 
								   
									$basket->refreshData(array('PRICE', 'COUPONS','DISCOUNT_PRICE','PRODUCT_PRICE_ID'));
									//$basket = \Bitrix\Sale\Basket::loadItemsForFUser(\Bitrix\Sale\Fuser::getId(), \Bitrix\Main\Context::getCurrent()->getSite());
									
									$basket->save();
							
							
													$basket = $order->getBasket();
							$discount=  \Bitrix\Sale\Discount::setOrder($basket); //$order->getDiscount();
							$discount->setOrderRefresh(true);
								$result =  $discount->getApplyResult();
								$out->ApplyResult = $result;
								
								foreach($result["ORDER"] as $orders){
										if($orders["RESULT"]["BASKET"]){
											
											foreach($orders["RESULT"]["BASKET"] as $key => $discountBasket){
												
												if($discountBasket["DESCR_DATA"]){
													foreach($discountBasket["DESCR_DATA"] as $discountval){
														//$quantity = $basket->getItemById($discountBasket["BASKET_ID"])->getQuantity();
														$out->resultDiscount[$key] = $discountval["RESULT_VALUE"]/*doubleval($out->resultDiscount[$key] +*/  /** $quantity)*/;
															///$out->discountType =  $BASKET["VALUE_TYPE"]; 
													}
													
												}
											}
												
										}
									}
								 
								  foreach ($arBasketItems as $basketItem) { 
										$basketItem["BASE_PRICE"] = $basketItem["PRICE"];
										$basketItem["PRICE"] = $basketItem["PRICE"] - $out->resultDiscount[$basketItem['ID']];
										$basketItem["DISCOUNT_PRICE"] = $out->resultDiscount[$basketItem['ID']] ;
								
										\CSaleBasket::Update(
										 $basketItem["ID"],
										 $basketItem
										);
										
										
									 $out->basket[] =$arBasketItems;
									} 
									
								$basket->refreshData(array('PRICE', 'COUPONS','DISCOUNT_PRICE','PRODUCT_PRICE_ID'));
							 $out->discount1 = $discount->setApplyResult(
									$out->discount2);
									$res = $order->refreshData(["PRICE", "COUPONS",]);
									$discount->setOrderRefresh(true);
							$res->calculate = $discount->calculate();
							$res->refData = $basket->refreshData(array('PRICE', 'COUPONS','DISCOUNT_PRICE','PRODUCT_PRICE_ID'));
							$order->doFinalAction(true);
								$order->refreshData();
							$order->save();
						
						//	$res = $basket->refreshData(["PRICE", "COUPONS"]);
							$basket->refreshData(array('PRICE', 'COUPONS','DISCOUNT_PRICE'));
						
							$discount->setOrder($basket);
							$discount->save();
                            if ($takeCoupon) {
                                $out->coupon = "Купон Активирован";
                            } else {
                                $out->coupon = "Ошибка Активации купона";
                            }

                        } else if (!$getCoupon['ACTIVE']) {
                            $out->coupon = "Мы не нашли такого купона :(";
                        } else {
                           $out->coupon = "Купон уже активирован, попробуйте другой :(";
                        }
						\Bitrix\Sale\Compatible\DiscountCompatibility::revertUsageCompatible();
                    }

// Устанавливаем свойства

                    $propertyCollection = $order->getPropertyCollection();

                    foreach ($postJson["address"] as $key => $value){


                        if(intval($key)) {
                            $propertyValue = $propertyCollection->getItemByOrderPropertyId(intval($key));

                            $out->address[]["key"] = $key;
                            $out->address[]["value"] = $value;
                            $out->address[]["value"] = $propertyValue ;

                            if ($propertyValue && $value) {
                                $propertyValue->setValue($value);

                            }
                        }

                    }
                   // return json_encode($out);
                    /*

                    $phoneProp = $propertyCollection->getPhone();
                    $phoneProp->setValue("12313123");
                    $nameProp = $propertyCollection->getPayerName();
                    $nameProp->setValue("qweqwewqe");*/

// Сохраняем
                    $order->doFinalAction(true);
                    $result = $order->save();
                    $orderId = $order->getId();

                    $out->propertyCollection = $propertyCollection;
                    $out->result = $result;
                    $out->order_id = $orderId;

                    $arFields = array(
                        "USER_ID" => IntVal($USER->GetID()),
                        "DELIVERY_ID" => $postJson["delivery"],
                    );
	
				

                }
            }
            return json_encode($out);

        } else {
            /*
            if(\CModule::IncludeModule('sale')) {
                \CSaleBasket::DeleteAll(\CSaleBasket::GetBasketUserID());
            }
            $out->basket
             print json_encode($out);*/
        }
        header("HTTP/1.1 200 OK");
        return ;
    }


	  
	  
	  
	  

	
    public function get() { header("HTTP/1.1 404 Not Found"); }
    public function put() { header("HTTP/1.1 404 Not Found"); }
    public function delete() { header("HTTP/1.1 404 Not Found"); }

}
	class OrderStatusHandler {
	  function OnSaleStatusOrderChanges($event)
	  {
			//$parameters = $event->getParameters();
			$fcm_service = new CustomFCM();
			$fcm_service->pushNotification("qweqwe.qwe",array("title"=>"TEST","body"=>$event));
			//\Bitrix\Main\EventManager::getInstance()->addEventHandler('sale', 'OnSaleOrderSaved', ['Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange']);
			//\Bitrix\Main\EventManager::getInstance()->addEventHandler('sale', 'OnSaleStatusOrderChange', ['Simbirsoft\Mobile\Controller\OrderStatusHandler', 'OnSaleStatusOrderChange']);
	  }
	}