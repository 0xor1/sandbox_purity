/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library StopwatchClient;

import 'dart:html';
import 'package:purity/client.dart';

void main(){
  initConsumerSettings(
    (app, proxyEndPoint){
      //var view = new App(app);
      //document.body.children.add(view.html);
    },
    (){
      //No shutdown code required for this app
    },
    'ws');
}