class StackList<E> {
  StackList() : _storage = <E>[]; //初期化子リスト
  final List<E> _storage;

  @override
  String toString() {
    return '--- トップ ---\n'
        '${_storage.reversed.join('\n')}'
        '\n-----------';
  }

  void push(E element) => _storage.add(element);
  E pop() => _storage.removeLast();

  E get peek => _storage.last;
  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => !isEmpty;
}