/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.model;

import 'package:sandbox_purity/interface/sandbox_purity_interface.dart';
import 'package:purity/purity.dart';

class GoogleLogin extends Source implements IGoogleLogin{

  GoogleLogin(){
    registerSandboxTranTypes();
  }

  void login(){
    emitEvent(new OAuth2LoginUrlRedirection()..url = 'https://accounts.google.com/o/oauth2/auth?redirect_uri=https%3A%2F%2Fdevelopers.google.com%2Foauthplayground&response_type=code&client_id=407408718192.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile&approval_prompt=force&access_type=offline');
  }

}