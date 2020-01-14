
///Claer all after invoke
///Function(T value)
class CustomWeakEvent<T>{
  final List<Function> callbackList = List<Function>();

  listen(Function callback) => callbackList.add(callback);
  invoke(T value) {

    callbackList.forEach((f){try {f(value);} finally{}});

    callbackList.clear();
  }
}
///Claer all after invoke
///Function()
class EmptyWeakEvent{
  final List<Function> callbackList = List<Function>();

  listen(Function callback) => callbackList.add(callback);
  invoke() {
    callbackList.map((f){try {f();} finally{}});
    callbackList.clear();
  }
}