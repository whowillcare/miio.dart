// Copyright (C) 2020-2021 Jason C.H
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

import 'dart:io';
import 'dart:math';

import 'packet.dart';
import 'protocol.dart';
import 'utils.dart';

/// Device based API that handles MIIO protocol easier.
class MiioDevice {
  final InternetAddress address;
  final int id;
  final List<int> token;

  MiioDevice({
    required this.address,
    required this.token,
    required this.id,
  });

  @override
  String toString() =>
      'MiioDevice(address: $address, id: ${id.toHexString(8)})';

  /// Get MIIO info.
  Future<Map<String, dynamic>?> get info async {
    final resp = await Miio.instance.send(
      address,
      await MiioPacket.build(
        id,
        token,
        payload: <String, dynamic>{
          'id': Random().nextInt(32768),
          'method': 'miIO.info',
          'params': <void>[],
        },
      ),
    );
    return resp.payload;
  }

  /// Get a property using legacy MIIO profile.
  Future<String?> getProp(String prop) async => (await getProps([prop]))?.first;

  /// Get a set of properties using legacy MIIO profile.
  Future<List<String>?> getProps(List<String> props) async {
    final resp = await Miio.instance.send(
      address,
      await MiioPacket.build(
        id,
        token,
        payload: <String, dynamic>{
          'id': Random().nextInt(32768),
          'method': 'get_prop',
          'params': props,
        },
      ),
    );

    return (resp.payload?['result'] as List<dynamic>).cast();
  }
}