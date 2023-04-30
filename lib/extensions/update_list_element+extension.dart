extension UpdateListElementExtension on List {
  List update({
    required dynamic key,
    required dynamic newValue,
  }) {
    int index = indexWhere((element) => element == key);
    removeAt(index);
    insert(index, newValue);
    return this;
  }
}
