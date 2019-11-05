import 'package:meta/meta.dart';

@immutable
abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {}