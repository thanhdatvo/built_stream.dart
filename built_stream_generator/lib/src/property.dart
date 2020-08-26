/// Hold the type and the name value of a declaration
/// for later stringify
///
/// For example
/// ```dart
/// const property = Property('String', 'username');
/// print(property) // will show 'String username' to console
/// ```
class Property {
  final String type;
  final String name;

  Property(this.type, this.name);
  @override
  String toString() {
    return '$type $name';
  }
}
