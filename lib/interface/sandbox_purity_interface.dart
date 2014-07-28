/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.interface;

@MirrorsUsed(targets: const[
  OAuth2LoginUrlRedirection
  ], override: '*')
import 'dart:mirrors';
import 'package:purity/purity.dart';

bool _sandboxTranTypesRegistered = false;
void registerSandboxTranTypes(){
  if(_sandboxTranTypesRegistered){ return; }
  _sandboxTranTypesRegistered = true;
  registerTranTypes('sandbox.purity.interface', 'spi', (){
    registerTranSubtype(OAuth2LoginUrlRedirection, () => new OAuth2LoginUrlRedirection());
  });
}

abstract class IGoogleLogin{
  void login();
}

class OAuth2LoginUrlRedirection extends Transmittable implements IOAuth2LoginUrlRedirection{}
abstract class IOAuth2LoginUrlRedirection{
  String url;
}