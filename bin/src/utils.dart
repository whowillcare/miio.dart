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

import 'package:logger/logger.dart' as l;
import 'package:logging/logging.dart';

final _prettyPrinter = l.PrettyPrinter(methodCount: 0, printTime: true);
final _levelMap = <Level, l.Level>{
  Level.SHOUT: l.Level.fatal,
  Level.SEVERE: l.Level.error,
  Level.WARNING: l.Level.warning,
  Level.INFO: l.Level.info,
  Level.CONFIG: l.Level.info,
  Level.FINE: l.Level.debug,
  Level.FINER: l.Level.trace,
  Level.FINEST: l.Level.trace,
};

void prettyLogPrinter(LogRecord record) {
  print(
    _prettyPrinter
        .log(l.LogEvent(
          _levelMap[record.level]!,
          record.message,
          error: record.error,
          stackTrace: record.stackTrace,
        ))
        .join('\n'),
  );
}
