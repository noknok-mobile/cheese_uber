import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Buttons/CustomCheckBox.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Forms/CartBottomAppBar.dart';
import 'package:flutter_cheez/Widgets/Forms/DoneInputView.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldName.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldPhone.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldText.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import 'package:flutter_cheez/Widgets/Pages/WebPage.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'OrdersPage.dart';

class NewOrderPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final double bottomMenuHeight = 160;
  bool enabled = true;
  SharedValue<int> deliveryMethod = SharedValue<int>(value: 1);
  SharedValue<String> phone =
      SharedValue<String>(value: Resources().userProfile?.phone);

  UserAddress _userAddress = UserAddress();
  UserAddress get userAddress {
    return Resources().userProfile.userAddress.length > 0
        ? Resources().userProfile.userAddress.last
        : _userAddress;
  }

  SharedValue<String> addres;
  SharedValue<String> contactName;
  SharedValue<String> entrance;
  SharedValue<String> floor;
  SharedValue<String> flat;
  SharedValue<String> comment;
  NewOrderPage() {
    addres = SharedValue<String>(value: userAddress.addres);
    contactName = SharedValue<String>(value: userAddress.username);
    entrance = SharedValue<String>(value: userAddress.entrance);
    floor = SharedValue<String>(value: userAddress.floor);
    flat = SharedValue<String>(value: userAddress.flat);
    comment = SharedValue<String>(value: "");
  }

  @override
  State<StatefulWidget> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  OverlayEntry overlayEntry;
  FocusNode entranceFocusNode = new FocusNode();
  FocusNode flatFocusNode = new FocusNode();
  FocusNode floorFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();

  void getUserAddress() async {
    print("deliveryParams ----- ");
    UserAddress deliveryParams =
        await Resources().getDeliveryParams("Краснодар,улица Игнатова, 61");
    print(deliveryParams.addres);
  }

  @override
  void initState() {
    [entranceFocusNode, flatFocusNode, floorFocusNode, phoneFocusNode]
        .forEach((element) {
      element.addListener(() {
        if (element.hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
    });

    KeyboardVisibilityNotification().addNewListener(
      onHide: () {
        removeOverlay();
      },
    );
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 0,
        left: 0,
        child: DoneInputView(),
      );
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserAddress();

    // TODO: implement build
    return Center(
      child: Scaffold(
          bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: CartBottomAppBar(
                  isEnable: widget.enabled,
                  height: widget.bottomMenuHeight + 2,
                  onBottomButtonClick: () async {
                    if (widget.formKey.currentState.validate()) {
                      widget.formKey.currentState.save();
                      widget.userAddress.phone = widget.phone.value;
                      widget.userAddress.addres = widget.addres.value;
                      widget.userAddress.flat = widget.flat.value;
                      widget.userAddress.floor = widget.floor.value;
                      widget.userAddress.entrance = widget.entrance.value;
                      widget.userAddress.comment = widget.comment.value;
                      widget.userAddress.username = widget.contactName.value;

                      Resources().saveDeliveryParams(widget.userAddress);

                      setState(() {
                        widget.enabled = false;
                      });

                      await Resources().sendOrderData(
                          Resources().cart,
                          widget.userAddress,
                          widget.deliveryMethod.value,
                          12,
                          Resources().cart.bonusPoints.toInt());
                      Resources().cart.clear();
                      Resources().editAddrese(widget.userAddress);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/orders', (Route<dynamic> route) => false);
                    }
                  })),
          //resizeToAvoidBottomPadding: false,
          backgroundColor: ColorConstants.background,
          appBar: NextPageAppBar(
            height: ParametersConstants.appBarHeight,
            title: TextConstants.profileHeader,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
                child: Container(
                    width: 9999,
                    // height: 9999,
                    decoration: ParametersConstants.BoxShadowDecoration,
                    margin: const EdgeInsets.all(20),
                    child: Form(
                        key: widget.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 16, 16, 16),
                                child: CustomText.black20pxBold(
                                    TextConstants.orderPayHeader),
                              ),
                              Container(
                                height: 1,
                                color: ColorConstants.gray,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: CustomCheckBox(
                                  enabledWidget: Center(
                                      child: Container(
                                    height: 40,
                                    width: 99999,
                                    color: ColorConstants.red,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText.white12px(
                                              TextConstants.orderPayCard),
                                        )),
                                  )),
                                  disabledWidget: Center(
                                      child: Container(
                                    height: 40,
                                    width: 99999,
                                    color: ColorConstants.mainAppColor,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText.black12px(
                                              TextConstants.orderPayCard),
                                        )),
                                  )),
                                  active: false,
                                  value: true,
                                ),
                              ),
                              Container(
                                height: 1,
                                color: ColorConstants.gray,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 16, 16, 16),
                                child: CustomText.black20pxBold(
                                    TextConstants.orderDeliveryHeader),
                              ),
                              Container(
                                height: 1,
                                color: ColorConstants.gray,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: CustomCheckBox(
                                  enabledWidget: Center(
                                      child: Container(
                                    height: 40,
                                    width: 99999,
                                    color: ColorConstants.red,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText.white12px(
                                              TextConstants
                                                  .orderDeliveryCurier),
                                        )),
                                  )),
                                  disabledWidget: Center(
                                      child: Container(
                                    height: 40,
                                    width: 99999,
                                    color: ColorConstants.mainAppColor,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText.black12px(
                                              TextConstants
                                                  .orderDeliveryCurier),
                                        )),
                                  )),
                                  value: widget.deliveryMethod.value == 1,
                                  onChanged: (x) => {
                                    setState(
                                        () => widget.deliveryMethod.value = 1)
                                  },
                                ),
                              ),
                              Container(
                                height: 1,
                                color: ColorConstants.gray,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: CustomCheckBox(
                                  enabledWidget: Center(
                                      child: Container(
                                    height: 40,
                                    width: 99999,
                                    color: ColorConstants.red,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText.white12px(
                                              TextConstants
                                                  .deliveryMethodPickup),
                                        )),
                                  )),
                                  disabledWidget: Center(
                                      child: Container(
                                    height: 40,
                                    width: 99999,
                                    color: ColorConstants.mainAppColor,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText.black12px(
                                              TextConstants
                                                  .deliveryMethodPickup),
                                        )),
                                  )),
                                  onChanged: (x) => {
                                    setState(
                                        () => widget.deliveryMethod.value = 2)
                                  },
                                  value: widget.deliveryMethod.value == 2,
                                ),
                              ),
                              Container(
                                height: 1,
                                color: ColorConstants.gray,
                              ),
                              InputFieldPhone(
                                  decorated: false,
                                  focusNode: phoneFocusNode,
                                  prefix: TextConstants.phone,
                                  value: widget.phone),
                              Container(
                                height:
                                    widget.deliveryMethod.value == 2 ? 0 : null,
                                child: FutureBuilder(
                                  future: Resources().getLocalStorageReady(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    var item = Resources().localStorage.getItem(
                                        widget.userAddress.city +
                                            ',' +
                                            widget.userAddress.addres);

                                    if (item != null) {
                                      UserAddress userAddress =
                                          UserAddress.decode(json.decode(item));

                                      widget.entrance.value =
                                          userAddress.entrance;
                                      widget.floor.value = userAddress.floor;
                                      widget.flat.value = userAddress.flat;
                                      widget.contactName.value =
                                          userAddress.username;
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 16, 16, 16),
                                          child: CustomText.black20pxBold(
                                              TextConstants
                                                  .orderDeliveryAddress),
                                        ),
                                        Container(
                                          height: 1,
                                          color: ColorConstants.gray,
                                        ),
                                        InputFieldText(
                                          decorated: false,
                                          prefix: TextConstants.adres,
                                          textInputType: TextInputType.text,
                                          value: widget.addres,
                                        ),
                                        Container(
                                          height: 1,
                                          color: ColorConstants.gray,
                                        ),
                                        InputFieldText(
                                          decorated: false,
                                          //label: TextConstants.addresEntrance,
                                          focusNode: entranceFocusNode,
                                          textInputType: TextInputType.number,
                                          prefix: TextConstants.addresEntrance,
                                          value: widget.entrance,
                                        ),
                                        Container(
                                          height: 1,
                                          color: ColorConstants.gray,
                                        ),
                                        InputFieldText(
                                            decorated: false,
                                            //label: TextConstants.addresFloor,
                                            focusNode: floorFocusNode,
                                            prefix: TextConstants.addresFloor,
                                            textInputType: TextInputType.number,
                                            value: widget.floor),
                                        Container(
                                          height: 1,
                                          color: ColorConstants.gray,
                                        ),
                                        InputFieldText(
                                            decorated: false,
                                            //label: TextConstants.addresFlat,
                                            focusNode: flatFocusNode,
                                            prefix: TextConstants.addresFlat,
                                            textInputType: TextInputType.number,
                                            value: widget.flat),
                                        Container(
                                          height: 1,
                                          color: ColorConstants.gray,
                                        ),
                                        InputFieldText(
                                            decorated: false,
                                            prefix: TextConstants.contactName,
                                            value: widget.contactName),
                                        Container(
                                          height: 1,
                                          color: ColorConstants.gray,
                                        ),
                                        InputFieldText(
                                          decorated: false,
                                          height: 90,
                                          label: "Комментарий",
                                          maxLines: 50,
                                          value: widget.comment,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ])))),
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    entranceFocusNode.dispose();
    flatFocusNode.dispose();
    floorFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }
}
