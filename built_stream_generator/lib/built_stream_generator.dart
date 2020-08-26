import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:built_stream_generator/src/utils/string_utils.dart';
import 'package:built_stream_generator/src/writers/single_stream_writer.dart';
import 'package:built_stream_generator/src/writers/composed_streams_writer.dart';
import 'package:source_gen/source_gen.dart';

/// Generate code from source that start with `@SingleStream` or `@ComposeStream`
///
class BuiltStreamGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    var result = StringBuffer();
    for (var element in library.allElements) {
      if (element is ClassElement) {
        String action = StringUtils().getAction(element.displayName);
        final annotations = element.metadata
            .map((annotation) => annotation.computeConstantValue())
            .toList();

        final annotation = annotations.firstWhere((element) =>
            element.type.getDisplayString() == "SingleStream" ||
            element.type.getDisplayString() == "ComposedStreams");

        if (annotation == null) {
          throw "There must be one writer annotation";
        } else if (annotation.type.getDisplayString() == "SingleStream") {
          SingleStreamWriter(action, annotations).write(result, annotation);
        } else if (annotation.type.getDisplayString() == "ComposedStreams") {
          ComposedStreamsWriter(action, annotations).write(result, annotation);
        }
      }
    }
    return result.toString();
  }
}
