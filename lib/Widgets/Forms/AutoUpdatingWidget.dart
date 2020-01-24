import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Events/Events.dart';

class AutoUpdatingWidget<T> extends StatefulWidget{


  final Function child;

  AutoUpdatingWidget({Key key,this.child}):super(key:key);
  @override
  State<StatefulWidget> createState() => _AutoUpdatingWidgetState<T>();

}
class _AutoUpdatingWidgetState<T> extends State<AutoUpdatingWidget>{
  StreamSubscription<T>  subscription;
  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<T>().listen((event)=>{ setState(()=>{})});

  }

  @override
  void dispose(){
    super.dispose();
    subscription.cancel();
    subscription = null;

  }
  @override
  Widget build(BuildContext context) {
    return widget.child(context);
  }



}