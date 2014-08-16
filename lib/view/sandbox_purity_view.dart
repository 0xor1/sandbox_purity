/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.view;

import 'package:purity_oauth2/tran/purity_oauth2_tran.dart';
import 'package:controls_and_panels/controls_and_panels.dart' as cnp;
import 'package:purity/purity.dart';

class GoogleLoginView extends Consumer{

  dynamic get googleLogin => source;

  cnp.DivElement get html => _cmdLn.html;

  final cnp.CommandLine _cmdLn = new cnp.CommandLine()..fill();
  cnp.CommandLineInputBinder _binder;
  cnp.WindowBase _loginWindow;

  GoogleLoginView(src)
  : super(src){
    registerPurityOAuth2TranTypes();
    _binder = new cnp.CommandLineInputBinder(_cmdLn);
    _addCommandBindings();
    _hookUpEvents();
    _cmdLn.enterText('Welcome to the Google Login sandbox app, enter g-login to start the login flow');
  }

  void _addCommandBindings(){
    _binder.addAll([
      new cnp.CommandLineBinding(
        'g-login',
        'logs in using google oauth 2',
        (cnp.CommandLine cmdLn, List<String> posArgs, Map<String, String> namArgs){
          googleLogin.login();
        })
    ]);
  }

  void _hookUpEvents(){
    listen(googleLogin, OAuth2LoginUrlRedirection, (Event<OAuth2LoginUrlRedirection> event){
      _loginWindow = cnp.window.open(event.data.url, 'google-login');
    });
    listen(googleLogin, OAuth2LoginTimeOut, (Event<OAuth2LoginTimeOut> event){
      _cmdLn.enterText('login timed out, please try again');
      _loginWindow.close();
    });
    listen(googleLogin, OAuth2LoginAccessDenied, (Event<OAuth2LoginAccessDenied> event){
      _cmdLn.enterText('login failed for reason - ACCESS_DENIED');
      _loginWindow.close();
    });
    listen(googleLogin, OAuth2LoginUnkownError, (Event<OAuth2LoginUnkownError> event){
      _cmdLn.enterText('login failed for unknown error, please try again');
      _loginWindow.close();
    });
    listen(googleLogin, OAuth2LoginAccessGranted, (Event<OAuth2LoginAccessGranted> event){
      _cmdLn.enterText('login success!!');
      _loginWindow.close();
    });
    listen(googleLogin, OAuth2LoginUserDetails, (Event<OAuth2LoginUserDetails> event){
      var data = event.data;
      _cmdLn.enterText('image:');
      _cmdLn.enterHtml('<img src="${data.imageUrl}" alt="User profile image" height="100" width="100" style="width:100px;" />');
      _cmdLn.enterText('user details retreived!!');
      _cmdLn.enterText('firstName: ${data.firstName}');
      _cmdLn.enterText('lastName: ${data.lastName}');
      _cmdLn.enterText('id: ${data.id}');
      _cmdLn.enterText('email: ${data.email}');
      _cmdLn.enterText('displayName: ${data.displayName}');
    });
    listen(googleLogin, Oauth2ResourceResponse, (Event<Oauth2ResourceResponse> event){
      var data = event.data;
      _cmdLn.enterText('resource request response:');
      _cmdLn.enterText(data.response);
    });
  }

}

