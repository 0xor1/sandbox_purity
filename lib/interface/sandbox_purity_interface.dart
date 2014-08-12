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
    registerTranSubtype(OAuth2LoginUnkownError, () => new OAuth2LoginUnkownError());
    registerTranSubtype(OAuth2LoginUserDetails, () => new OAuth2LoginUserDetails());
  });
}

abstract class ILogin{
  /// start the oauth2 login process.
  void login();
  /// set the time in seconds from when the login process starts to the point when it times out.
  void setLoginTimeout(int seconds);
  /// request a resource, this will fail if the login has not already successfully completed.
  void requestResource(String resource, {Map<String, String> headers});
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

class Oauth2ResourceResponse extends Transmittable implements IOauth2ResourceResponse{}
abstract class IOauth2ResourceResponse{
  String response;
}