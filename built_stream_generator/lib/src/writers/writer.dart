import 'package:analyzer/dart/constant/value.dart';
import 'package:built_stream_generator/src/property.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:meta/meta.dart';

abstract class Writer {
  @protected
  List<DartObject> annotations;
  @protected
  String action;
  @protected
  List<Property> params = [];
  @protected
  List<Property> optionalParams = [];
  @protected
  List<Property> results = [];
  @protected
  List<Property> optionalResults = [];

  @protected
  bool get hasParams => params.length > 0 || optionalParams.length > 0;
  @protected
  bool get hasResults => results.length > 0 || optionalResults.length > 0;
  
  Writer(this.action, this.annotations) {
    annotations.forEach((value) {
      if (value.type.displayName == 'StreamParam') {
        _initParams(value);
      }

      if (value.type.displayName == 'StreamResult') {
        _initResults(value);
      }
    });
  }
  void _initParams(DartObject value) {
    Property property = Property(
        value.getField('propertyType').toTypeValue().toString(),
        value.getField('propertyName').toStringValue());
    dynamic optionalField = value.getField('optional');
    bool optional;
    if (optionalField != null) {
      optional = optionalField.toBoolValue();
    }

    if (optional) {
      optionalParams.add(property);
    } else {
      params.add(property);
    }
  }

  void _initResults(DartObject value) {
    Property property = Property(
        value.getField('propertyType').toTypeValue().toString(),
        value.getField('propertyName').toStringValue());

    dynamic optionalField = value.getField('optional');
    bool optional;
    if (optionalField != null) {
      optional = optionalField.toBoolValue();
    }

    if (optional) {
      optionalResults.add(property);
    } else {
      results.add(property);
    }
  }

  void write(StringBuffer result, DartObject annotation) {
    _writeParam(result);
    _writeResult(result);
    _writeState(result);
    writeStream(result, annotation);
    _writeBloc(result);
  }

  @protected
  void writeStream(StringBuffer result, DartObject annotation);

  void _writeParam(StringBuffer result) {
    if (hasParams) {
      result.writeln('class ${action}Params {');
      params.forEach((Property property) {
        result.writeln('final $property;');
      });
      optionalParams.forEach((Property property) {
        result.writeln('final $property;');
      });
      String paramParams =
          params.map((property) => 'this.' + property.name).join(', ');
      String optionalParamsStr = '';
      if (optionalParams.length > 0) {
        optionalParamsStr += paramParams.length > 0 ? ', ' : '';
        optionalParamsStr +=
            '{${optionalParams.map((property) => 'this.' + property.name).join(', ')}}';
      }
      result.writeln(' const ${action}Params($paramParams$optionalParamsStr);');
      result.writeln('}');
    }
  }

  void _writeResult(StringBuffer result) {
    if (hasResults) {
      result.writeln('class ${action}Results {');
      results.forEach((Property property) {
        result.writeln('final $property;');
      });
      optionalResults.forEach((Property property) {
        result.writeln('final $property;');
      });
      String resultParams =
          results.map((property) => 'this.' + property.name).join(', ');
      String optionalResultsStr = '';
      if (optionalResults.length > 0) {
        optionalResultsStr += resultParams.length > 0 ? ', ' : '';
        optionalResultsStr +=
            '{${optionalResults.map((property) => 'this.' + property.name).join(', ')}}';
      }
      result.writeln(
          ' const ${action}Results($resultParams$optionalResultsStr);');
      result.writeln('}');
    }
  }

  void _writeState(StringBuffer result) {
    result.writeln('class ${action}Start implements StreamState {'
        ' @override'
        ' bool get isLoading => true;'
        ' const ${action}Start();'
        '}');
    if (hasResults) {
      result.writeln('class ${action}Succeed implements StreamState {'
          ' @override'
          ' bool get isLoading => false;'
          ' final ${action}Results results;'
          ' const ${action}Succeed(this.results);'
          '}');
    } else {
      result.writeln('class ${action}Succeed implements StreamState {'
          ' @override'
          ' bool get isLoading => false;'
          ' const ${action}Succeed();'
          '}');
    }
    writeStreamError(result);
  }

  @protected
  void writeStreamError(StringBuffer result);

  @protected
  String get paramsTypeString {
    if (hasParams) {
      return '${action}Params';
    } else {
      return 'EmptyParams';
    }
  }

  void _writeBloc(StringBuffer result) {
    final renamedClassName = StringUtils().capitalizeOnlyFirstLetter(action);

    result.writeln('class ${action}Bloc implements Disposable{'
        ' ${action}Stream _${renamedClassName}Stream;'
        ' ConvertSubject<${paramsTypeString}, StreamState> ${renamedClassName}Subject;'
        ' ${action}Bloc() {'
        '   _${renamedClassName}Stream = ${action}Stream();'
        '   ${renamedClassName}Subject = ConvertSubject<${paramsTypeString}, StreamState>(_${renamedClassName}Stream.process);'
        ' }'
        ' @override'
        ' dispose() => ${renamedClassName}Subject.dispose();'
        '}');
  }
}
