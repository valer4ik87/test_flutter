import 'package:envied/envied.dart';

part 'keys.g.dart';

@Envied(path: 'keys.env')
abstract class Keys {
  @EnviedField(varName: 'GIF_KEY')
  static final String gifKey = _Keys.gifKey;
}