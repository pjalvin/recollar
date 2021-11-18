class ComboBoxItem{
  int ?id;
  String ?name;

  ComboBoxItem(this.id, this.name);

  @override
  String toString() {
    return 'ComboBoxItem{id: $id, name: $name}';
  }
}