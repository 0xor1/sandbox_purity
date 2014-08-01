/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.model;

import 'dart:io' as io;
import 'package:sandbox_purity/interface/sandbox_purity_interface.dart';
import 'package:purity/purity.dart';

class GoogleLogin extends Source implements IGoogleLogin{

  GoogleLogin(){
    registerSandboxTranTypes();
  }

  void login(){

    var uri = new Uri.https('accounts.google.com', '/o/oauth2/auth', {
      'redirect_uri' : 'http://localhost:4346/oauth2redirect',
      'response_type' : 'code',
      'client_id' : '1084058127345-j5m0ra24902vhuggtf7h9pj27itnr8cl.apps.googleusercontent.com',
      'scope' : 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
      'approval_prompt' : 'auto',
      'access_type' : 'offline',
      'state' : 'hellojusttesting'
    });

    print(uri);

    emitEvent(new OAuth2LoginUrlRedirection()..url = uri.toString());

  }

}