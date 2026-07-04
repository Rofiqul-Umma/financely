import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/account.dart';

extension AccountRowMapper on AccountRow {
  AccountEntity toEntity() => AccountEntity(
        id: id,
        name: name,
        colorValue: colorValue,
        iconId: iconId,
        openingBalance: openingBalance,
      );
}

extension AccountEntityMapper on AccountEntity {
  AccountRowsCompanion toCompanion() => AccountRowsCompanion(
        id: Value(id),
        name: Value(name),
        colorValue: Value(colorValue),
        iconId: Value(iconId),
        openingBalance: Value(openingBalance),
      );
}
