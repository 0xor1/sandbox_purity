/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.view;

import 'package:sandbox_purity/interface/sandbox_purity_interface.dart';
import 'package:controls_and_panels/controls_and_panels.dart' as cnp;
import 'package:purity/purity.dart';

class GoogleLoginView extends Consumer{

  dynamic get login => source;

  cnp.DivElement get html => _cmdLn.html;

  final cnp.CommandLine _cmdLn = new cnp.CommandLine()..fill();
  cnp.CommandLineInputBinder _binder;
  cnp.WindowBase _loginWindow;

  GoogleLoginView(src)
  : super(src){
    registerSandboxTranTypes();
    _binder = new cnp.CommandLineInputBinder(_cmdLn);
    _addCommandBindings();
    _hookUpEvents();
  }

  void _addCommandBindings(){
    _binder.addAll([
      new cnp.CommandLineBinding(
        'g-login',
        'logs in using google oauth 2',
        (cnp.CommandLine cmdLn, List<String> posArgs, Map<String, String> namArgs){
          login.login();
        }),
    ]);
  }

  void _hookUpEvents(){
    listen(login, OAuth2LoginUrlRedirection, (Event<OAuth2LoginUrlRedirection> event){
      _loginWindow = cnp.window.open(event.data.url, 'google-login');
    });
    listen(login, OAuth2LoginTimeOut, (Event<OAuth2LoginTimeOut> event){
      _cmdLn.enterText('login timed out, please try again');
      _loginWindow.close();
    });
    listen(login, OAuth2LoginTimeOut, (Event<OAuth2LoginAccessDenied> event){
      _cmdLn.enterText('login failed for reason - ACCESS_DENIED');
      _loginWindow.close();
    });
    listen(login, OAuth2LoginTimeOut, (Event<OAuth2LoginUnkownError> event){
      _cmdLn.enterText('login failed for unknown error, please try again');
      _loginWindow.close();
    });
    listen(login, OAuth2LoginAccessGranted, (Event<OAuth2LoginAccessGranted> event){
      _cmdLn.enterText('login success!!');
      _loginWindow.close();
    });
    listen(login, OAuth2LoginUserDetails, (Event<OAuth2LoginUserDetails> event){
      var data = event.data;
      _cmdLn.enterText('image:');
      _cmdLn.enterHtml('<img src="${data.imageUrl}"></img>');
      _cmdLn.enterText('user details retreived!!');
      _cmdLn.enterText('firstName: ${data.firstName}');
      _cmdLn.enterText('lastName: ${data.lastName}');
      _cmdLn.enterText('id: ${data.id}');
      _cmdLn.enterText('email: ${data.email}');
      _cmdLn.enterText('displayName: ${data.displayName}');
    });
  }

}

