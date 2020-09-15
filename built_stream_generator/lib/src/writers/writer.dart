import 'package:analyzer/dart/constant/value.dart';
import 'package:built_stream_generator/src/property.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:meta/meta.dart';

/// A commom writer to indicate the content to generate
///
/// The content generated here includes:
/// 1. [ActionParams] class
/// 2. [ActionResults] class
/// 3. [ActionStart] class
/// 4. [ActionSucceed] class
/// 5. [ActionBloc] class
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
  bool get hasParams => params.isNotEmpty || optionalParams.isNotEmpty;
  @protected
  bool get hasResults => results.isNotEmpty || optionalResults.isNotEmpty;

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
    Property property = Property(value.getField('propertyType').toStringValue(),
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
    Property property = Property(value.getField('propertyType').toStringValue(),
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
    writeBloc(result);
  }

  @protected
  void writeStream(StringBuffer result, DartObject annotation);
  @protected
  void writeBloc(StringBuffer result);

  void _writeParam(StringBuffer result) {
    if (hasParams) {
      result.writeln('class ${action}Params {');
      params.forEach((Property property) {
        result.writeln('final ${property.publicDeclaration};');
      });
      optionalParams.forEach((Property property) {
        result.writeln('final ${property.publicDeclaration};');
      });
      String paramParams =
          params.map((property) => 'this.' + property.publicName).join(', ');
      String optionalParamsStr = '';
      if (optionalParams.isNotEmpty) {
        optionalParamsStr += paramParams.isNotEmpty ? ', ' : '';
        optionalParamsStr +=
            '{${optionalParams.map((property) => 'this.' + property.publicName).join(', ')}}';
      }
      result.writeln(' const ${action}Params($paramParams$optionalParamsStr);');
      result.writeln('}');
    }
  }

  void _writeResult(StringBuffer result) {
    if (hasResults) {
      result.writeln('class ${action}Results {');
      results.forEach((Property property) {
        result.writeln('final ${property.publicDeclaration};');
      });
      optionalResults.forEach((Property property) {
        result.writeln('final ${property.publicDeclaration};');
      });
      String resultParams =
          results.map((property) => 'this.' + property.publicName).join(', ');
      String optionalResultsStr = '';
      if (optionalResults.isNotEmpty) {
        optionalResultsStr += resultParams.isNotEmpty ? ', ' : '';
        optionalResultsStr +=
            '{${optionalResults.map((property) => 'this.' + property.publicName).join(', ')}}';
      }
      result.writeln(
          ' const ${action}Results($resultParams$optionalResultsStr);');
      result.writeln('}');
    }
  }

  void _writeState(StringBuffer result) {
    result.writeln('class ${action}Start implements StreamState {'
        ' const ${action}Start();'
        '}');
    if (hasResults) {
      result.writeln('class ${action}Succeed implements StreamState {'
          ' final ${action}Results results;'
          ' const ${action}Succeed(this.results);'
          '}');
    } else {
      result.writeln('class ${action}Succeed implements StreamState {'
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
}
