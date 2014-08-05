/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.model;

import 'dart:io';
import 'dart:async';
import 'package:bson/bson.dart';
import 'package:sandbox_purity/interface/sandbox_purity_interface.dart';
import 'package:purity/purity.dart';

class GoogleLogin extends Source implements IGoogleLogin{

  static final Map<ObjectId, GoogleLogin> _activeLogins = new Map<ObjectId, GoogleLogin>();
  static bool _firstTimeSetupRequired = true;

  final ObjectId _loginId = new ObjectId();



  GoogleLogin(){
    if(_firstTimeSetupRequired){
      registerSandboxTranTypes();
      HttpServer.bind(InternetAddress.ANY_IP_V4, 4347).then((server){
        server.listen((request){
          _handleOauth2Redirect(request);
        });
      });
    }
    _firstTimeSetupRequired = false;
  }

  void _handleOauth2Redirect(HttpRequest request) {
    var login = _activeLogins.remove(_loginId);
    if(login != null){
      login.emitEvent(new OAuth2LoginComplete());
    }
    request.response.close();
  }

  void login(){

    _activeLogins[_loginId] = this;

    new Future.delayed(new Duration(seconds: 60),(){
      var login = _activeLogins.remove(_loginId);
      if(login != null){
        login.emitEvent(new OAuth2LoginTimeOut());
      }
    });

    var uri = new Uri.https('accounts.google.com', '/o/oauth2/auth', {
      'redirect_uri' : 'http://localhost:4347',
      'response_type' : 'code',
      'client_id' : '1084058127345-j5m0ra24902vhuggtf7h9pj27itnr8cl.apps.googleusercontent.com',
      'scope' : 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
      'approval_prompt' : 'auto',
      'access_type' : 'offline',
      'state' : 'hellojusttesting'
    });

    emitEvent(new OAuth2LoginUrlRedirection()..url = uri.toString());

  }

}