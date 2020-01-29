library computer_generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/computer_generator_base.dart';

Builder isolateSideLaunchableGenerator(BuilderOptions options) =>
    SharedPartBuilder([IsolateSideLaunchableGenerator()], 'launchable');
