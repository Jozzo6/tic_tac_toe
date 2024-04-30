class Property<T> {
  Property(T initialValue, this.notifyListeners) {
    _value = initialValue;
  }

  late T _value;
  final void Function() notifyListeners;

  T get value => _value;

  String? errorMessage;

  set value(T value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }
}
