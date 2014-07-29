/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.view;

import 'package:sandbox_purity/interface/sandbox_purity_interface.dart';
import 'package:controls_and_panels/controls_and_panels.dart' as cnp;
import 'package:purity/purity.dart';

class GoogleLoginView extends Consumer{

  dynamic get googleLogin => source;

  cnp.DivElement get html => _cmdLn.html;

  final cnp.CommandLine _cmdLn = new cnp.CommandLine()..fill();
  cnp.CommandLineInputBinder _binder;

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
          googleLogin.login();
        }),
    ]);
  }

  void _hookUpEvents(){
    listen(googleLogin, OAuth2LoginUrlRedirection, (Event<OAuth2LoginUrlRedirection> event){
      cnp.window.open(event.data.url, 'google-login');
    });
  }

}

