import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_collection/built_collection.dart';

BuiltSet<String> _builtCollectionNames = BuiltSet<String>([
  'BuiltList',
  'BuiltListMultimap',
  'BuiltMap',
  'BuiltSet',
  'BuiltSetMultimap',
]);

class DartTypes {
  static bool isBuiltValue(DartType type) {
    if (type.element is! ClassElement) return false;
    return (type.element as ClassElement)
        .allSupertypes
        .any((interfaceType) => interfaceType.element.name == 'Built');
  }

  static bool isBuiltCollection(DartType type) {
    return _builtCollectionNames
        .any((name) => getName(type).startsWith('$name<'));
  }

  static bool isBuilt(DartType type) =>
      isBuiltValue(type) || isBuiltCollection(type);

  static bool isBuiltCollectionTypeName(String name) =>
      _builtCollectionNames.contains(name);

  static String getName(DartType dartType) {
    if (dartType == null) {
      return null;
    } else if (dartType.isDynamic) {
      return 'dynamic';
    } else if (dartType is FunctionType) {
      return getName(dartType.returnType) +
          ' Function(' +
          dartType.parameters.map((p) => getName(p.type)).join(', ') +
          ')';
    } else if (dartType is InterfaceType) {
      var typeArguments = dartType.typeArguments;
      if (typeArguments.isEmpty || typeArguments.every((t) => t.isDynamic)) {
        return dartType.element.name;
      } else {
        final typeArgumentsStr = typeArguments.map(getName).join(', ');
        return '${dartType.element.name}<$typeArgumentsStr>';
      }
    } else if (dartType is TypeParameterType) {
      return dartType.element.name;
    } else if (dartType.isVoid) {
      return 'void';
    } else {
      throw UnimplementedError('(${dartType.runtimeType}) $dartType');
    }
  }

  /// Turns a type name, optionally with generics, into just the type name.
  static String stripGenerics(String name) {
    var genericsStart = name.indexOf('<');
    return genericsStart == -1 ? name : name.substring(0, genericsStart);
  }
}
