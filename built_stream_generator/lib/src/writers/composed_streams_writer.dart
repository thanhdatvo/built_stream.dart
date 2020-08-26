import 'package:analyzer/dart/constant/value.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:built_stream_generator/src/writers/writer.dart';

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
        ' ${action}Error(StreamError streamError, ErrorLocation location)'
        '     : super.composeLocation(streamError, location);'
        '}');
  }
}