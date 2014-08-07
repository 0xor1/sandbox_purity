/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.interface;

@MirrorsUsed(targets: const[
  OAuth2LoginUrlRedirection,
  OAuth2LoginAccessGranted
  ], override: '*')
import 'dart:mirrors';
import 'package:purity/purity.dart';

bool _sandboxTranTypesRegistered = false;
void registerSandboxTranTypes(){
  if(_sandboxTranTypesRegistered){ return; }
  _sandboxTranTypesRegistered = true;
  registerTranTypes('sandbox.purity.interface', 'spi', (){
    registerTranSubtype(OAuth2LoginUrlRedirection, () => new OAuth2LoginUrlRedirection());
    registerTranSubtype(OAuth2LoginAccessGranted, () => new OAuth2LoginAccessGranted());
    registerTranSubtype(OAuth2LoginTimeOut, () => new OAuth2LoginTimeOut());
    registerTranSubtype(OAuth2LoginAccessDenied, () => new OAuth2LoginAccessDenied());
    registerTranSubtype(OAuth2LoginUserDetails, () => new OAuth2LoginUserDetails());
  });
}

abstract class IGoogleLogin{
  void login();
}

class OAuth2LoginUrlRedirection extends Transmittable implements IOAuth2LoginUrlRedirection{}
abstract class IOAuth2LoginUrlRedirection{
  String url;
}

class OAuth2LoginAccessGranted extends Transmittable{}

class OAuth2LoginTimeOut extends Transmittable{}

class OAuth2LoginAccessDenied extends Transmittable{}

class OAuth2LoginUnkownError extends Transmittable{}

class OAuth2LoginUserDetails extends Transmittable implements IOAuth2LoginUserDetails{}
abstract class IOAuth2LoginUserDetails{
  String firstName;
  String lastName;
  String id;
  String email;
  String displayName;
  String imageUrl;
}