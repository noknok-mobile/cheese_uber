

import 'package:flutter_cheez/Events/CustomEvent.dart';

class SharedValue<T>{
  T _value;
  T get value{
    return _value;
  }
  set value(T val){
    _value = value;
    onChange.invoke(value);
  }
  final CustomWeakEvent<T> onChange = CustomWeakEvent<T>();
}