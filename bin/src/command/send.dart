// Copyright (C) 2020-2022 Jason C.H
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:convert/convert.dart';
import 'package:logging/logging.dart';
import 'package:miio_new/miio_new.dart';
import 'package:miio_new/src/utils.dart';

class SendCommand extends Command<void> {
  @override
  final String name = 'send';

  @override
  final String description = 'Send packet to device.';

  late final String? ip;
  late final String? token;
  late final String? payload;

  SendCommand() {
    argParser
      ..addOption(
        'ip',
        help: 'The IP address to send packet.',
        valueHelp: '192.168.1.100',
        callback: (s) => ip = s,
      )
      ..addOption(
        'token',
        help: 'The token of device.',
        valueHelp: 'ffffffffffffffffffffffffffffffff',
        callback: (s) => token = s,
      )
      ..addOption(
        'payload',
        help: 'The payload of packet.',
        callback: (s) => payload = s,
      );
  }

  @override
  Future<void> run() async {
    if (ip == null || token == null || payload == null) {
      Logger.root.severe('Option ip, token and payload are required.');
      printUsage();
      return;
    }

    final address = InternetAddress.tryParse(ip!);
    if (address == null) {
      Logger.root.severe('Invalid IP address: $ip');
      printUsage();
      return;
    }

    late final List<int> binaryToken;
    try {
      binaryToken = hex.decode(token!);
    } on FormatException catch (e) {
      Logger.root.severe('$e\nwhile parsing token.');
      printUsage();
      return;
    }

    if (binaryToken.length != 16) {
      Logger.root.warning(
        '${binaryToken.length} bytes token is abnormal.\n'
        'This may cause undefined behavior.',
      );
    }

    final Map<String, dynamic> payloadMap;
    try {
      dynamic decoded = jsonDecode(payload!);
      if (decoded is List) {
        throw FormatException('Payload can only be JSON map');
      }
      payloadMap = decoded;
    } on FormatException catch (e) {
      Logger.root.severe('$e\nwhile parsing payload.');
      printUsage();
      return;
    }

    final hello = await MiIO.instance.hello(address);
    final resp = await MiIO.instance.send(
      address,
      await MiIOPacket.build(
        hello.deviceId,
        binaryToken,
        payload: payloadMap,
        stamp: MiIO.instance.stampOf(hello.deviceId),
      ),
    );
    print(jsonEncoder.convert(resp.payload));
  }
}
