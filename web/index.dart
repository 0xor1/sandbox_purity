/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.client;

import 'dart:html';
import 'package:purity/client.dart';
import 'package:sandbox_purity/view/sandbox_purity_view.dart';

void main(){
  initConsumerSettings(
    (googleLogin, proxyEndPoint){
      var view = new GoogleLoginView(googleLogin);
      document.body.children.add(view.html);
    },
    (){
      // no clean up
    },
    'ws');
}