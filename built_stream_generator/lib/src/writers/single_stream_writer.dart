import 'package:analyzer/dart/constant/value.dart';
import 'package:built_stream_generator/src/property.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:built_stream_generator/src/writers/writer.dart';

/// A single stream writer that inherate the writer class
/// to indicate the content to generate SingleStream classes
///
/// The content generated here includes:
/// 1. [ActionStream] class
/// 2. [ActionError] class
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
        ' ${executor.privateDeclaration} = ${executor.type}();'
        ' int _callOrder;'
        ' bool _onlyNewestCall;'
        ' _${action}StreamOrigin() {'
        '   _callOrder = 0;'
        '   _onlyNewestCall = false;'
        ' }'
        ' set onlyNewestCall(onlyNewestCall) => _onlyNewestCall = onlyNewestCall;'
        ''
        ' Stream<StreamState> process(${paramsTypeString} params) async* {'
        '   _callOrder++;'
        '   int callOrder = _callOrder;'
        '   try {'
        '     yield const ${action}Start();'
        '     ${hasResults ? '${action}Results results =' : ''}await ${executor.privateName}.$method(${hasParams ? 'params' : ''});'
        '     if (_onlyNewestCall && callOrder != _callOrder) return;'
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
        ' ${action}Error(ErrorLocation location, dynamic error, dynamic payload)'
        '     : super.init(location, error, payload);'
        '}');
  }

  @override
  void writeBloc(StringBuffer result) {
    final renamedClassName = StringUtils().capitalizeOnlyFirstLetter(action);

    result.writeln('class ${action}Bloc implements StreamBloc{'
        ' ${action}Stream _${renamedClassName}Stream;'
        ' TransformerSubject<${paramsTypeString}, StreamState> ${renamedClassName}Subject;'
        ' ${action}Bloc() {'
        '   _${renamedClassName}Stream = ${action}Stream();'
        '   ${renamedClassName}Subject = TransformerSubject<${paramsTypeString}, StreamState>(_${renamedClassName}Stream.process);'
        ' }'
        ' set onlyNewestCall(onlyNewestCall) => _${renamedClassName}Stream.onlyNewestCall = onlyNewestCall;'
        ' @override'
        ' dispose() => ${renamedClassName}Subject.dispose();'
        '}');
  }
}
