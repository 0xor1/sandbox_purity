/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.host;

import 'dart:io';
import 'dart:async';
import 'package:purity/host.dart';

void main(){
  var server = new Host(
    InternetAddress.LOOPBACK_IP_V4,
    4346,
    Platform.script.resolve('../web').toFilePath(),
    (_) => new Future.delayed(new Duration(),() => {/*new <insert App object here>()*/}),
    (app) => new Future.delayed(new Duration(), (){}),
    0);
}