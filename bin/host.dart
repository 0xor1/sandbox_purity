/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library sandbox.purity.host;

import 'dart:io';
import 'dart:async';
import 'package:purity/host.dart';
import 'package:purity_oauth2/mock_source/purity_oauth2_mock_source.dart';
import 'package:purity_oauth2/tran/purity_oauth2_tran.dart';

void main(){
  new Host(
    InternetAddress.LOOPBACK_IP_V4,
    4346,
    Platform.script.resolve('../web').toFilePath(),
    (_) => new Future.delayed(new Duration(),() => new MockLogin()),
    (ILogin login) => new Future.delayed(new Duration(), (){ login.close(); }),
    0)
  ..start();
}