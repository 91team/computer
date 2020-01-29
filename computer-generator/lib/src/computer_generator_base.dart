import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:computer/computer.dart';
import 'package:source_gen/source_gen.dart';

class IsolateSideLaunchableGenerator extends GeneratorForAnnotation<ComputerLaunchable> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    return '''
    class TestGenerator {
      final a = 5;
    }
''';
  }
}
