/// Hold the type and the name value of a declaration
/// for later stringify
///
/// For example
/// ```dart
/// const property = Property('String', 'username');
/// print(property) // will show 'String username' to console
/// ```
class Property {
  final String _type;
  final String _name;
  Property(this._type, this._name);

  String get privateName => '_$_name';
  String get publicName => _name;

  String get type => _type;

  String get privateDeclaration => '$type _$_name';
  String get publicDeclaration => '$type $_name';
}
