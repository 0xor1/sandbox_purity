/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.interface;

@MirrorsUsed(targets: const[
  OAuth2LoginUrlRedirection,
  OAuth2LoginComplete,
  OAuth2LoginTimeOut
  ], override: '*')
import 'dart:mirrors';
import 'package:purity/purity.dart';

bool _sandboxTranTypesRegistered = false;
void registerSandboxTranTypes(){
  if(_sandboxTranTypesRegistered){ return; }
  _sandboxTranTypesRegistered = true;
  registerTranTypes('sandbox.purity.interface', 'spi', (){
    registerTranSubtype(OAuth2LoginUrlRedirection, () => new OAuth2LoginUrlRedirection());
    registerTranSubtype(OAuth2LoginComplete, () => new OAuth2LoginComplete());
    registerTranSubtype(OAuth2LoginTimeOut, () => new OAuth2LoginTimeOut());
  });
}

abstract class IGoogleLogin{
  void login();
}

class OAuth2LoginUrlRedirection extends Transmittable implements IOAuth2LoginUrlRedirection{}
abstract class IOAuth2LoginUrlRedirection{
  String url;
}

class OAuth2LoginComplete extends Transmittable implements IOAuth2LoginComplete{}
abstract class IOAuth2LoginComplete{
  bool success;
}

class OAuth2LoginTimeOut extends Transmittable{}