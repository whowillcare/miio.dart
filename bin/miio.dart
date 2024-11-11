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

import 'package:logging/logging.dart';
import 'package:miio_new/miio.dart';

import 'src/command_runner.dart';
import 'src/utils.dart';

void main(List<String> args) async {
  Logger.root.onRecord.listen(prettyLogPrinter);

  try {
    await MiIOCommandRunner().run(args);
  } on MiIOError catch (e) {
    Logger.root.severe(
      'Command failed with error from device:\n'
      'code: ${e.code}\n'
      'message: ${e.message}',
    );
  } on Exception catch (e) {
    Logger.root.severe('Command failed with exception:\n$e');
  }
}
