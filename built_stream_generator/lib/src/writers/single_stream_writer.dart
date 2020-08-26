import 'package:analyzer/dart/constant/value.dart';
import 'package:built_stream_generator/src/property.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:built_stream_generator/src/writers/writer.dart';

class SingleStreamWriter extends Writer {
  SingleStreamWriter(String action, List<DartObject> annotations)
      : super(action, annotations);

  @override
  void writeStream(StringBuffer result, DartObject annotation) {
    Property executor;

    String method;
    DartObject executorField = annotation?.getField('executor');
    DartObject methodField = annotation?.getField('method');
    if (methodField != null) {
      method = methodField.toStringValue();
    }
    if (executorField != null) {
      var executorType = executorField.toTypeValue().toString();
      var executorName = StringUtils().capitalizeOnlyFirstLetter(executorType);
      executor = Property(executorType, executorName);
    }

    result.writeln('abstract class _${action}StreamOrigin {'
        ' String get errorMessage;'
        ' ${executor} = ${executor.type}();'
        ' Stream<StreamState> process(${paramsTypeString} params) async* {'
        '   try {'
        '     yield const ${action}Start();'
        '     ${hasResults ? '${action}Results results =' : '' }await ${executor.name}.$method(${hasParams ? 'params' : ''});'
        '     yield ${action}Succeed(${hasResults ? 'results' : ''});'
        '   } catch (error) {'
        '     ErrorLocation location = ErrorLocation(this.runtimeType, errorMessage);'
        '     yield ${action}Error(location, error, ${hasParams ? 'params' : 'null'});'
        '   }'
        ' }'
        '}');
  }

  @override
  void writeStreamError(StringBuffer result) {
    result.writeln('class ${action}Error extends StreamError {'
        ' ${action}Error(ErrorLocation location, Error error, payload)'
        '     : super.init(location, error, payload);'
        '}');
  }
}
