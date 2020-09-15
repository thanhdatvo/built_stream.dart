import 'package:analyzer/dart/constant/value.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:built_stream_generator/src/writers/writer.dart';

/// A single stream writer that inherate the writer class
/// to indicate the content to generate ComposedStreams classes
///
/// The content generated here includes:
/// 1. [ActionStream] class
/// 2. [ActionError] class
class ComposedStreamsWriter extends Writer {
  ComposedStreamsWriter(String action, List<DartObject> annotations)
      : super(action, annotations);

  @override
  void writeStream(StringBuffer result, DartObject annotation) {
    List<String> streamsTypes = annotation
        .getField('streams')
        .toListValue()
        .map<String>((dartObject) => dartObject.toTypeValue().toString())
        .toList();

    String declareStreamsStr = streamsTypes
        .map<String>((streamsType) =>
            ' $streamsType _${StringUtils().capitalizeOnlyFirstLetter(streamsType)};')
        .join('\n');
    String initStreamsStr = streamsTypes
        .map<String>((streamsType) =>
            ' _${StringUtils().capitalizeOnlyFirstLetter(streamsType)} = $streamsType();')
        .join('\n');
    result.writeln('abstract class _${action}StreamOrigin {'
        '$declareStreamsStr'
        ' Stream<StreamState> process(${paramsTypeString} params);'
        ' _${action}StreamOrigin(){'
        '   $initStreamsStr'
        ' }'
        '}');
  }

  @override
  void writeStreamError(StringBuffer result) {
    result.writeln('class ${action}Error extends StreamError {'
        ' ${action}Error.composeLocation(StreamError streamError, ErrorLocation location)'
        '     : super.composeLocation(streamError, location);'
        ' ${action}Error.init(ErrorLocation location, dynamic error, dynamic payload)'
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
        ' @override'
        ' dispose() => ${renamedClassName}Subject.dispose();'
        '}');
  }
}
