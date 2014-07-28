/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.host;

import 'dart:io';
import 'dart:async';
import 'package:purity/host.dart';
import 'package:sandbox_purity/model/sandbox_purity_model.dart';

void main(){
  var server = new Host(
    InternetAddress.LOOPBACK_IP_V4,
    4346,
    Platform.script.resolve('../web').toFilePath(),
    (_) => new Future.delayed(new Duration(),() => new GoogleLogin()),
    (app) => new Future.delayed(new Duration(), (){}),
    0);
}