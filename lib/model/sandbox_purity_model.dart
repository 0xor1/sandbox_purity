/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.model;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:bson/bson.dart';
import 'package:sandbox_purity/interface/sandbox_purity_interface.dart';
import 'package:purity/purity.dart';

class GoogleLogin extends Source implements IGoogleLogin{

  static final Map<ObjectId, GoogleLogin> _activeLogins = new Map<ObjectId, GoogleLogin>();
  static bool _firstTimeSetupRequired = true;

  final ObjectId _loginId = new ObjectId();
  String refreshToken;
  String accessToken;

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
      'state' : _loginId.toHexString()
    });

    emitEvent(new OAuth2LoginUrlRedirection()..url = uri.toString());

  }

  static void _handleOauth2Redirect(HttpRequest authReq) {

    var loginIdHexString = authReq.uri.queryParameters['state'];

    if(loginIdHexString == null){
      return;
    }

    var loginId = new ObjectId.fromHexString(loginIdHexString);
    var login = _activeLogins.remove(loginId);

    if(login != null){
      var error = authReq.uri.queryParameters['error'];
      if(error == 'access_denied'){
        login.emitEvent(new OAuth2LoginAccessDenied());
      }
      else{
        //swap authorization token for access token
        var code = authReq.uri.queryParameters['code'];
        var uri = new Uri.https('accounts.google.com', '/o/oauth2/token');
        var fields = {
          'redirect_uri' : 'http://localhost:4347',
          'code' : code,
          'client_id' : '1084058127345-j5m0ra24902vhuggtf7h9pj27itnr8cl.apps.googleusercontent.com',
          'client_secret' : 'yX9U5oCY3G4UE9rQQ_1gDC_B',
          'grant_type' : 'authorization_code'
        };
        var urlStr = uri.toString();
        var httpClient = new http.Client();
        httpClient.post(uri, body: fields)
        .then((http.Response accessRes){
          //get user info
          Map<String, String> accessObj = convert.JSON.decode(accessRes.body);
          var accessToken = accessObj['access_token'];
          var uri = new Uri.https('www.googleapis.com', '/userinfo/v2/me');
          httpClient.get(uri, headers: {'Authorization': 'Bearer $accessToken'})
          .then((http.Response dataRes){
            var str = dataRes.body;
            Map<String, String> dataObj = convert.JSON.decode(dataRes.body);
            login.emitEvent(
              new OAuth2LoginUserDetails()
              ..firstName = dataObj['given_name']
              ..lastName = dataObj['family_name']
              ..id = dataObj['id']
              ..email = dataObj['email']
              ..displayName = dataObj['name']
              ..imageUrl = dataObj['picture']);
          });
        });
        login.emitEvent(new OAuth2LoginAccessGranted());
      }

    }

    authReq.response.close();

  }

}