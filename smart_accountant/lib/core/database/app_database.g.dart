// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameArabic,
    nameEnglish,
    phone,
    address,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Company> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }
}

class Company extends DataClass implements Insertable<Company> {
  final int id;
  final String nameArabic;
  final String? nameEnglish;
  final String? phone;
  final String? address;
  final DateTime createdAt;
  const Company({
    required this.id,
    required this.nameArabic,
    this.nameEnglish,
    this.phone,
    this.address,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_arabic'] = Variable<String>(nameArabic);
    if (!nullToAbsent || nameEnglish != null) {
      map['name_english'] = Variable<String>(nameEnglish);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(
      id: Value(id),
      nameArabic: Value(nameArabic),
      nameEnglish: nameEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEnglish),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory Company.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<int>(json['id']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameEnglish: serializer.fromJson<String?>(json['nameEnglish']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameEnglish': serializer.toJson<String?>(nameEnglish),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Company copyWith({
    int? id,
    String? nameArabic,
    Value<String?> nameEnglish = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    DateTime? createdAt,
  }) => Company(
    id: id ?? this.id,
    nameArabic: nameArabic ?? this.nameArabic,
    nameEnglish: nameEnglish.present ? nameEnglish.value : this.nameEnglish,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    createdAt: createdAt ?? this.createdAt,
  );
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameArabic, nameEnglish, phone, address, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company &&
          other.id == this.id &&
          other.nameArabic == this.nameArabic &&
          other.nameEnglish == this.nameEnglish &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<int> id;
  final Value<String> nameArabic;
  final Value<String?> nameEnglish;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<DateTime> createdAt;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CompaniesCompanion.insert({
    this.id = const Value.absent(),
    required String nameArabic,
    this.nameEnglish = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nameArabic = Value(nameArabic);
  static Insertable<Company> custom({
    Expression<int>? id,
    Expression<String>? nameArabic,
    Expression<String>? nameEnglish,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CompaniesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameArabic,
    Value<String?>? nameEnglish,
    Value<String?>? phone,
    Value<String?>? address,
    Value<DateTime>? createdAt,
  }) {
    return CompaniesCompanion(
      id: id ?? this.id,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String key;
  final String? value;
  const Setting({required this.id, required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  Setting copyWith({
    int? id,
    String? key,
    Value<String?> value = const Value.absent(),
  }) => Setting(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String?> value;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.value = const Value.absent(),
  }) : key = Value(key);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String?>? value,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isBaseMeta = const VerificationMeta('isBase');
  @override
  late final GeneratedColumn<bool> isBase = GeneratedColumn<bool>(
    'is_base',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_base" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameArabic,
    nameEnglish,
    isBase,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Currency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    }
    if (data.containsKey('is_base')) {
      context.handle(
        _isBaseMeta,
        isBase.isAcceptableOrUnknown(data['is_base']!, _isBaseMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      ),
      isBase: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_base'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final int id;
  final String code;
  final String nameArabic;
  final String? nameEnglish;
  final bool isBase;
  final bool active;
  const Currency({
    required this.id,
    required this.code,
    required this.nameArabic,
    this.nameEnglish,
    required this.isBase,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_arabic'] = Variable<String>(nameArabic);
    if (!nullToAbsent || nameEnglish != null) {
      map['name_english'] = Variable<String>(nameEnglish);
    }
    map['is_base'] = Variable<bool>(isBase);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      code: Value(code),
      nameArabic: Value(nameArabic),
      nameEnglish: nameEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEnglish),
      isBase: Value(isBase),
      active: Value(active),
    );
  }

  factory Currency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameEnglish: serializer.fromJson<String?>(json['nameEnglish']),
      isBase: serializer.fromJson<bool>(json['isBase']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameEnglish': serializer.toJson<String?>(nameEnglish),
      'isBase': serializer.toJson<bool>(isBase),
      'active': serializer.toJson<bool>(active),
    };
  }

  Currency copyWith({
    int? id,
    String? code,
    String? nameArabic,
    Value<String?> nameEnglish = const Value.absent(),
    bool? isBase,
    bool? active,
  }) => Currency(
    id: id ?? this.id,
    code: code ?? this.code,
    nameArabic: nameArabic ?? this.nameArabic,
    nameEnglish: nameEnglish.present ? nameEnglish.value : this.nameEnglish,
    isBase: isBase ?? this.isBase,
    active: active ?? this.active,
  );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      isBase: data.isBase.present ? data.isBase.value : this.isBase,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('isBase: $isBase, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, nameArabic, nameEnglish, isBase, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameArabic == this.nameArabic &&
          other.nameEnglish == this.nameEnglish &&
          other.isBase == this.isBase &&
          other.active == this.active);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameArabic;
  final Value<String?> nameEnglish;
  final Value<bool> isBase;
  final Value<bool> active;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.isBase = const Value.absent(),
    this.active = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameArabic,
    this.nameEnglish = const Value.absent(),
    this.isBase = const Value.absent(),
    this.active = const Value.absent(),
  }) : code = Value(code),
       nameArabic = Value(nameArabic);
  static Insertable<Currency> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameArabic,
    Expression<String>? nameEnglish,
    Expression<bool>? isBase,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (isBase != null) 'is_base': isBase,
      if (active != null) 'active': active,
    });
  }

  CurrenciesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameArabic,
    Value<String?>? nameEnglish,
    Value<bool>? isBase,
    Value<bool>? active,
  }) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      isBase: isBase ?? this.isBase,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (isBase.present) {
      map['is_base'] = Variable<bool>(isBase.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('isBase: $isBase, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, currencyId, rate, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_id'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final int id;
  final int currencyId;
  final double rate;
  final DateTime date;
  const ExchangeRate({
    required this.id,
    required this.currencyId,
    required this.rate,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_id'] = Variable<int>(currencyId);
    map['rate'] = Variable<double>(rate);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      currencyId: Value(currencyId),
      rate: Value(rate),
      date: Value(date),
    );
  }

  factory ExchangeRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<int>(json['id']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      rate: serializer.fromJson<double>(json['rate']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyId': serializer.toJson<int>(currencyId),
      'rate': serializer.toJson<double>(rate),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  ExchangeRate copyWith({
    int? id,
    int? currencyId,
    double? rate,
    DateTime? date,
  }) => ExchangeRate(
    id: id ?? this.id,
    currencyId: currencyId ?? this.currencyId,
    rate: rate ?? this.rate,
    date: date ?? this.date,
  );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      currencyId: data.currencyId.present
          ? data.currencyId.value
          : this.currencyId,
      rate: data.rate.present ? data.rate.value : this.rate,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('currencyId: $currencyId, ')
          ..write('rate: $rate, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currencyId, rate, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.currencyId == this.currencyId &&
          other.rate == this.rate &&
          other.date == this.date);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<int> id;
  final Value<int> currencyId;
  final Value<double> rate;
  final Value<DateTime> date;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.rate = const Value.absent(),
    this.date = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    required int currencyId,
    required double rate,
    required DateTime date,
  }) : currencyId = Value(currencyId),
       rate = Value(rate),
       date = Value(date);
  static Insertable<ExchangeRate> custom({
    Expression<int>? id,
    Expression<int>? currencyId,
    Expression<double>? rate,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyId != null) 'currency_id': currencyId,
      if (rate != null) 'rate': rate,
      if (date != null) 'date': date,
    });
  }

  ExchangeRatesCompanion copyWith({
    Value<int>? id,
    Value<int>? currencyId,
    Value<double>? rate,
    Value<DateTime>? date,
  }) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      currencyId: currencyId ?? this.currencyId,
      rate: rate ?? this.rate,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('currencyId: $currencyId, ')
          ..write('rate: $rate, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _natureMeta = const VerificationMeta('nature');
  @override
  late final GeneratedColumn<String> nature = GeneratedColumn<String>(
    'nature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allowPostingMeta = const VerificationMeta(
    'allowPosting',
  );
  @override
  late final GeneratedColumn<bool> allowPosting = GeneratedColumn<bool>(
    'allow_posting',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_posting" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountNumber,
    nameArabic,
    nameEnglish,
    parentId,
    level,
    accountType,
    nature,
    allowPosting,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNumberMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('nature')) {
      context.handle(
        _natureMeta,
        nature.isAcceptableOrUnknown(data['nature']!, _natureMeta),
      );
    } else if (isInserting) {
      context.missing(_natureMeta);
    }
    if (data.containsKey('allow_posting')) {
      context.handle(
        _allowPostingMeta,
        allowPosting.isAcceptableOrUnknown(
          data['allow_posting']!,
          _allowPostingMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      nature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nature'],
      )!,
      allowPosting: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_posting'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String accountNumber;
  final String nameArabic;
  final String? nameEnglish;
  final int? parentId;
  final int level;
  final String accountType;
  final String nature;
  final bool allowPosting;
  final bool active;
  const Account({
    required this.id,
    required this.accountNumber,
    required this.nameArabic,
    this.nameEnglish,
    this.parentId,
    required this.level,
    required this.accountType,
    required this.nature,
    required this.allowPosting,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_number'] = Variable<String>(accountNumber);
    map['name_arabic'] = Variable<String>(nameArabic);
    if (!nullToAbsent || nameEnglish != null) {
      map['name_english'] = Variable<String>(nameEnglish);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['level'] = Variable<int>(level);
    map['account_type'] = Variable<String>(accountType);
    map['nature'] = Variable<String>(nature);
    map['allow_posting'] = Variable<bool>(allowPosting);
    map['active'] = Variable<bool>(active);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      accountNumber: Value(accountNumber),
      nameArabic: Value(nameArabic),
      nameEnglish: nameEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEnglish),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      level: Value(level),
      accountType: Value(accountType),
      nature: Value(nature),
      allowPosting: Value(allowPosting),
      active: Value(active),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameEnglish: serializer.fromJson<String?>(json['nameEnglish']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      level: serializer.fromJson<int>(json['level']),
      accountType: serializer.fromJson<String>(json['accountType']),
      nature: serializer.fromJson<String>(json['nature']),
      allowPosting: serializer.fromJson<bool>(json['allowPosting']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameEnglish': serializer.toJson<String?>(nameEnglish),
      'parentId': serializer.toJson<int?>(parentId),
      'level': serializer.toJson<int>(level),
      'accountType': serializer.toJson<String>(accountType),
      'nature': serializer.toJson<String>(nature),
      'allowPosting': serializer.toJson<bool>(allowPosting),
      'active': serializer.toJson<bool>(active),
    };
  }

  Account copyWith({
    int? id,
    String? accountNumber,
    String? nameArabic,
    Value<String?> nameEnglish = const Value.absent(),
    Value<int?> parentId = const Value.absent(),
    int? level,
    String? accountType,
    String? nature,
    bool? allowPosting,
    bool? active,
  }) => Account(
    id: id ?? this.id,
    accountNumber: accountNumber ?? this.accountNumber,
    nameArabic: nameArabic ?? this.nameArabic,
    nameEnglish: nameEnglish.present ? nameEnglish.value : this.nameEnglish,
    parentId: parentId.present ? parentId.value : this.parentId,
    level: level ?? this.level,
    accountType: accountType ?? this.accountType,
    nature: nature ?? this.nature,
    allowPosting: allowPosting ?? this.allowPosting,
    active: active ?? this.active,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      level: data.level.present ? data.level.value : this.level,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      nature: data.nature.present ? data.nature.value : this.nature,
      allowPosting: data.allowPosting.present
          ? data.allowPosting.value
          : this.allowPosting,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('accountType: $accountType, ')
          ..write('nature: $nature, ')
          ..write('allowPosting: $allowPosting, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountNumber,
    nameArabic,
    nameEnglish,
    parentId,
    level,
    accountType,
    nature,
    allowPosting,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.accountNumber == this.accountNumber &&
          other.nameArabic == this.nameArabic &&
          other.nameEnglish == this.nameEnglish &&
          other.parentId == this.parentId &&
          other.level == this.level &&
          other.accountType == this.accountType &&
          other.nature == this.nature &&
          other.allowPosting == this.allowPosting &&
          other.active == this.active);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> accountNumber;
  final Value<String> nameArabic;
  final Value<String?> nameEnglish;
  final Value<int?> parentId;
  final Value<int> level;
  final Value<String> accountType;
  final Value<String> nature;
  final Value<bool> allowPosting;
  final Value<bool> active;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.accountType = const Value.absent(),
    this.nature = const Value.absent(),
    this.allowPosting = const Value.absent(),
    this.active = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String accountNumber,
    required String nameArabic,
    this.nameEnglish = const Value.absent(),
    this.parentId = const Value.absent(),
    required int level,
    required String accountType,
    required String nature,
    this.allowPosting = const Value.absent(),
    this.active = const Value.absent(),
  }) : accountNumber = Value(accountNumber),
       nameArabic = Value(nameArabic),
       level = Value(level),
       accountType = Value(accountType),
       nature = Value(nature);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? accountNumber,
    Expression<String>? nameArabic,
    Expression<String>? nameEnglish,
    Expression<int>? parentId,
    Expression<int>? level,
    Expression<String>? accountType,
    Expression<String>? nature,
    Expression<bool>? allowPosting,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountNumber != null) 'account_number': accountNumber,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (parentId != null) 'parent_id': parentId,
      if (level != null) 'level': level,
      if (accountType != null) 'account_type': accountType,
      if (nature != null) 'nature': nature,
      if (allowPosting != null) 'allow_posting': allowPosting,
      if (active != null) 'active': active,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? accountNumber,
    Value<String>? nameArabic,
    Value<String?>? nameEnglish,
    Value<int?>? parentId,
    Value<int>? level,
    Value<String>? accountType,
    Value<String>? nature,
    Value<bool>? allowPosting,
    Value<bool>? active,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      accountType: accountType ?? this.accountType,
      nature: nature ?? this.nature,
      allowPosting: allowPosting ?? this.allowPosting,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (nature.present) {
      map['nature'] = Variable<String>(nature.value);
    }
    if (allowPosting.present) {
      map['allow_posting'] = Variable<bool>(allowPosting.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('accountType: $accountType, ')
          ..write('nature: $nature, ')
          ..write('allowPosting: $allowPosting, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $SystemAccountsTable extends SystemAccounts
    with TableInfo<$SystemAccountsTable, SystemAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, accountId, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SystemAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SystemAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $SystemAccountsTable createAlias(String alias) {
    return $SystemAccountsTable(attachedDatabase, alias);
  }
}

class SystemAccount extends DataClass implements Insertable<SystemAccount> {
  final int id;
  final String key;
  final int accountId;
  final String? description;
  const SystemAccount({
    required this.id,
    required this.key,
    required this.accountId,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  SystemAccountsCompanion toCompanion(bool nullToAbsent) {
    return SystemAccountsCompanion(
      id: Value(id),
      key: Value(key),
      accountId: Value(accountId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory SystemAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemAccount(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      accountId: serializer.fromJson<int>(json['accountId']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'accountId': serializer.toJson<int>(accountId),
      'description': serializer.toJson<String?>(description),
    };
  }

  SystemAccount copyWith({
    int? id,
    String? key,
    int? accountId,
    Value<String?> description = const Value.absent(),
  }) => SystemAccount(
    id: id ?? this.id,
    key: key ?? this.key,
    accountId: accountId ?? this.accountId,
    description: description.present ? description.value : this.description,
  );
  SystemAccount copyWithCompanion(SystemAccountsCompanion data) {
    return SystemAccount(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemAccount(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('accountId: $accountId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, accountId, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemAccount &&
          other.id == this.id &&
          other.key == this.key &&
          other.accountId == this.accountId &&
          other.description == this.description);
}

class SystemAccountsCompanion extends UpdateCompanion<SystemAccount> {
  final Value<int> id;
  final Value<String> key;
  final Value<int> accountId;
  final Value<String?> description;
  const SystemAccountsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.accountId = const Value.absent(),
    this.description = const Value.absent(),
  });
  SystemAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required int accountId,
    this.description = const Value.absent(),
  }) : key = Value(key),
       accountId = Value(accountId);
  static Insertable<SystemAccount> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<int>? accountId,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (accountId != null) 'account_id': accountId,
      if (description != null) 'description': description,
    });
  }

  SystemAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<int>? accountId,
    Value<String?>? description,
  }) {
    return SystemAccountsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      accountId: accountId ?? this.accountId,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemAccountsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('accountId: $accountId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $AccountRulesTable extends AccountRules
    with TableInfo<$AccountRulesTable, AccountRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentAccountIdMeta = const VerificationMeta(
    'parentAccountId',
  );
  @override
  late final GeneratedColumn<int> parentAccountId = GeneratedColumn<int>(
    'parent_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoCreateMeta = const VerificationMeta(
    'autoCreate',
  );
  @override
  late final GeneratedColumn<bool> autoCreate = GeneratedColumn<bool>(
    'auto_create',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_create" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _allowPostingMeta = const VerificationMeta(
    'allowPosting',
  );
  @override
  late final GeneratedColumn<bool> allowPosting = GeneratedColumn<bool>(
    'allow_posting',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_posting" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    parentAccountId,
    autoCreate,
    allowPosting,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('parent_account_id')) {
      context.handle(
        _parentAccountIdMeta,
        parentAccountId.isAcceptableOrUnknown(
          data['parent_account_id']!,
          _parentAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentAccountIdMeta);
    }
    if (data.containsKey('auto_create')) {
      context.handle(
        _autoCreateMeta,
        autoCreate.isAcceptableOrUnknown(data['auto_create']!, _autoCreateMeta),
      );
    }
    if (data.containsKey('allow_posting')) {
      context.handle(
        _allowPostingMeta,
        allowPosting.isAcceptableOrUnknown(
          data['allow_posting']!,
          _allowPostingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      parentAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_account_id'],
      )!,
      autoCreate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_create'],
      )!,
      allowPosting: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_posting'],
      )!,
    );
  }

  @override
  $AccountRulesTable createAlias(String alias) {
    return $AccountRulesTable(attachedDatabase, alias);
  }
}

class AccountRule extends DataClass implements Insertable<AccountRule> {
  final int id;
  final String entityType;
  final int parentAccountId;
  final bool autoCreate;
  final bool allowPosting;
  const AccountRule({
    required this.id,
    required this.entityType,
    required this.parentAccountId,
    required this.autoCreate,
    required this.allowPosting,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['parent_account_id'] = Variable<int>(parentAccountId);
    map['auto_create'] = Variable<bool>(autoCreate);
    map['allow_posting'] = Variable<bool>(allowPosting);
    return map;
  }

  AccountRulesCompanion toCompanion(bool nullToAbsent) {
    return AccountRulesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      parentAccountId: Value(parentAccountId),
      autoCreate: Value(autoCreate),
      allowPosting: Value(allowPosting),
    );
  }

  factory AccountRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRule(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      parentAccountId: serializer.fromJson<int>(json['parentAccountId']),
      autoCreate: serializer.fromJson<bool>(json['autoCreate']),
      allowPosting: serializer.fromJson<bool>(json['allowPosting']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'parentAccountId': serializer.toJson<int>(parentAccountId),
      'autoCreate': serializer.toJson<bool>(autoCreate),
      'allowPosting': serializer.toJson<bool>(allowPosting),
    };
  }

  AccountRule copyWith({
    int? id,
    String? entityType,
    int? parentAccountId,
    bool? autoCreate,
    bool? allowPosting,
  }) => AccountRule(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    parentAccountId: parentAccountId ?? this.parentAccountId,
    autoCreate: autoCreate ?? this.autoCreate,
    allowPosting: allowPosting ?? this.allowPosting,
  );
  AccountRule copyWithCompanion(AccountRulesCompanion data) {
    return AccountRule(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      parentAccountId: data.parentAccountId.present
          ? data.parentAccountId.value
          : this.parentAccountId,
      autoCreate: data.autoCreate.present
          ? data.autoCreate.value
          : this.autoCreate,
      allowPosting: data.allowPosting.present
          ? data.allowPosting.value
          : this.allowPosting,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRule(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('parentAccountId: $parentAccountId, ')
          ..write('autoCreate: $autoCreate, ')
          ..write('allowPosting: $allowPosting')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, parentAccountId, autoCreate, allowPosting);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRule &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.parentAccountId == this.parentAccountId &&
          other.autoCreate == this.autoCreate &&
          other.allowPosting == this.allowPosting);
}

class AccountRulesCompanion extends UpdateCompanion<AccountRule> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> parentAccountId;
  final Value<bool> autoCreate;
  final Value<bool> allowPosting;
  const AccountRulesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.parentAccountId = const Value.absent(),
    this.autoCreate = const Value.absent(),
    this.allowPosting = const Value.absent(),
  });
  AccountRulesCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int parentAccountId,
    this.autoCreate = const Value.absent(),
    this.allowPosting = const Value.absent(),
  }) : entityType = Value(entityType),
       parentAccountId = Value(parentAccountId);
  static Insertable<AccountRule> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? parentAccountId,
    Expression<bool>? autoCreate,
    Expression<bool>? allowPosting,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (parentAccountId != null) 'parent_account_id': parentAccountId,
      if (autoCreate != null) 'auto_create': autoCreate,
      if (allowPosting != null) 'allow_posting': allowPosting,
    });
  }

  AccountRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int>? parentAccountId,
    Value<bool>? autoCreate,
    Value<bool>? allowPosting,
  }) {
    return AccountRulesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      parentAccountId: parentAccountId ?? this.parentAccountId,
      autoCreate: autoCreate ?? this.autoCreate,
      allowPosting: allowPosting ?? this.allowPosting,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (parentAccountId.present) {
      map['parent_account_id'] = Variable<int>(parentAccountId.value);
    }
    if (autoCreate.present) {
      map['auto_create'] = Variable<bool>(autoCreate.value);
    }
    if (allowPosting.present) {
      map['allow_posting'] = Variable<bool>(allowPosting.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountRulesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('parentAccountId: $parentAccountId, ')
          ..write('autoCreate: $autoCreate, ')
          ..write('allowPosting: $allowPosting')
          ..write(')'))
        .toString();
  }
}

class $AccountLinksTable extends AccountLinks
    with TableInfo<$AccountLinksTable, AccountLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    module,
    entityType,
    entityId,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $AccountLinksTable createAlias(String alias) {
    return $AccountLinksTable(attachedDatabase, alias);
  }
}

class AccountLink extends DataClass implements Insertable<AccountLink> {
  final int id;
  final String module;
  final String entityType;
  final int entityId;
  final int accountId;
  const AccountLink({
    required this.id,
    required this.module,
    required this.entityType,
    required this.entityId,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['module'] = Variable<String>(module);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['account_id'] = Variable<int>(accountId);
    return map;
  }

  AccountLinksCompanion toCompanion(bool nullToAbsent) {
    return AccountLinksCompanion(
      id: Value(id),
      module: Value(module),
      entityType: Value(entityType),
      entityId: Value(entityId),
      accountId: Value(accountId),
    );
  }

  factory AccountLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountLink(
      id: serializer.fromJson<int>(json['id']),
      module: serializer.fromJson<String>(json['module']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      accountId: serializer.fromJson<int>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'module': serializer.toJson<String>(module),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'accountId': serializer.toJson<int>(accountId),
    };
  }

  AccountLink copyWith({
    int? id,
    String? module,
    String? entityType,
    int? entityId,
    int? accountId,
  }) => AccountLink(
    id: id ?? this.id,
    module: module ?? this.module,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    accountId: accountId ?? this.accountId,
  );
  AccountLink copyWithCompanion(AccountLinksCompanion data) {
    return AccountLink(
      id: data.id.present ? data.id.value : this.id,
      module: data.module.present ? data.module.value : this.module,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountLink(')
          ..write('id: $id, ')
          ..write('module: $module, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, module, entityType, entityId, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountLink &&
          other.id == this.id &&
          other.module == this.module &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.accountId == this.accountId);
}

class AccountLinksCompanion extends UpdateCompanion<AccountLink> {
  final Value<int> id;
  final Value<String> module;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<int> accountId;
  const AccountLinksCompanion({
    this.id = const Value.absent(),
    this.module = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.accountId = const Value.absent(),
  });
  AccountLinksCompanion.insert({
    this.id = const Value.absent(),
    required String module,
    required String entityType,
    required int entityId,
    required int accountId,
  }) : module = Value(module),
       entityType = Value(entityType),
       entityId = Value(entityId),
       accountId = Value(accountId);
  static Insertable<AccountLink> custom({
    Expression<int>? id,
    Expression<String>? module,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<int>? accountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (module != null) 'module': module,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (accountId != null) 'account_id': accountId,
    });
  }

  AccountLinksCompanion copyWith({
    Value<int>? id,
    Value<String>? module,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<int>? accountId,
  }) {
    return AccountLinksCompanion(
      id: id ?? this.id,
      module: module ?? this.module,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountLinksCompanion(')
          ..write('id: $id, ')
          ..write('module: $module, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeRateMeta = const VerificationMeta(
    'exchangeRate',
  );
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
    'exchange_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    description,
    date,
    currency,
    exchangeRate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
        _exchangeRateMeta,
        exchangeRate.isAcceptableOrUnknown(
          data['exchange_rate']!,
          _exchangeRateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      exchangeRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exchange_rate'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String reference;
  final String description;
  final DateTime date;
  final String currency;
  final double exchangeRate;
  final DateTime createdAt;
  const JournalEntry({
    required this.id,
    required this.reference,
    required this.description,
    required this.date,
    required this.currency,
    required this.exchangeRate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    map['currency'] = Variable<String>(currency);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      reference: Value(reference),
      description: Value(description),
      date: Value(date),
      currency: Value(currency),
      exchangeRate: Value(exchangeRate),
      createdAt: Value(createdAt),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JournalEntry copyWith({
    int? id,
    String? reference,
    String? description,
    DateTime? date,
    String? currency,
    double? exchangeRate,
    DateTime? createdAt,
  }) => JournalEntry(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    description: description ?? this.description,
    date: date ?? this.date,
    currency: currency ?? this.currency,
    exchangeRate: exchangeRate ?? this.exchangeRate,
    createdAt: createdAt ?? this.createdAt,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    description,
    date,
    currency,
    exchangeRate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.description == this.description &&
          other.date == this.date &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.createdAt == this.createdAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> reference;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<String> currency;
  final Value<double> exchangeRate;
  final Value<DateTime> createdAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required String description,
    required DateTime date,
    required String currency,
    this.exchangeRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : reference = Value(reference),
       description = Value(description),
       date = Value(date),
       currency = Value(currency);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<String>? description,
    Value<DateTime>? date,
    Value<String>? currency,
    Value<double>? exchangeRate,
    Value<DateTime>? createdAt,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      description: description ?? this.description,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $JournalLinesTable extends JournalLines
    with TableInfo<$JournalLinesTable, JournalLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _journalIdMeta = const VerificationMeta(
    'journalId',
  );
  @override
  late final GeneratedColumn<int> journalId = GeneratedColumn<int>(
    'journal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
    'debit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
    'credit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journalId,
    accountId,
    debit,
    credit,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('journal_id')) {
      context.handle(
        _journalIdMeta,
        journalId.isAcceptableOrUnknown(data['journal_id']!, _journalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      journalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit'],
      )!,
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $JournalLinesTable createAlias(String alias) {
    return $JournalLinesTable(attachedDatabase, alias);
  }
}

class JournalLine extends DataClass implements Insertable<JournalLine> {
  final int id;
  final int journalId;
  final int accountId;
  final double debit;
  final double credit;
  final String description;
  const JournalLine({
    required this.id,
    required this.journalId,
    required this.accountId,
    required this.debit,
    required this.credit,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['journal_id'] = Variable<int>(journalId);
    map['account_id'] = Variable<int>(accountId);
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    map['description'] = Variable<String>(description);
    return map;
  }

  JournalLinesCompanion toCompanion(bool nullToAbsent) {
    return JournalLinesCompanion(
      id: Value(id),
      journalId: Value(journalId),
      accountId: Value(accountId),
      debit: Value(debit),
      credit: Value(credit),
      description: Value(description),
    );
  }

  factory JournalLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalLine(
      id: serializer.fromJson<int>(json['id']),
      journalId: serializer.fromJson<int>(json['journalId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'journalId': serializer.toJson<int>(journalId),
      'accountId': serializer.toJson<int>(accountId),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'description': serializer.toJson<String>(description),
    };
  }

  JournalLine copyWith({
    int? id,
    int? journalId,
    int? accountId,
    double? debit,
    double? credit,
    String? description,
  }) => JournalLine(
    id: id ?? this.id,
    journalId: journalId ?? this.journalId,
    accountId: accountId ?? this.accountId,
    debit: debit ?? this.debit,
    credit: credit ?? this.credit,
    description: description ?? this.description,
  );
  JournalLine copyWithCompanion(JournalLinesCompanion data) {
    return JournalLine(
      id: data.id.present ? data.id.value : this.id,
      journalId: data.journalId.present ? data.journalId.value : this.journalId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalLine(')
          ..write('id: $id, ')
          ..write('journalId: $journalId, ')
          ..write('accountId: $accountId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, journalId, accountId, debit, credit, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalLine &&
          other.id == this.id &&
          other.journalId == this.journalId &&
          other.accountId == this.accountId &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.description == this.description);
}

class JournalLinesCompanion extends UpdateCompanion<JournalLine> {
  final Value<int> id;
  final Value<int> journalId;
  final Value<int> accountId;
  final Value<double> debit;
  final Value<double> credit;
  final Value<String> description;
  const JournalLinesCompanion({
    this.id = const Value.absent(),
    this.journalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
  });
  JournalLinesCompanion.insert({
    this.id = const Value.absent(),
    required int journalId,
    required int accountId,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    required String description,
  }) : journalId = Value(journalId),
       accountId = Value(accountId),
       description = Value(description);
  static Insertable<JournalLine> custom({
    Expression<int>? id,
    Expression<int>? journalId,
    Expression<int>? accountId,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journalId != null) 'journal_id': journalId,
      if (accountId != null) 'account_id': accountId,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (description != null) 'description': description,
    });
  }

  JournalLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? journalId,
    Value<int>? accountId,
    Value<double>? debit,
    Value<double>? credit,
    Value<String>? description,
  }) {
    return JournalLinesCompanion(
      id: id ?? this.id,
      journalId: journalId ?? this.journalId,
      accountId: accountId ?? this.accountId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (journalId.present) {
      map['journal_id'] = Variable<int>(journalId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalLinesCompanion(')
          ..write('id: $id, ')
          ..write('journalId: $journalId, ')
          ..write('accountId: $accountId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $LedgerTable extends Ledger with TableInfo<$LedgerTable, LedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _journalIdMeta = const VerificationMeta(
    'journalId',
  );
  @override
  late final GeneratedColumn<int> journalId = GeneratedColumn<int>(
    'journal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
    'debit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
    'credit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journalId,
    accountId,
    date,
    debit,
    credit,
    balance,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('journal_id')) {
      context.handle(
        _journalIdMeta,
        journalId.isAcceptableOrUnknown(data['journal_id']!, _journalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      journalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit'],
      )!,
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $LedgerTable createAlias(String alias) {
    return $LedgerTable(attachedDatabase, alias);
  }
}

class LedgerData extends DataClass implements Insertable<LedgerData> {
  final int id;
  final int journalId;
  final int accountId;
  final DateTime date;
  final double debit;
  final double credit;
  final double balance;
  final String description;
  const LedgerData({
    required this.id,
    required this.journalId,
    required this.accountId,
    required this.date,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['journal_id'] = Variable<int>(journalId);
    map['account_id'] = Variable<int>(accountId);
    map['date'] = Variable<DateTime>(date);
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    map['balance'] = Variable<double>(balance);
    map['description'] = Variable<String>(description);
    return map;
  }

  LedgerCompanion toCompanion(bool nullToAbsent) {
    return LedgerCompanion(
      id: Value(id),
      journalId: Value(journalId),
      accountId: Value(accountId),
      date: Value(date),
      debit: Value(debit),
      credit: Value(credit),
      balance: Value(balance),
      description: Value(description),
    );
  }

  factory LedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerData(
      id: serializer.fromJson<int>(json['id']),
      journalId: serializer.fromJson<int>(json['journalId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      date: serializer.fromJson<DateTime>(json['date']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      balance: serializer.fromJson<double>(json['balance']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'journalId': serializer.toJson<int>(journalId),
      'accountId': serializer.toJson<int>(accountId),
      'date': serializer.toJson<DateTime>(date),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'balance': serializer.toJson<double>(balance),
      'description': serializer.toJson<String>(description),
    };
  }

  LedgerData copyWith({
    int? id,
    int? journalId,
    int? accountId,
    DateTime? date,
    double? debit,
    double? credit,
    double? balance,
    String? description,
  }) => LedgerData(
    id: id ?? this.id,
    journalId: journalId ?? this.journalId,
    accountId: accountId ?? this.accountId,
    date: date ?? this.date,
    debit: debit ?? this.debit,
    credit: credit ?? this.credit,
    balance: balance ?? this.balance,
    description: description ?? this.description,
  );
  LedgerData copyWithCompanion(LedgerCompanion data) {
    return LedgerData(
      id: data.id.present ? data.id.value : this.id,
      journalId: data.journalId.present ? data.journalId.value : this.journalId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      date: data.date.present ? data.date.value : this.date,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      balance: data.balance.present ? data.balance.value : this.balance,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerData(')
          ..write('id: $id, ')
          ..write('journalId: $journalId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('balance: $balance, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journalId,
    accountId,
    date,
    debit,
    credit,
    balance,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerData &&
          other.id == this.id &&
          other.journalId == this.journalId &&
          other.accountId == this.accountId &&
          other.date == this.date &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.balance == this.balance &&
          other.description == this.description);
}

class LedgerCompanion extends UpdateCompanion<LedgerData> {
  final Value<int> id;
  final Value<int> journalId;
  final Value<int> accountId;
  final Value<DateTime> date;
  final Value<double> debit;
  final Value<double> credit;
  final Value<double> balance;
  final Value<String> description;
  const LedgerCompanion({
    this.id = const Value.absent(),
    this.journalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.date = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.balance = const Value.absent(),
    this.description = const Value.absent(),
  });
  LedgerCompanion.insert({
    this.id = const Value.absent(),
    required int journalId,
    required int accountId,
    required DateTime date,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.balance = const Value.absent(),
    required String description,
  }) : journalId = Value(journalId),
       accountId = Value(accountId),
       date = Value(date),
       description = Value(description);
  static Insertable<LedgerData> custom({
    Expression<int>? id,
    Expression<int>? journalId,
    Expression<int>? accountId,
    Expression<DateTime>? date,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<double>? balance,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journalId != null) 'journal_id': journalId,
      if (accountId != null) 'account_id': accountId,
      if (date != null) 'date': date,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (balance != null) 'balance': balance,
      if (description != null) 'description': description,
    });
  }

  LedgerCompanion copyWith({
    Value<int>? id,
    Value<int>? journalId,
    Value<int>? accountId,
    Value<DateTime>? date,
    Value<double>? debit,
    Value<double>? credit,
    Value<double>? balance,
    Value<String>? description,
  }) {
    return LedgerCompanion(
      id: id ?? this.id,
      journalId: journalId ?? this.journalId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      balance: balance ?? this.balance,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (journalId.present) {
      map['journal_id'] = Variable<int>(journalId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerCompanion(')
          ..write('id: $id, ')
          ..write('journalId: $journalId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('balance: $balance, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $BalancesTable extends Balances with TableInfo<$BalancesTable, Balance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitTotalMeta = const VerificationMeta(
    'debitTotal',
  );
  @override
  late final GeneratedColumn<double> debitTotal = GeneratedColumn<double>(
    'debit_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creditTotalMeta = const VerificationMeta(
    'creditTotal',
  );
  @override
  late final GeneratedColumn<double> creditTotal = GeneratedColumn<double>(
    'credit_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountId,
    currency,
    debitTotal,
    creditTotal,
    balance,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Balance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('debit_total')) {
      context.handle(
        _debitTotalMeta,
        debitTotal.isAcceptableOrUnknown(data['debit_total']!, _debitTotalMeta),
      );
    }
    if (data.containsKey('credit_total')) {
      context.handle(
        _creditTotalMeta,
        creditTotal.isAcceptableOrUnknown(
          data['credit_total']!,
          _creditTotalMeta,
        ),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId, currency};
  @override
  Balance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Balance(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      debitTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit_total'],
      )!,
      creditTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_total'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BalancesTable createAlias(String alias) {
    return $BalancesTable(attachedDatabase, alias);
  }
}

class Balance extends DataClass implements Insertable<Balance> {
  final int accountId;
  final String currency;
  final double debitTotal;
  final double creditTotal;
  final double balance;
  final DateTime updatedAt;
  const Balance({
    required this.accountId,
    required this.currency,
    required this.debitTotal,
    required this.creditTotal,
    required this.balance,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(accountId);
    map['currency'] = Variable<String>(currency);
    map['debit_total'] = Variable<double>(debitTotal);
    map['credit_total'] = Variable<double>(creditTotal);
    map['balance'] = Variable<double>(balance);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BalancesCompanion toCompanion(bool nullToAbsent) {
    return BalancesCompanion(
      accountId: Value(accountId),
      currency: Value(currency),
      debitTotal: Value(debitTotal),
      creditTotal: Value(creditTotal),
      balance: Value(balance),
      updatedAt: Value(updatedAt),
    );
  }

  factory Balance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Balance(
      accountId: serializer.fromJson<int>(json['accountId']),
      currency: serializer.fromJson<String>(json['currency']),
      debitTotal: serializer.fromJson<double>(json['debitTotal']),
      creditTotal: serializer.fromJson<double>(json['creditTotal']),
      balance: serializer.fromJson<double>(json['balance']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<int>(accountId),
      'currency': serializer.toJson<String>(currency),
      'debitTotal': serializer.toJson<double>(debitTotal),
      'creditTotal': serializer.toJson<double>(creditTotal),
      'balance': serializer.toJson<double>(balance),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Balance copyWith({
    int? accountId,
    String? currency,
    double? debitTotal,
    double? creditTotal,
    double? balance,
    DateTime? updatedAt,
  }) => Balance(
    accountId: accountId ?? this.accountId,
    currency: currency ?? this.currency,
    debitTotal: debitTotal ?? this.debitTotal,
    creditTotal: creditTotal ?? this.creditTotal,
    balance: balance ?? this.balance,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Balance copyWithCompanion(BalancesCompanion data) {
    return Balance(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      currency: data.currency.present ? data.currency.value : this.currency,
      debitTotal: data.debitTotal.present
          ? data.debitTotal.value
          : this.debitTotal,
      creditTotal: data.creditTotal.present
          ? data.creditTotal.value
          : this.creditTotal,
      balance: data.balance.present ? data.balance.value : this.balance,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Balance(')
          ..write('accountId: $accountId, ')
          ..write('currency: $currency, ')
          ..write('debitTotal: $debitTotal, ')
          ..write('creditTotal: $creditTotal, ')
          ..write('balance: $balance, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountId,
    currency,
    debitTotal,
    creditTotal,
    balance,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Balance &&
          other.accountId == this.accountId &&
          other.currency == this.currency &&
          other.debitTotal == this.debitTotal &&
          other.creditTotal == this.creditTotal &&
          other.balance == this.balance &&
          other.updatedAt == this.updatedAt);
}

class BalancesCompanion extends UpdateCompanion<Balance> {
  final Value<int> accountId;
  final Value<String> currency;
  final Value<double> debitTotal;
  final Value<double> creditTotal;
  final Value<double> balance;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BalancesCompanion({
    this.accountId = const Value.absent(),
    this.currency = const Value.absent(),
    this.debitTotal = const Value.absent(),
    this.creditTotal = const Value.absent(),
    this.balance = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BalancesCompanion.insert({
    required int accountId,
    required String currency,
    this.debitTotal = const Value.absent(),
    this.creditTotal = const Value.absent(),
    this.balance = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       currency = Value(currency);
  static Insertable<Balance> custom({
    Expression<int>? accountId,
    Expression<String>? currency,
    Expression<double>? debitTotal,
    Expression<double>? creditTotal,
    Expression<double>? balance,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (currency != null) 'currency': currency,
      if (debitTotal != null) 'debit_total': debitTotal,
      if (creditTotal != null) 'credit_total': creditTotal,
      if (balance != null) 'balance': balance,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BalancesCompanion copyWith({
    Value<int>? accountId,
    Value<String>? currency,
    Value<double>? debitTotal,
    Value<double>? creditTotal,
    Value<double>? balance,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BalancesCompanion(
      accountId: accountId ?? this.accountId,
      currency: currency ?? this.currency,
      debitTotal: debitTotal ?? this.debitTotal,
      creditTotal: creditTotal ?? this.creditTotal,
      balance: balance ?? this.balance,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (debitTotal.present) {
      map['debit_total'] = Variable<double>(debitTotal.value);
    }
    if (creditTotal.present) {
      map['credit_total'] = Variable<double>(creditTotal.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalancesCompanion(')
          ..write('accountId: $accountId, ')
          ..write('currency: $currency, ')
          ..write('debitTotal: $debitTotal, ')
          ..write('creditTotal: $creditTotal, ')
          ..write('balance: $balance, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialAccountsTable extends FinancialAccounts
    with TableInfo<$FinancialAccountsTable, FinancialAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalNumberMeta = const VerificationMeta(
    'externalNumber',
  );
  @override
  late final GeneratedColumn<String> externalNumber = GeneratedColumn<String>(
    'external_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    code,
    nameArabic,
    nameEnglish,
    accountId,
    currencyId,
    externalNumber,
    providerName,
    active,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('external_number')) {
      context.handle(
        _externalNumberMeta,
        externalNumber.isAcceptableOrUnknown(
          data['external_number']!,
          _externalNumberMeta,
        ),
      );
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      currencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_id'],
      )!,
      externalNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_number'],
      ),
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $FinancialAccountsTable createAlias(String alias) {
    return $FinancialAccountsTable(attachedDatabase, alias);
  }
}

class FinancialAccount extends DataClass
    implements Insertable<FinancialAccount> {
  final int id;
  final String type;
  final String code;
  final String nameArabic;
  final String? nameEnglish;
  final int accountId;
  final int currencyId;
  final String? externalNumber;
  final String? providerName;
  final bool active;
  final String? notes;
  const FinancialAccount({
    required this.id,
    required this.type,
    required this.code,
    required this.nameArabic,
    this.nameEnglish,
    required this.accountId,
    required this.currencyId,
    this.externalNumber,
    this.providerName,
    required this.active,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['code'] = Variable<String>(code);
    map['name_arabic'] = Variable<String>(nameArabic);
    if (!nullToAbsent || nameEnglish != null) {
      map['name_english'] = Variable<String>(nameEnglish);
    }
    map['account_id'] = Variable<int>(accountId);
    map['currency_id'] = Variable<int>(currencyId);
    if (!nullToAbsent || externalNumber != null) {
      map['external_number'] = Variable<String>(externalNumber);
    }
    if (!nullToAbsent || providerName != null) {
      map['provider_name'] = Variable<String>(providerName);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FinancialAccountsCompanion toCompanion(bool nullToAbsent) {
    return FinancialAccountsCompanion(
      id: Value(id),
      type: Value(type),
      code: Value(code),
      nameArabic: Value(nameArabic),
      nameEnglish: nameEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEnglish),
      accountId: Value(accountId),
      currencyId: Value(currencyId),
      externalNumber: externalNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(externalNumber),
      providerName: providerName == null && nullToAbsent
          ? const Value.absent()
          : Value(providerName),
      active: Value(active),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory FinancialAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialAccount(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      code: serializer.fromJson<String>(json['code']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameEnglish: serializer.fromJson<String?>(json['nameEnglish']),
      accountId: serializer.fromJson<int>(json['accountId']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      externalNumber: serializer.fromJson<String?>(json['externalNumber']),
      providerName: serializer.fromJson<String?>(json['providerName']),
      active: serializer.fromJson<bool>(json['active']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'code': serializer.toJson<String>(code),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameEnglish': serializer.toJson<String?>(nameEnglish),
      'accountId': serializer.toJson<int>(accountId),
      'currencyId': serializer.toJson<int>(currencyId),
      'externalNumber': serializer.toJson<String?>(externalNumber),
      'providerName': serializer.toJson<String?>(providerName),
      'active': serializer.toJson<bool>(active),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FinancialAccount copyWith({
    int? id,
    String? type,
    String? code,
    String? nameArabic,
    Value<String?> nameEnglish = const Value.absent(),
    int? accountId,
    int? currencyId,
    Value<String?> externalNumber = const Value.absent(),
    Value<String?> providerName = const Value.absent(),
    bool? active,
    Value<String?> notes = const Value.absent(),
  }) => FinancialAccount(
    id: id ?? this.id,
    type: type ?? this.type,
    code: code ?? this.code,
    nameArabic: nameArabic ?? this.nameArabic,
    nameEnglish: nameEnglish.present ? nameEnglish.value : this.nameEnglish,
    accountId: accountId ?? this.accountId,
    currencyId: currencyId ?? this.currencyId,
    externalNumber: externalNumber.present
        ? externalNumber.value
        : this.externalNumber,
    providerName: providerName.present ? providerName.value : this.providerName,
    active: active ?? this.active,
    notes: notes.present ? notes.value : this.notes,
  );
  FinancialAccount copyWithCompanion(FinancialAccountsCompanion data) {
    return FinancialAccount(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      code: data.code.present ? data.code.value : this.code,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      currencyId: data.currencyId.present
          ? data.currencyId.value
          : this.currencyId,
      externalNumber: data.externalNumber.present
          ? data.externalNumber.value
          : this.externalNumber,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      active: data.active.present ? data.active.value : this.active,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialAccount(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('accountId: $accountId, ')
          ..write('currencyId: $currencyId, ')
          ..write('externalNumber: $externalNumber, ')
          ..write('providerName: $providerName, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    code,
    nameArabic,
    nameEnglish,
    accountId,
    currencyId,
    externalNumber,
    providerName,
    active,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialAccount &&
          other.id == this.id &&
          other.type == this.type &&
          other.code == this.code &&
          other.nameArabic == this.nameArabic &&
          other.nameEnglish == this.nameEnglish &&
          other.accountId == this.accountId &&
          other.currencyId == this.currencyId &&
          other.externalNumber == this.externalNumber &&
          other.providerName == this.providerName &&
          other.active == this.active &&
          other.notes == this.notes);
}

class FinancialAccountsCompanion extends UpdateCompanion<FinancialAccount> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> code;
  final Value<String> nameArabic;
  final Value<String?> nameEnglish;
  final Value<int> accountId;
  final Value<int> currencyId;
  final Value<String?> externalNumber;
  final Value<String?> providerName;
  final Value<bool> active;
  final Value<String?> notes;
  const FinancialAccountsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.code = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.accountId = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.externalNumber = const Value.absent(),
    this.providerName = const Value.absent(),
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FinancialAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String code,
    required String nameArabic,
    this.nameEnglish = const Value.absent(),
    required int accountId,
    required int currencyId,
    this.externalNumber = const Value.absent(),
    this.providerName = const Value.absent(),
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  }) : type = Value(type),
       code = Value(code),
       nameArabic = Value(nameArabic),
       accountId = Value(accountId),
       currencyId = Value(currencyId);
  static Insertable<FinancialAccount> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? code,
    Expression<String>? nameArabic,
    Expression<String>? nameEnglish,
    Expression<int>? accountId,
    Expression<int>? currencyId,
    Expression<String>? externalNumber,
    Expression<String>? providerName,
    Expression<bool>? active,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (code != null) 'code': code,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (accountId != null) 'account_id': accountId,
      if (currencyId != null) 'currency_id': currencyId,
      if (externalNumber != null) 'external_number': externalNumber,
      if (providerName != null) 'provider_name': providerName,
      if (active != null) 'active': active,
      if (notes != null) 'notes': notes,
    });
  }

  FinancialAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? code,
    Value<String>? nameArabic,
    Value<String?>? nameEnglish,
    Value<int>? accountId,
    Value<int>? currencyId,
    Value<String?>? externalNumber,
    Value<String?>? providerName,
    Value<bool>? active,
    Value<String?>? notes,
  }) {
    return FinancialAccountsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      accountId: accountId ?? this.accountId,
      currencyId: currencyId ?? this.currencyId,
      externalNumber: externalNumber ?? this.externalNumber,
      providerName: providerName ?? this.providerName,
      active: active ?? this.active,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (externalNumber.present) {
      map['external_number'] = Variable<String>(externalNumber.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialAccountsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('accountId: $accountId, ')
          ..write('currencyId: $currencyId, ')
          ..write('externalNumber: $externalNumber, ')
          ..write('providerName: $providerName, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $CashBoxesTable extends CashBoxes
    with TableInfo<$CashBoxesTable, CashBoxe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashBoxesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameArabic,
    currencyId,
    accountId,
    active,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_boxes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashBoxe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashBoxe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashBoxe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      currencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CashBoxesTable createAlias(String alias) {
    return $CashBoxesTable(attachedDatabase, alias);
  }
}

class CashBoxe extends DataClass implements Insertable<CashBoxe> {
  final int id;
  final String code;
  final String nameArabic;
  final int currencyId;
  final int accountId;
  final bool active;
  final String? notes;
  const CashBoxe({
    required this.id,
    required this.code,
    required this.nameArabic,
    required this.currencyId,
    required this.accountId,
    required this.active,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['currency_id'] = Variable<int>(currencyId);
    map['account_id'] = Variable<int>(accountId);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CashBoxesCompanion toCompanion(bool nullToAbsent) {
    return CashBoxesCompanion(
      id: Value(id),
      code: Value(code),
      nameArabic: Value(nameArabic),
      currencyId: Value(currencyId),
      accountId: Value(accountId),
      active: Value(active),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory CashBoxe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashBoxe(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      active: serializer.fromJson<bool>(json['active']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'currencyId': serializer.toJson<int>(currencyId),
      'accountId': serializer.toJson<int>(accountId),
      'active': serializer.toJson<bool>(active),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CashBoxe copyWith({
    int? id,
    String? code,
    String? nameArabic,
    int? currencyId,
    int? accountId,
    bool? active,
    Value<String?> notes = const Value.absent(),
  }) => CashBoxe(
    id: id ?? this.id,
    code: code ?? this.code,
    nameArabic: nameArabic ?? this.nameArabic,
    currencyId: currencyId ?? this.currencyId,
    accountId: accountId ?? this.accountId,
    active: active ?? this.active,
    notes: notes.present ? notes.value : this.notes,
  );
  CashBoxe copyWithCompanion(CashBoxesCompanion data) {
    return CashBoxe(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      currencyId: data.currencyId.present
          ? data.currencyId.value
          : this.currencyId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      active: data.active.present ? data.active.value : this.active,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashBoxe(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, nameArabic, currencyId, accountId, active, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashBoxe &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameArabic == this.nameArabic &&
          other.currencyId == this.currencyId &&
          other.accountId == this.accountId &&
          other.active == this.active &&
          other.notes == this.notes);
}

class CashBoxesCompanion extends UpdateCompanion<CashBoxe> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameArabic;
  final Value<int> currencyId;
  final Value<int> accountId;
  final Value<bool> active;
  final Value<String?> notes;
  const CashBoxesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  });
  CashBoxesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameArabic,
    required int currencyId,
    required int accountId,
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  }) : code = Value(code),
       nameArabic = Value(nameArabic),
       currencyId = Value(currencyId),
       accountId = Value(accountId);
  static Insertable<CashBoxe> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameArabic,
    Expression<int>? currencyId,
    Expression<int>? accountId,
    Expression<bool>? active,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (currencyId != null) 'currency_id': currencyId,
      if (accountId != null) 'account_id': accountId,
      if (active != null) 'active': active,
      if (notes != null) 'notes': notes,
    });
  }

  CashBoxesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameArabic,
    Value<int>? currencyId,
    Value<int>? accountId,
    Value<bool>? active,
    Value<String?>? notes,
  }) {
    return CashBoxesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameArabic: nameArabic ?? this.nameArabic,
      currencyId: currencyId ?? this.currencyId,
      accountId: accountId ?? this.accountId,
      active: active ?? this.active,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashBoxesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BanksTable extends Banks with TableInfo<$BanksTable, Bank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameArabic,
    currencyId,
    accountId,
    active,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bank> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bank(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      currencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $BanksTable createAlias(String alias) {
    return $BanksTable(attachedDatabase, alias);
  }
}

class Bank extends DataClass implements Insertable<Bank> {
  final int id;
  final String code;
  final String nameArabic;
  final int currencyId;
  final int accountId;
  final bool active;
  final String? notes;
  const Bank({
    required this.id,
    required this.code,
    required this.nameArabic,
    required this.currencyId,
    required this.accountId,
    required this.active,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['currency_id'] = Variable<int>(currencyId);
    map['account_id'] = Variable<int>(accountId);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BanksCompanion toCompanion(bool nullToAbsent) {
    return BanksCompanion(
      id: Value(id),
      code: Value(code),
      nameArabic: Value(nameArabic),
      currencyId: Value(currencyId),
      accountId: Value(accountId),
      active: Value(active),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Bank.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bank(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      active: serializer.fromJson<bool>(json['active']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'currencyId': serializer.toJson<int>(currencyId),
      'accountId': serializer.toJson<int>(accountId),
      'active': serializer.toJson<bool>(active),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Bank copyWith({
    int? id,
    String? code,
    String? nameArabic,
    int? currencyId,
    int? accountId,
    bool? active,
    Value<String?> notes = const Value.absent(),
  }) => Bank(
    id: id ?? this.id,
    code: code ?? this.code,
    nameArabic: nameArabic ?? this.nameArabic,
    currencyId: currencyId ?? this.currencyId,
    accountId: accountId ?? this.accountId,
    active: active ?? this.active,
    notes: notes.present ? notes.value : this.notes,
  );
  Bank copyWithCompanion(BanksCompanion data) {
    return Bank(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      currencyId: data.currencyId.present
          ? data.currencyId.value
          : this.currencyId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      active: data.active.present ? data.active.value : this.active,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bank(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, nameArabic, currencyId, accountId, active, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bank &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameArabic == this.nameArabic &&
          other.currencyId == this.currencyId &&
          other.accountId == this.accountId &&
          other.active == this.active &&
          other.notes == this.notes);
}

class BanksCompanion extends UpdateCompanion<Bank> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameArabic;
  final Value<int> currencyId;
  final Value<int> accountId;
  final Value<bool> active;
  final Value<String?> notes;
  const BanksCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  });
  BanksCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameArabic,
    required int currencyId,
    required int accountId,
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  }) : code = Value(code),
       nameArabic = Value(nameArabic),
       currencyId = Value(currencyId),
       accountId = Value(accountId);
  static Insertable<Bank> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameArabic,
    Expression<int>? currencyId,
    Expression<int>? accountId,
    Expression<bool>? active,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (currencyId != null) 'currency_id': currencyId,
      if (accountId != null) 'account_id': accountId,
      if (active != null) 'active': active,
      if (notes != null) 'notes': notes,
    });
  }

  BanksCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameArabic,
    Value<int>? currencyId,
    Value<int>? accountId,
    Value<bool>? active,
    Value<String?>? notes,
  }) {
    return BanksCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameArabic: nameArabic ?? this.nameArabic,
      currencyId: currencyId ?? this.currencyId,
      accountId: accountId ?? this.accountId,
      active: active ?? this.active,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BanksCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameArabic,
    provider,
    currencyId,
    accountId,
    active,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Wallet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      currencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int id;
  final String code;
  final String nameArabic;
  final String provider;
  final int currencyId;
  final int accountId;
  final bool active;
  final String? notes;
  const Wallet({
    required this.id,
    required this.code,
    required this.nameArabic,
    required this.provider,
    required this.currencyId,
    required this.accountId,
    required this.active,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['provider'] = Variable<String>(provider);
    map['currency_id'] = Variable<int>(currencyId);
    map['account_id'] = Variable<int>(accountId);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      code: Value(code),
      nameArabic: Value(nameArabic),
      provider: Value(provider),
      currencyId: Value(currencyId),
      accountId: Value(accountId),
      active: Value(active),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Wallet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      provider: serializer.fromJson<String>(json['provider']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      active: serializer.fromJson<bool>(json['active']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'provider': serializer.toJson<String>(provider),
      'currencyId': serializer.toJson<int>(currencyId),
      'accountId': serializer.toJson<int>(accountId),
      'active': serializer.toJson<bool>(active),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Wallet copyWith({
    int? id,
    String? code,
    String? nameArabic,
    String? provider,
    int? currencyId,
    int? accountId,
    bool? active,
    Value<String?> notes = const Value.absent(),
  }) => Wallet(
    id: id ?? this.id,
    code: code ?? this.code,
    nameArabic: nameArabic ?? this.nameArabic,
    provider: provider ?? this.provider,
    currencyId: currencyId ?? this.currencyId,
    accountId: accountId ?? this.accountId,
    active: active ?? this.active,
    notes: notes.present ? notes.value : this.notes,
  );
  Wallet copyWithCompanion(WalletsCompanion data) {
    return Wallet(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      provider: data.provider.present ? data.provider.value : this.provider,
      currencyId: data.currencyId.present
          ? data.currencyId.value
          : this.currencyId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      active: data.active.present ? data.active.value : this.active,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Wallet(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('provider: $provider, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    nameArabic,
    provider,
    currencyId,
    accountId,
    active,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameArabic == this.nameArabic &&
          other.provider == this.provider &&
          other.currencyId == this.currencyId &&
          other.accountId == this.accountId &&
          other.active == this.active &&
          other.notes == this.notes);
}

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameArabic;
  final Value<String> provider;
  final Value<int> currencyId;
  final Value<int> accountId;
  final Value<bool> active;
  final Value<String?> notes;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.provider = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameArabic,
    required String provider,
    required int currencyId,
    required int accountId,
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  }) : code = Value(code),
       nameArabic = Value(nameArabic),
       provider = Value(provider),
       currencyId = Value(currencyId),
       accountId = Value(accountId);
  static Insertable<Wallet> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameArabic,
    Expression<String>? provider,
    Expression<int>? currencyId,
    Expression<int>? accountId,
    Expression<bool>? active,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (provider != null) 'provider': provider,
      if (currencyId != null) 'currency_id': currencyId,
      if (accountId != null) 'account_id': accountId,
      if (active != null) 'active': active,
      if (notes != null) 'notes': notes,
    });
  }

  WalletsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameArabic,
    Value<String>? provider,
    Value<int>? currencyId,
    Value<int>? accountId,
    Value<bool>? active,
    Value<String?>? notes,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameArabic: nameArabic ?? this.nameArabic,
      provider: provider ?? this.provider,
      currencyId: currencyId ?? this.currencyId,
      accountId: accountId ?? this.accountId,
      active: active ?? this.active,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('provider: $provider, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ExchangeCompaniesTable extends ExchangeCompanies
    with TableInfo<$ExchangeCompaniesTable, ExchangeCompany> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeCompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameArabic,
    currencyId,
    accountId,
    active,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeCompany> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeCompany map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeCompany(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      currencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ExchangeCompaniesTable createAlias(String alias) {
    return $ExchangeCompaniesTable(attachedDatabase, alias);
  }
}

class ExchangeCompany extends DataClass implements Insertable<ExchangeCompany> {
  final int id;
  final String code;
  final String nameArabic;
  final int currencyId;
  final int accountId;
  final bool active;
  final String? notes;
  const ExchangeCompany({
    required this.id,
    required this.code,
    required this.nameArabic,
    required this.currencyId,
    required this.accountId,
    required this.active,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['currency_id'] = Variable<int>(currencyId);
    map['account_id'] = Variable<int>(accountId);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExchangeCompaniesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeCompaniesCompanion(
      id: Value(id),
      code: Value(code),
      nameArabic: Value(nameArabic),
      currencyId: Value(currencyId),
      accountId: Value(accountId),
      active: Value(active),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ExchangeCompany.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeCompany(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      active: serializer.fromJson<bool>(json['active']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'currencyId': serializer.toJson<int>(currencyId),
      'accountId': serializer.toJson<int>(accountId),
      'active': serializer.toJson<bool>(active),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ExchangeCompany copyWith({
    int? id,
    String? code,
    String? nameArabic,
    int? currencyId,
    int? accountId,
    bool? active,
    Value<String?> notes = const Value.absent(),
  }) => ExchangeCompany(
    id: id ?? this.id,
    code: code ?? this.code,
    nameArabic: nameArabic ?? this.nameArabic,
    currencyId: currencyId ?? this.currencyId,
    accountId: accountId ?? this.accountId,
    active: active ?? this.active,
    notes: notes.present ? notes.value : this.notes,
  );
  ExchangeCompany copyWithCompanion(ExchangeCompaniesCompanion data) {
    return ExchangeCompany(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      currencyId: data.currencyId.present
          ? data.currencyId.value
          : this.currencyId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      active: data.active.present ? data.active.value : this.active,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeCompany(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, nameArabic, currencyId, accountId, active, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeCompany &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameArabic == this.nameArabic &&
          other.currencyId == this.currencyId &&
          other.accountId == this.accountId &&
          other.active == this.active &&
          other.notes == this.notes);
}

class ExchangeCompaniesCompanion extends UpdateCompanion<ExchangeCompany> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameArabic;
  final Value<int> currencyId;
  final Value<int> accountId;
  final Value<bool> active;
  final Value<String?> notes;
  const ExchangeCompaniesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExchangeCompaniesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameArabic,
    required int currencyId,
    required int accountId,
    this.active = const Value.absent(),
    this.notes = const Value.absent(),
  }) : code = Value(code),
       nameArabic = Value(nameArabic),
       currencyId = Value(currencyId),
       accountId = Value(accountId);
  static Insertable<ExchangeCompany> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameArabic,
    Expression<int>? currencyId,
    Expression<int>? accountId,
    Expression<bool>? active,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (currencyId != null) 'currency_id': currencyId,
      if (accountId != null) 'account_id': accountId,
      if (active != null) 'active': active,
      if (notes != null) 'notes': notes,
    });
  }

  ExchangeCompaniesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameArabic,
    Value<int>? currencyId,
    Value<int>? accountId,
    Value<bool>? active,
    Value<String?>? notes,
  }) {
    return ExchangeCompaniesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameArabic: nameArabic ?? this.nameArabic,
      currencyId: currencyId ?? this.currencyId,
      accountId: accountId ?? this.accountId,
      active: active ?? this.active,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeCompaniesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('currencyId: $currencyId, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    phone,
    address,
    accountId,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String code;
  final String name;
  final String? phone;
  final String? address;
  final int accountId;
  final bool active;
  const Customer({
    required this.id,
    required this.code,
    required this.name,
    this.phone,
    this.address,
    required this.accountId,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['account_id'] = Variable<int>(accountId);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      accountId: Value(accountId),
      active: Value(active),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      accountId: serializer.fromJson<int>(json['accountId']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'accountId': serializer.toJson<int>(accountId),
      'active': serializer.toJson<bool>(active),
    };
  }

  Customer copyWith({
    int? id,
    String? code,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    int? accountId,
    bool? active,
  }) => Customer(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    accountId: accountId ?? this.accountId,
    active: active ?? this.active,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, phone, address, accountId, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.accountId == this.accountId &&
          other.active == this.active);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<int> accountId;
  final Value<bool> active;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.accountId = const Value.absent(),
    this.active = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    required int accountId,
    this.active = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       accountId = Value(accountId);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? accountId,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (accountId != null) 'account_id': accountId,
      if (active != null) 'active': active,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? address,
    Value<int>? accountId,
    Value<bool>? active,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      accountId: accountId ?? this.accountId,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    phone,
    address,
    accountId,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String code;
  final String name;
  final String? phone;
  final String? address;
  final int accountId;
  final bool active;
  const Supplier({
    required this.id,
    required this.code,
    required this.name,
    this.phone,
    this.address,
    required this.accountId,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['account_id'] = Variable<int>(accountId);
    map['active'] = Variable<bool>(active);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      accountId: Value(accountId),
      active: Value(active),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      accountId: serializer.fromJson<int>(json['accountId']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'accountId': serializer.toJson<int>(accountId),
      'active': serializer.toJson<bool>(active),
    };
  }

  Supplier copyWith({
    int? id,
    String? code,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    int? accountId,
    bool? active,
  }) => Supplier(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    accountId: accountId ?? this.accountId,
    active: active ?? this.active,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, phone, address, accountId, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.accountId == this.accountId &&
          other.active == this.active);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<int> accountId;
  final Value<bool> active;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.accountId = const Value.absent(),
    this.active = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    required int accountId,
    this.active = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       accountId = Value(accountId);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? accountId,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (accountId != null) 'account_id': accountId,
      if (active != null) 'active': active,
    });
  }

  SuppliersCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? address,
    Value<int>? accountId,
    Value<bool>? active,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      accountId: accountId ?? this.accountId,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('accountId: $accountId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final bool active;
  const Category({required this.id, required this.name, required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      active: Value(active),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'active': serializer.toJson<bool>(active),
    };
  }

  Category copyWith({int? id, String? name, bool? active}) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    active: active ?? this.active,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.active == this.active);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> active;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.active = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.active = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (active != null) 'active': active,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? active,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, symbol, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String name;
  final String symbol;
  final bool active;
  const Unit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    map['active'] = Variable<bool>(active);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      name: Value(name),
      symbol: Value(symbol),
      active: Value(active),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'active': serializer.toJson<bool>(active),
    };
  }

  Unit copyWith({int? id, String? name, String? symbol, bool? active}) => Unit(
    id: id ?? this.id,
    name: name ?? this.name,
    symbol: symbol ?? this.symbol,
    active: active ?? this.active,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, symbol, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.active == this.active);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> symbol;
  final Value<bool> active;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.active = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String symbol,
    this.active = const Value.absent(),
  }) : name = Value(name),
       symbol = Value(symbol);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (active != null) 'active': active,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? symbol,
    Value<bool>? active,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $WarehousesTable extends Warehouses
    with TableInfo<$WarehousesTable, Warehouse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WarehousesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, name, location, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'warehouses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Warehouse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Warehouse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Warehouse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $WarehousesTable createAlias(String alias) {
    return $WarehousesTable(attachedDatabase, alias);
  }
}

class Warehouse extends DataClass implements Insertable<Warehouse> {
  final int id;
  final String code;
  final String name;
  final String? location;
  final bool active;
  const Warehouse({
    required this.id,
    required this.code,
    required this.name,
    this.location,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  WarehousesCompanion toCompanion(bool nullToAbsent) {
    return WarehousesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      active: Value(active),
    );
  }

  factory Warehouse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Warehouse(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'active': serializer.toJson<bool>(active),
    };
  }

  Warehouse copyWith({
    int? id,
    String? code,
    String? name,
    Value<String?> location = const Value.absent(),
    bool? active,
  }) => Warehouse(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    active: active ?? this.active,
  );
  Warehouse copyWithCompanion(WarehousesCompanion data) {
    return Warehouse(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Warehouse(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, location, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Warehouse &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.location == this.location &&
          other.active == this.active);
}

class WarehousesCompanion extends UpdateCompanion<Warehouse> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> location;
  final Value<bool> active;
  const WarehousesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.active = const Value.absent(),
  });
  WarehousesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.location = const Value.absent(),
    this.active = const Value.absent(),
  }) : code = Value(code),
       name = Value(name);
  static Insertable<Warehouse> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? location,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (active != null) 'active': active,
    });
  }

  WarehousesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? location,
    Value<bool>? active,
  }) {
    return WarehousesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      location: location ?? this.location,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WarehousesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    categoryId,
    unitId,
    barcode,
    cost,
    salePrice,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String code;
  final String name;
  final int categoryId;
  final int unitId;
  final String? barcode;
  final double cost;
  final double salePrice;
  final bool active;
  const Item({
    required this.id,
    required this.code,
    required this.name,
    required this.categoryId,
    required this.unitId,
    this.barcode,
    required this.cost,
    required this.salePrice,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<int>(categoryId);
    map['unit_id'] = Variable<int>(unitId);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['cost'] = Variable<double>(cost);
    map['sale_price'] = Variable<double>(salePrice);
    map['active'] = Variable<bool>(active);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      categoryId: Value(categoryId),
      unitId: Value(unitId),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      cost: Value(cost),
      salePrice: Value(salePrice),
      active: Value(active),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      unitId: serializer.fromJson<int>(json['unitId']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      cost: serializer.fromJson<double>(json['cost']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
      'unitId': serializer.toJson<int>(unitId),
      'barcode': serializer.toJson<String?>(barcode),
      'cost': serializer.toJson<double>(cost),
      'salePrice': serializer.toJson<double>(salePrice),
      'active': serializer.toJson<bool>(active),
    };
  }

  Item copyWith({
    int? id,
    String? code,
    String? name,
    int? categoryId,
    int? unitId,
    Value<String?> barcode = const Value.absent(),
    double? cost,
    double? salePrice,
    bool? active,
  }) => Item(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    unitId: unitId ?? this.unitId,
    barcode: barcode.present ? barcode.value : this.barcode,
    cost: cost ?? this.cost,
    salePrice: salePrice ?? this.salePrice,
    active: active ?? this.active,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      cost: data.cost.present ? data.cost.value : this.cost,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitId: $unitId, ')
          ..write('barcode: $barcode, ')
          ..write('cost: $cost, ')
          ..write('salePrice: $salePrice, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    categoryId,
    unitId,
    barcode,
    cost,
    salePrice,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.unitId == this.unitId &&
          other.barcode == this.barcode &&
          other.cost == this.cost &&
          other.salePrice == this.salePrice &&
          other.active == this.active);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<int> categoryId;
  final Value<int> unitId;
  final Value<String?> barcode;
  final Value<double> cost;
  final Value<double> salePrice;
  final Value<bool> active;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.cost = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.active = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    required int categoryId,
    required int unitId,
    this.barcode = const Value.absent(),
    this.cost = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.active = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       categoryId = Value(categoryId),
       unitId = Value(unitId);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? categoryId,
    Expression<int>? unitId,
    Expression<String>? barcode,
    Expression<double>? cost,
    Expression<double>? salePrice,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (unitId != null) 'unit_id': unitId,
      if (barcode != null) 'barcode': barcode,
      if (cost != null) 'cost': cost,
      if (salePrice != null) 'sale_price': salePrice,
      if (active != null) 'active': active,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<int>? categoryId,
    Value<int>? unitId,
    Value<String?>? barcode,
    Value<double>? cost,
    Value<double>? salePrice,
    Value<bool>? active,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      unitId: unitId ?? this.unitId,
      barcode: barcode ?? this.barcode,
      cost: cost ?? this.cost,
      salePrice: salePrice ?? this.salePrice,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitId: $unitId, ')
          ..write('barcode: $barcode, ')
          ..write('cost: $cost, ')
          ..write('salePrice: $salePrice, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $InventoryBalancesTable extends InventoryBalances
    with TableInfo<$InventoryBalancesTable, InventoryBalance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warehouseIdMeta = const VerificationMeta(
    'warehouseId',
  );
  @override
  late final GeneratedColumn<int> warehouseId = GeneratedColumn<int>(
    'warehouse_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    warehouseId,
    quantity,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryBalance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('warehouse_id')) {
      context.handle(
        _warehouseIdMeta,
        warehouseId.isAcceptableOrUnknown(
          data['warehouse_id']!,
          _warehouseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warehouseIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryBalance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryBalance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      warehouseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warehouse_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InventoryBalancesTable createAlias(String alias) {
    return $InventoryBalancesTable(attachedDatabase, alias);
  }
}

class InventoryBalance extends DataClass
    implements Insertable<InventoryBalance> {
  final int id;
  final int itemId;
  final int warehouseId;
  final double quantity;
  final DateTime updatedAt;
  const InventoryBalance({
    required this.id,
    required this.itemId,
    required this.warehouseId,
    required this.quantity,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['warehouse_id'] = Variable<int>(warehouseId);
    map['quantity'] = Variable<double>(quantity);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InventoryBalancesCompanion toCompanion(bool nullToAbsent) {
    return InventoryBalancesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      warehouseId: Value(warehouseId),
      quantity: Value(quantity),
      updatedAt: Value(updatedAt),
    );
  }

  factory InventoryBalance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryBalance(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      warehouseId: serializer.fromJson<int>(json['warehouseId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'warehouseId': serializer.toJson<int>(warehouseId),
      'quantity': serializer.toJson<double>(quantity),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InventoryBalance copyWith({
    int? id,
    int? itemId,
    int? warehouseId,
    double? quantity,
    DateTime? updatedAt,
  }) => InventoryBalance(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    warehouseId: warehouseId ?? this.warehouseId,
    quantity: quantity ?? this.quantity,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InventoryBalance copyWithCompanion(InventoryBalancesCompanion data) {
    return InventoryBalance(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      warehouseId: data.warehouseId.present
          ? data.warehouseId.value
          : this.warehouseId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBalance(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('quantity: $quantity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, warehouseId, quantity, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryBalance &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.warehouseId == this.warehouseId &&
          other.quantity == this.quantity &&
          other.updatedAt == this.updatedAt);
}

class InventoryBalancesCompanion extends UpdateCompanion<InventoryBalance> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<int> warehouseId;
  final Value<double> quantity;
  final Value<DateTime> updatedAt;
  const InventoryBalancesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InventoryBalancesCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required int warehouseId,
    this.quantity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : itemId = Value(itemId),
       warehouseId = Value(warehouseId);
  static Insertable<InventoryBalance> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? warehouseId,
    Expression<double>? quantity,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (quantity != null) 'quantity': quantity,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InventoryBalancesCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<int>? warehouseId,
    Value<double>? quantity,
    Value<DateTime>? updatedAt,
  }) {
    return InventoryBalancesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      warehouseId: warehouseId ?? this.warehouseId,
      quantity: quantity ?? this.quantity,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<int>(warehouseId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBalancesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('quantity: $quantity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InventoryTransactionsTable extends InventoryTransactions
    with TableInfo<$InventoryTransactionsTable, InventoryTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warehouseIdMeta = const VerificationMeta(
    'warehouseId',
  );
  @override
  late final GeneratedColumn<int> warehouseId = GeneratedColumn<int>(
    'warehouse_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    warehouseId,
    type,
    quantity,
    cost,
    date,
    reference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('warehouse_id')) {
      context.handle(
        _warehouseIdMeta,
        warehouseId.isAcceptableOrUnknown(
          data['warehouse_id']!,
          _warehouseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warehouseIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      warehouseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warehouse_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
    );
  }

  @override
  $InventoryTransactionsTable createAlias(String alias) {
    return $InventoryTransactionsTable(attachedDatabase, alias);
  }
}

class InventoryTransaction extends DataClass
    implements Insertable<InventoryTransaction> {
  final int id;
  final int itemId;
  final int warehouseId;
  final String type;
  final double quantity;
  final double cost;
  final DateTime date;
  final String? reference;
  const InventoryTransaction({
    required this.id,
    required this.itemId,
    required this.warehouseId,
    required this.type,
    required this.quantity,
    required this.cost,
    required this.date,
    this.reference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['warehouse_id'] = Variable<int>(warehouseId);
    map['type'] = Variable<String>(type);
    map['quantity'] = Variable<double>(quantity);
    map['cost'] = Variable<double>(cost);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    return map;
  }

  InventoryTransactionsCompanion toCompanion(bool nullToAbsent) {
    return InventoryTransactionsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      warehouseId: Value(warehouseId),
      type: Value(type),
      quantity: Value(quantity),
      cost: Value(cost),
      date: Value(date),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
    );
  }

  factory InventoryTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryTransaction(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      warehouseId: serializer.fromJson<int>(json['warehouseId']),
      type: serializer.fromJson<String>(json['type']),
      quantity: serializer.fromJson<double>(json['quantity']),
      cost: serializer.fromJson<double>(json['cost']),
      date: serializer.fromJson<DateTime>(json['date']),
      reference: serializer.fromJson<String?>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'warehouseId': serializer.toJson<int>(warehouseId),
      'type': serializer.toJson<String>(type),
      'quantity': serializer.toJson<double>(quantity),
      'cost': serializer.toJson<double>(cost),
      'date': serializer.toJson<DateTime>(date),
      'reference': serializer.toJson<String?>(reference),
    };
  }

  InventoryTransaction copyWith({
    int? id,
    int? itemId,
    int? warehouseId,
    String? type,
    double? quantity,
    double? cost,
    DateTime? date,
    Value<String?> reference = const Value.absent(),
  }) => InventoryTransaction(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    warehouseId: warehouseId ?? this.warehouseId,
    type: type ?? this.type,
    quantity: quantity ?? this.quantity,
    cost: cost ?? this.cost,
    date: date ?? this.date,
    reference: reference.present ? reference.value : this.reference,
  );
  InventoryTransaction copyWithCompanion(InventoryTransactionsCompanion data) {
    return InventoryTransaction(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      warehouseId: data.warehouseId.present
          ? data.warehouseId.value
          : this.warehouseId,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      cost: data.cost.present ? data.cost.value : this.cost,
      date: data.date.present ? data.date.value : this.date,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTransaction(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('cost: $cost, ')
          ..write('date: $date, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    warehouseId,
    type,
    quantity,
    cost,
    date,
    reference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryTransaction &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.warehouseId == this.warehouseId &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.cost == this.cost &&
          other.date == this.date &&
          other.reference == this.reference);
}

class InventoryTransactionsCompanion
    extends UpdateCompanion<InventoryTransaction> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<int> warehouseId;
  final Value<String> type;
  final Value<double> quantity;
  final Value<double> cost;
  final Value<DateTime> date;
  final Value<String?> reference;
  const InventoryTransactionsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.cost = const Value.absent(),
    this.date = const Value.absent(),
    this.reference = const Value.absent(),
  });
  InventoryTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required int warehouseId,
    required String type,
    required double quantity,
    required double cost,
    this.date = const Value.absent(),
    this.reference = const Value.absent(),
  }) : itemId = Value(itemId),
       warehouseId = Value(warehouseId),
       type = Value(type),
       quantity = Value(quantity),
       cost = Value(cost);
  static Insertable<InventoryTransaction> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? warehouseId,
    Expression<String>? type,
    Expression<double>? quantity,
    Expression<double>? cost,
    Expression<DateTime>? date,
    Expression<String>? reference,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (cost != null) 'cost': cost,
      if (date != null) 'date': date,
      if (reference != null) 'reference': reference,
    });
  }

  InventoryTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<int>? warehouseId,
    Value<String>? type,
    Value<double>? quantity,
    Value<double>? cost,
    Value<DateTime>? date,
    Value<String?>? reference,
  }) {
    return InventoryTransactionsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      warehouseId: warehouseId ?? this.warehouseId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      cost: cost ?? this.cost,
      date: date ?? this.date,
      reference: reference ?? this.reference,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<int>(warehouseId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('cost: $cost, ')
          ..write('date: $date, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeRateMeta = const VerificationMeta(
    'exchangeRate',
  );
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
    'exchange_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    number,
    type,
    date,
    accountId,
    currency,
    exchangeRate,
    description,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
        _exchangeRateMeta,
        exchangeRate.isAcceptableOrUnknown(
          data['exchange_rate']!,
          _exchangeRateMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      exchangeRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exchange_rate'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final String number;
  final String type;
  final DateTime date;
  final int accountId;
  final String currency;
  final double exchangeRate;
  final String? description;
  final String status;
  const Document({
    required this.id,
    required this.number,
    required this.type,
    required this.date,
    required this.accountId,
    required this.currency,
    required this.exchangeRate,
    this.description,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<String>(number);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    map['account_id'] = Variable<int>(accountId);
    map['currency'] = Variable<String>(currency);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      number: Value(number),
      type: Value(type),
      date: Value(date),
      accountId: Value(accountId),
      currency: Value(currency),
      exchangeRate: Value(exchangeRate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      accountId: serializer.fromJson<int>(json['accountId']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<String>(number),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'accountId': serializer.toJson<int>(accountId),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
    };
  }

  Document copyWith({
    int? id,
    String? number,
    String? type,
    DateTime? date,
    int? accountId,
    String? currency,
    double? exchangeRate,
    Value<String?> description = const Value.absent(),
    String? status,
  }) => Document(
    id: id ?? this.id,
    number: number ?? this.number,
    type: type ?? this.type,
    date: date ?? this.date,
    accountId: accountId ?? this.accountId,
    currency: currency ?? this.currency,
    exchangeRate: exchangeRate ?? this.exchangeRate,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('accountId: $accountId, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('description: $description, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    number,
    type,
    date,
    accountId,
    currency,
    exchangeRate,
    description,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.number == this.number &&
          other.type == this.type &&
          other.date == this.date &&
          other.accountId == this.accountId &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.description == this.description &&
          other.status == this.status);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<String> number;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<int> accountId;
  final Value<String> currency;
  final Value<double> exchangeRate;
  final Value<String?> description;
  final Value<String> status;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.accountId = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String number,
    required String type,
    this.date = const Value.absent(),
    required int accountId,
    required String currency,
    this.exchangeRate = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
  }) : number = Value(number),
       type = Value(type),
       accountId = Value(accountId),
       currency = Value(currency);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<String>? number,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<int>? accountId,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<String>? description,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (accountId != null) 'account_id': accountId,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    });
  }

  DocumentsCompanion copyWith({
    Value<int>? id,
    Value<String>? number,
    Value<String>? type,
    Value<DateTime>? date,
    Value<int>? accountId,
    Value<String>? currency,
    Value<double>? exchangeRate,
    Value<String?>? description,
    Value<String>? status,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      type: type ?? this.type,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('accountId: $accountId, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('description: $description, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $DocumentLinesTable extends DocumentLines
    with TableInfo<$DocumentLinesTable, DocumentLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
    'debit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
    'credit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    itemId,
    accountId,
    quantity,
    price,
    debit,
    credit,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit'],
      )!,
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $DocumentLinesTable createAlias(String alias) {
    return $DocumentLinesTable(attachedDatabase, alias);
  }
}

class DocumentLine extends DataClass implements Insertable<DocumentLine> {
  final int id;
  final int documentId;
  final int? itemId;
  final int accountId;
  final double quantity;
  final double price;
  final double debit;
  final double credit;
  final String? description;
  const DocumentLine({
    required this.id,
    required this.documentId,
    this.itemId,
    required this.accountId,
    required this.quantity,
    required this.price,
    required this.debit,
    required this.credit,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<int>(documentId);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    map['account_id'] = Variable<int>(accountId);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  DocumentLinesCompanion toCompanion(bool nullToAbsent) {
    return DocumentLinesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      accountId: Value(accountId),
      quantity: Value(quantity),
      price: Value(price),
      debit: Value(debit),
      credit: Value(credit),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory DocumentLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentLine(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<int>(json['documentId']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<int>(documentId),
      'itemId': serializer.toJson<int?>(itemId),
      'accountId': serializer.toJson<int>(accountId),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'description': serializer.toJson<String?>(description),
    };
  }

  DocumentLine copyWith({
    int? id,
    int? documentId,
    Value<int?> itemId = const Value.absent(),
    int? accountId,
    double? quantity,
    double? price,
    double? debit,
    double? credit,
    Value<String?> description = const Value.absent(),
  }) => DocumentLine(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    itemId: itemId.present ? itemId.value : this.itemId,
    accountId: accountId ?? this.accountId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    debit: debit ?? this.debit,
    credit: credit ?? this.credit,
    description: description.present ? description.value : this.description,
  );
  DocumentLine copyWithCompanion(DocumentLinesCompanion data) {
    return DocumentLine(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentLine(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('itemId: $itemId, ')
          ..write('accountId: $accountId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    itemId,
    accountId,
    quantity,
    price,
    debit,
    credit,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentLine &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.itemId == this.itemId &&
          other.accountId == this.accountId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.description == this.description);
}

class DocumentLinesCompanion extends UpdateCompanion<DocumentLine> {
  final Value<int> id;
  final Value<int> documentId;
  final Value<int?> itemId;
  final Value<int> accountId;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> debit;
  final Value<double> credit;
  final Value<String?> description;
  const DocumentLinesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
  });
  DocumentLinesCompanion.insert({
    this.id = const Value.absent(),
    required int documentId,
    this.itemId = const Value.absent(),
    required int accountId,
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
  }) : documentId = Value(documentId),
       accountId = Value(accountId);
  static Insertable<DocumentLine> custom({
    Expression<int>? id,
    Expression<int>? documentId,
    Expression<int>? itemId,
    Expression<int>? accountId,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (itemId != null) 'item_id': itemId,
      if (accountId != null) 'account_id': accountId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (description != null) 'description': description,
    });
  }

  DocumentLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? documentId,
    Value<int?>? itemId,
    Value<int>? accountId,
    Value<double>? quantity,
    Value<double>? price,
    Value<double>? debit,
    Value<double>? credit,
    Value<String?>? description,
  }) {
    return DocumentLinesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      itemId: itemId ?? this.itemId,
      accountId: accountId ?? this.accountId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentLinesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('itemId: $itemId, ')
          ..write('accountId: $accountId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $SystemAccountsTable systemAccounts = $SystemAccountsTable(this);
  late final $AccountRulesTable accountRules = $AccountRulesTable(this);
  late final $AccountLinksTable accountLinks = $AccountLinksTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalLinesTable journalLines = $JournalLinesTable(this);
  late final $LedgerTable ledger = $LedgerTable(this);
  late final $BalancesTable balances = $BalancesTable(this);
  late final $FinancialAccountsTable financialAccounts =
      $FinancialAccountsTable(this);
  late final $CashBoxesTable cashBoxes = $CashBoxesTable(this);
  late final $BanksTable banks = $BanksTable(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $ExchangeCompaniesTable exchangeCompanies =
      $ExchangeCompaniesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $WarehousesTable warehouses = $WarehousesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $InventoryBalancesTable inventoryBalances =
      $InventoryBalancesTable(this);
  late final $InventoryTransactionsTable inventoryTransactions =
      $InventoryTransactionsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $DocumentLinesTable documentLines = $DocumentLinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    companies,
    settings,
    currencies,
    exchangeRates,
    accounts,
    systemAccounts,
    accountRules,
    accountLinks,
    journalEntries,
    journalLines,
    ledger,
    balances,
    financialAccounts,
    cashBoxes,
    banks,
    wallets,
    exchangeCompanies,
    customers,
    suppliers,
    categories,
    units,
    warehouses,
    items,
    inventoryBalances,
    inventoryTransactions,
    documents,
    documentLines,
  ];
}

typedef $$CompaniesTableCreateCompanionBuilder =
    CompaniesCompanion Function({
      Value<int> id,
      required String nameArabic,
      Value<String?> nameEnglish,
      Value<String?> phone,
      Value<String?> address,
      Value<DateTime> createdAt,
    });
typedef $$CompaniesTableUpdateCompanionBuilder =
    CompaniesCompanion Function({
      Value<int> id,
      Value<String> nameArabic,
      Value<String?> nameEnglish,
      Value<String?> phone,
      Value<String?> address,
      Value<DateTime> createdAt,
    });

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompaniesTable,
          Company,
          $$CompaniesTableFilterComposer,
          $$CompaniesTableOrderingComposer,
          $$CompaniesTableAnnotationComposer,
          $$CompaniesTableCreateCompanionBuilder,
          $$CompaniesTableUpdateCompanionBuilder,
          (Company, BaseReferences<_$AppDatabase, $CompaniesTable, Company>),
          Company,
          PrefetchHooks Function()
        > {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String?> nameEnglish = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CompaniesCompanion(
                id: id,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                phone: phone,
                address: address,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameArabic,
                Value<String?> nameEnglish = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CompaniesCompanion.insert(
                id: id,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                phone: phone,
                address: address,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompaniesTable,
      Company,
      $$CompaniesTableFilterComposer,
      $$CompaniesTableOrderingComposer,
      $$CompaniesTableAnnotationComposer,
      $$CompaniesTableCreateCompanionBuilder,
      $$CompaniesTableUpdateCompanionBuilder,
      (Company, BaseReferences<_$AppDatabase, $CompaniesTable, Company>),
      Company,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      required String key,
      Value<String?> value,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String?> value,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
              }) => SettingsCompanion(id: id, key: key, value: value),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                Value<String?> value = const Value.absent(),
              }) => SettingsCompanion.insert(id: id, key: key, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$CurrenciesTableCreateCompanionBuilder =
    CurrenciesCompanion Function({
      Value<int> id,
      required String code,
      required String nameArabic,
      Value<String?> nameEnglish,
      Value<bool> isBase,
      Value<bool> active,
    });
typedef $$CurrenciesTableUpdateCompanionBuilder =
    CurrenciesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameArabic,
      Value<String?> nameEnglish,
      Value<bool> isBase,
      Value<bool> active,
    });

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBase => $composableBuilder(
    column: $table.isBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBase => $composableBuilder(
    column: $table.isBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBase =>
      $composableBuilder(column: $table.isBase, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CurrenciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrenciesTable,
          Currency,
          $$CurrenciesTableFilterComposer,
          $$CurrenciesTableOrderingComposer,
          $$CurrenciesTableAnnotationComposer,
          $$CurrenciesTableCreateCompanionBuilder,
          $$CurrenciesTableUpdateCompanionBuilder,
          (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
          Currency,
          PrefetchHooks Function()
        > {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String?> nameEnglish = const Value.absent(),
                Value<bool> isBase = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => CurrenciesCompanion(
                id: id,
                code: code,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                isBase: isBase,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameArabic,
                Value<String?> nameEnglish = const Value.absent(),
                Value<bool> isBase = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => CurrenciesCompanion.insert(
                id: id,
                code: code,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                isBase: isBase,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurrenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrenciesTable,
      Currency,
      $$CurrenciesTableFilterComposer,
      $$CurrenciesTableOrderingComposer,
      $$CurrenciesTableAnnotationComposer,
      $$CurrenciesTableCreateCompanionBuilder,
      $$CurrenciesTableUpdateCompanionBuilder,
      (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
      Currency,
      PrefetchHooks Function()
    >;
typedef $$ExchangeRatesTableCreateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<int> id,
      required int currencyId,
      required double rate,
      required DateTime date,
    });
typedef $$ExchangeRatesTableUpdateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<int> id,
      Value<int> currencyId,
      Value<double> rate,
      Value<DateTime> date,
    });

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRatesTable,
          ExchangeRate,
          $$ExchangeRatesTableFilterComposer,
          $$ExchangeRatesTableOrderingComposer,
          $$ExchangeRatesTableAnnotationComposer,
          $$ExchangeRatesTableCreateCompanionBuilder,
          $$ExchangeRatesTableUpdateCompanionBuilder,
          (
            ExchangeRate,
            BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>,
          ),
          ExchangeRate,
          PrefetchHooks Function()
        > {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currencyId = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => ExchangeRatesCompanion(
                id: id,
                currencyId: currencyId,
                rate: rate,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int currencyId,
                required double rate,
                required DateTime date,
              }) => ExchangeRatesCompanion.insert(
                id: id,
                currencyId: currencyId,
                rate: rate,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRatesTable,
      ExchangeRate,
      $$ExchangeRatesTableFilterComposer,
      $$ExchangeRatesTableOrderingComposer,
      $$ExchangeRatesTableAnnotationComposer,
      $$ExchangeRatesTableCreateCompanionBuilder,
      $$ExchangeRatesTableUpdateCompanionBuilder,
      (
        ExchangeRate,
        BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>,
      ),
      ExchangeRate,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String accountNumber,
      required String nameArabic,
      Value<String?> nameEnglish,
      Value<int?> parentId,
      required int level,
      required String accountType,
      required String nature,
      Value<bool> allowPosting,
      Value<bool> active,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> accountNumber,
      Value<String> nameArabic,
      Value<String?> nameEnglish,
      Value<int?> parentId,
      Value<int> level,
      Value<String> accountType,
      Value<String> nature,
      Value<bool> allowPosting,
      Value<bool> active,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowPosting => $composableBuilder(
    column: $table.allowPosting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowPosting => $composableBuilder(
    column: $table.allowPosting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nature =>
      $composableBuilder(column: $table.nature, builder: (column) => column);

  GeneratedColumn<bool> get allowPosting => $composableBuilder(
    column: $table.allowPosting,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String?> nameEnglish = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String> nature = const Value.absent(),
                Value<bool> allowPosting = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                accountNumber: accountNumber,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                parentId: parentId,
                level: level,
                accountType: accountType,
                nature: nature,
                allowPosting: allowPosting,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountNumber,
                required String nameArabic,
                Value<String?> nameEnglish = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                required int level,
                required String accountType,
                required String nature,
                Value<bool> allowPosting = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                accountNumber: accountNumber,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                parentId: parentId,
                level: level,
                accountType: accountType,
                nature: nature,
                allowPosting: allowPosting,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$SystemAccountsTableCreateCompanionBuilder =
    SystemAccountsCompanion Function({
      Value<int> id,
      required String key,
      required int accountId,
      Value<String?> description,
    });
typedef $$SystemAccountsTableUpdateCompanionBuilder =
    SystemAccountsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<int> accountId,
      Value<String?> description,
    });

class $$SystemAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemAccountsTable> {
  $$SystemAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemAccountsTable> {
  $$SystemAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemAccountsTable> {
  $$SystemAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$SystemAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemAccountsTable,
          SystemAccount,
          $$SystemAccountsTableFilterComposer,
          $$SystemAccountsTableOrderingComposer,
          $$SystemAccountsTableAnnotationComposer,
          $$SystemAccountsTableCreateCompanionBuilder,
          $$SystemAccountsTableUpdateCompanionBuilder,
          (
            SystemAccount,
            BaseReferences<_$AppDatabase, $SystemAccountsTable, SystemAccount>,
          ),
          SystemAccount,
          PrefetchHooks Function()
        > {
  $$SystemAccountsTableTableManager(
    _$AppDatabase db,
    $SystemAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => SystemAccountsCompanion(
                id: id,
                key: key,
                accountId: accountId,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required int accountId,
                Value<String?> description = const Value.absent(),
              }) => SystemAccountsCompanion.insert(
                id: id,
                key: key,
                accountId: accountId,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SystemAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemAccountsTable,
      SystemAccount,
      $$SystemAccountsTableFilterComposer,
      $$SystemAccountsTableOrderingComposer,
      $$SystemAccountsTableAnnotationComposer,
      $$SystemAccountsTableCreateCompanionBuilder,
      $$SystemAccountsTableUpdateCompanionBuilder,
      (
        SystemAccount,
        BaseReferences<_$AppDatabase, $SystemAccountsTable, SystemAccount>,
      ),
      SystemAccount,
      PrefetchHooks Function()
    >;
typedef $$AccountRulesTableCreateCompanionBuilder =
    AccountRulesCompanion Function({
      Value<int> id,
      required String entityType,
      required int parentAccountId,
      Value<bool> autoCreate,
      Value<bool> allowPosting,
    });
typedef $$AccountRulesTableUpdateCompanionBuilder =
    AccountRulesCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int> parentAccountId,
      Value<bool> autoCreate,
      Value<bool> allowPosting,
    });

class $$AccountRulesTableFilterComposer
    extends Composer<_$AppDatabase, $AccountRulesTable> {
  $$AccountRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentAccountId => $composableBuilder(
    column: $table.parentAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCreate => $composableBuilder(
    column: $table.autoCreate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowPosting => $composableBuilder(
    column: $table.allowPosting,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountRulesTable> {
  $$AccountRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentAccountId => $composableBuilder(
    column: $table.parentAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCreate => $composableBuilder(
    column: $table.autoCreate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowPosting => $composableBuilder(
    column: $table.allowPosting,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountRulesTable> {
  $$AccountRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentAccountId => $composableBuilder(
    column: $table.parentAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCreate => $composableBuilder(
    column: $table.autoCreate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowPosting => $composableBuilder(
    column: $table.allowPosting,
    builder: (column) => column,
  );
}

class $$AccountRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountRulesTable,
          AccountRule,
          $$AccountRulesTableFilterComposer,
          $$AccountRulesTableOrderingComposer,
          $$AccountRulesTableAnnotationComposer,
          $$AccountRulesTableCreateCompanionBuilder,
          $$AccountRulesTableUpdateCompanionBuilder,
          (
            AccountRule,
            BaseReferences<_$AppDatabase, $AccountRulesTable, AccountRule>,
          ),
          AccountRule,
          PrefetchHooks Function()
        > {
  $$AccountRulesTableTableManager(_$AppDatabase db, $AccountRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> parentAccountId = const Value.absent(),
                Value<bool> autoCreate = const Value.absent(),
                Value<bool> allowPosting = const Value.absent(),
              }) => AccountRulesCompanion(
                id: id,
                entityType: entityType,
                parentAccountId: parentAccountId,
                autoCreate: autoCreate,
                allowPosting: allowPosting,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required int parentAccountId,
                Value<bool> autoCreate = const Value.absent(),
                Value<bool> allowPosting = const Value.absent(),
              }) => AccountRulesCompanion.insert(
                id: id,
                entityType: entityType,
                parentAccountId: parentAccountId,
                autoCreate: autoCreate,
                allowPosting: allowPosting,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountRulesTable,
      AccountRule,
      $$AccountRulesTableFilterComposer,
      $$AccountRulesTableOrderingComposer,
      $$AccountRulesTableAnnotationComposer,
      $$AccountRulesTableCreateCompanionBuilder,
      $$AccountRulesTableUpdateCompanionBuilder,
      (
        AccountRule,
        BaseReferences<_$AppDatabase, $AccountRulesTable, AccountRule>,
      ),
      AccountRule,
      PrefetchHooks Function()
    >;
typedef $$AccountLinksTableCreateCompanionBuilder =
    AccountLinksCompanion Function({
      Value<int> id,
      required String module,
      required String entityType,
      required int entityId,
      required int accountId,
    });
typedef $$AccountLinksTableUpdateCompanionBuilder =
    AccountLinksCompanion Function({
      Value<int> id,
      Value<String> module,
      Value<String> entityType,
      Value<int> entityId,
      Value<int> accountId,
    });

class $$AccountLinksTableFilterComposer
    extends Composer<_$AppDatabase, $AccountLinksTable> {
  $$AccountLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountLinksTable> {
  $$AccountLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountLinksTable> {
  $$AccountLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$AccountLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountLinksTable,
          AccountLink,
          $$AccountLinksTableFilterComposer,
          $$AccountLinksTableOrderingComposer,
          $$AccountLinksTableAnnotationComposer,
          $$AccountLinksTableCreateCompanionBuilder,
          $$AccountLinksTableUpdateCompanionBuilder,
          (
            AccountLink,
            BaseReferences<_$AppDatabase, $AccountLinksTable, AccountLink>,
          ),
          AccountLink,
          PrefetchHooks Function()
        > {
  $$AccountLinksTableTableManager(_$AppDatabase db, $AccountLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
              }) => AccountLinksCompanion(
                id: id,
                module: module,
                entityType: entityType,
                entityId: entityId,
                accountId: accountId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String module,
                required String entityType,
                required int entityId,
                required int accountId,
              }) => AccountLinksCompanion.insert(
                id: id,
                module: module,
                entityType: entityType,
                entityId: entityId,
                accountId: accountId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountLinksTable,
      AccountLink,
      $$AccountLinksTableFilterComposer,
      $$AccountLinksTableOrderingComposer,
      $$AccountLinksTableAnnotationComposer,
      $$AccountLinksTableCreateCompanionBuilder,
      $$AccountLinksTableUpdateCompanionBuilder,
      (
        AccountLink,
        BaseReferences<_$AppDatabase, $AccountLinksTable, AccountLink>,
      ),
      AccountLink,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      required String reference,
      required String description,
      required DateTime date,
      required String currency,
      Value<double> exchangeRate,
      Value<DateTime> createdAt,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<String> description,
      Value<DateTime> date,
      Value<String> currency,
      Value<double> exchangeRate,
      Value<DateTime> createdAt,
    });

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> exchangeRate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                reference: reference,
                description: description,
                date: date,
                currency: currency,
                exchangeRate: exchangeRate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required String description,
                required DateTime date,
                required String currency,
                Value<double> exchangeRate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                reference: reference,
                description: description,
                date: date,
                currency: currency,
                exchangeRate: exchangeRate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$JournalLinesTableCreateCompanionBuilder =
    JournalLinesCompanion Function({
      Value<int> id,
      required int journalId,
      required int accountId,
      Value<double> debit,
      Value<double> credit,
      required String description,
    });
typedef $$JournalLinesTableUpdateCompanionBuilder =
    JournalLinesCompanion Function({
      Value<int> id,
      Value<int> journalId,
      Value<int> accountId,
      Value<double> debit,
      Value<double> credit,
      Value<String> description,
    });

class $$JournalLinesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalLinesTable> {
  $$JournalLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalId => $composableBuilder(
    column: $table.journalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalLinesTable> {
  $$JournalLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalId => $composableBuilder(
    column: $table.journalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalLinesTable> {
  $$JournalLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get journalId =>
      $composableBuilder(column: $table.journalId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$JournalLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalLinesTable,
          JournalLine,
          $$JournalLinesTableFilterComposer,
          $$JournalLinesTableOrderingComposer,
          $$JournalLinesTableAnnotationComposer,
          $$JournalLinesTableCreateCompanionBuilder,
          $$JournalLinesTableUpdateCompanionBuilder,
          (
            JournalLine,
            BaseReferences<_$AppDatabase, $JournalLinesTable, JournalLine>,
          ),
          JournalLine,
          PrefetchHooks Function()
        > {
  $$JournalLinesTableTableManager(_$AppDatabase db, $JournalLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> journalId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => JournalLinesCompanion(
                id: id,
                journalId: journalId,
                accountId: accountId,
                debit: debit,
                credit: credit,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int journalId,
                required int accountId,
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                required String description,
              }) => JournalLinesCompanion.insert(
                id: id,
                journalId: journalId,
                accountId: accountId,
                debit: debit,
                credit: credit,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalLinesTable,
      JournalLine,
      $$JournalLinesTableFilterComposer,
      $$JournalLinesTableOrderingComposer,
      $$JournalLinesTableAnnotationComposer,
      $$JournalLinesTableCreateCompanionBuilder,
      $$JournalLinesTableUpdateCompanionBuilder,
      (
        JournalLine,
        BaseReferences<_$AppDatabase, $JournalLinesTable, JournalLine>,
      ),
      JournalLine,
      PrefetchHooks Function()
    >;
typedef $$LedgerTableCreateCompanionBuilder =
    LedgerCompanion Function({
      Value<int> id,
      required int journalId,
      required int accountId,
      required DateTime date,
      Value<double> debit,
      Value<double> credit,
      Value<double> balance,
      required String description,
    });
typedef $$LedgerTableUpdateCompanionBuilder =
    LedgerCompanion Function({
      Value<int> id,
      Value<int> journalId,
      Value<int> accountId,
      Value<DateTime> date,
      Value<double> debit,
      Value<double> credit,
      Value<double> balance,
      Value<String> description,
    });

class $$LedgerTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerTable> {
  $$LedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalId => $composableBuilder(
    column: $table.journalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerTable> {
  $$LedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalId => $composableBuilder(
    column: $table.journalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerTable> {
  $$LedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get journalId =>
      $composableBuilder(column: $table.journalId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$LedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerTable,
          LedgerData,
          $$LedgerTableFilterComposer,
          $$LedgerTableOrderingComposer,
          $$LedgerTableAnnotationComposer,
          $$LedgerTableCreateCompanionBuilder,
          $$LedgerTableUpdateCompanionBuilder,
          (LedgerData, BaseReferences<_$AppDatabase, $LedgerTable, LedgerData>),
          LedgerData,
          PrefetchHooks Function()
        > {
  $$LedgerTableTableManager(_$AppDatabase db, $LedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> journalId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => LedgerCompanion(
                id: id,
                journalId: journalId,
                accountId: accountId,
                date: date,
                debit: debit,
                credit: credit,
                balance: balance,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int journalId,
                required int accountId,
                required DateTime date,
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<double> balance = const Value.absent(),
                required String description,
              }) => LedgerCompanion.insert(
                id: id,
                journalId: journalId,
                accountId: accountId,
                date: date,
                debit: debit,
                credit: credit,
                balance: balance,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerTable,
      LedgerData,
      $$LedgerTableFilterComposer,
      $$LedgerTableOrderingComposer,
      $$LedgerTableAnnotationComposer,
      $$LedgerTableCreateCompanionBuilder,
      $$LedgerTableUpdateCompanionBuilder,
      (LedgerData, BaseReferences<_$AppDatabase, $LedgerTable, LedgerData>),
      LedgerData,
      PrefetchHooks Function()
    >;
typedef $$BalancesTableCreateCompanionBuilder =
    BalancesCompanion Function({
      required int accountId,
      required String currency,
      Value<double> debitTotal,
      Value<double> creditTotal,
      Value<double> balance,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$BalancesTableUpdateCompanionBuilder =
    BalancesCompanion Function({
      Value<int> accountId,
      Value<String> currency,
      Value<double> debitTotal,
      Value<double> creditTotal,
      Value<double> balance,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BalancesTableFilterComposer
    extends Composer<_$AppDatabase, $BalancesTable> {
  $$BalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get debitTotal => $composableBuilder(
    column: $table.debitTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditTotal => $composableBuilder(
    column: $table.creditTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $BalancesTable> {
  $$BalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get debitTotal => $composableBuilder(
    column: $table.debitTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditTotal => $composableBuilder(
    column: $table.creditTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalancesTable> {
  $$BalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get debitTotal => $composableBuilder(
    column: $table.debitTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditTotal => $composableBuilder(
    column: $table.creditTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BalancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BalancesTable,
          Balance,
          $$BalancesTableFilterComposer,
          $$BalancesTableOrderingComposer,
          $$BalancesTableAnnotationComposer,
          $$BalancesTableCreateCompanionBuilder,
          $$BalancesTableUpdateCompanionBuilder,
          (Balance, BaseReferences<_$AppDatabase, $BalancesTable, Balance>),
          Balance,
          PrefetchHooks Function()
        > {
  $$BalancesTableTableManager(_$AppDatabase db, $BalancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BalancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> accountId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> debitTotal = const Value.absent(),
                Value<double> creditTotal = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BalancesCompanion(
                accountId: accountId,
                currency: currency,
                debitTotal: debitTotal,
                creditTotal: creditTotal,
                balance: balance,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int accountId,
                required String currency,
                Value<double> debitTotal = const Value.absent(),
                Value<double> creditTotal = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BalancesCompanion.insert(
                accountId: accountId,
                currency: currency,
                debitTotal: debitTotal,
                creditTotal: creditTotal,
                balance: balance,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BalancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BalancesTable,
      Balance,
      $$BalancesTableFilterComposer,
      $$BalancesTableOrderingComposer,
      $$BalancesTableAnnotationComposer,
      $$BalancesTableCreateCompanionBuilder,
      $$BalancesTableUpdateCompanionBuilder,
      (Balance, BaseReferences<_$AppDatabase, $BalancesTable, Balance>),
      Balance,
      PrefetchHooks Function()
    >;
typedef $$FinancialAccountsTableCreateCompanionBuilder =
    FinancialAccountsCompanion Function({
      Value<int> id,
      required String type,
      required String code,
      required String nameArabic,
      Value<String?> nameEnglish,
      required int accountId,
      required int currencyId,
      Value<String?> externalNumber,
      Value<String?> providerName,
      Value<bool> active,
      Value<String?> notes,
    });
typedef $$FinancialAccountsTableUpdateCompanionBuilder =
    FinancialAccountsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> code,
      Value<String> nameArabic,
      Value<String?> nameEnglish,
      Value<int> accountId,
      Value<int> currencyId,
      Value<String?> externalNumber,
      Value<String?> providerName,
      Value<bool> active,
      Value<String?> notes,
    });

class $$FinancialAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialAccountsTable> {
  $$FinancialAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalNumber => $composableBuilder(
    column: $table.externalNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinancialAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialAccountsTable> {
  $$FinancialAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalNumber => $composableBuilder(
    column: $table.externalNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinancialAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialAccountsTable> {
  $$FinancialAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalNumber => $composableBuilder(
    column: $table.externalNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FinancialAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialAccountsTable,
          FinancialAccount,
          $$FinancialAccountsTableFilterComposer,
          $$FinancialAccountsTableOrderingComposer,
          $$FinancialAccountsTableAnnotationComposer,
          $$FinancialAccountsTableCreateCompanionBuilder,
          $$FinancialAccountsTableUpdateCompanionBuilder,
          (
            FinancialAccount,
            BaseReferences<
              _$AppDatabase,
              $FinancialAccountsTable,
              FinancialAccount
            >,
          ),
          FinancialAccount,
          PrefetchHooks Function()
        > {
  $$FinancialAccountsTableTableManager(
    _$AppDatabase db,
    $FinancialAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialAccountsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String?> nameEnglish = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> currencyId = const Value.absent(),
                Value<String?> externalNumber = const Value.absent(),
                Value<String?> providerName = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FinancialAccountsCompanion(
                id: id,
                type: type,
                code: code,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                accountId: accountId,
                currencyId: currencyId,
                externalNumber: externalNumber,
                providerName: providerName,
                active: active,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String code,
                required String nameArabic,
                Value<String?> nameEnglish = const Value.absent(),
                required int accountId,
                required int currencyId,
                Value<String?> externalNumber = const Value.absent(),
                Value<String?> providerName = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FinancialAccountsCompanion.insert(
                id: id,
                type: type,
                code: code,
                nameArabic: nameArabic,
                nameEnglish: nameEnglish,
                accountId: accountId,
                currencyId: currencyId,
                externalNumber: externalNumber,
                providerName: providerName,
                active: active,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinancialAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialAccountsTable,
      FinancialAccount,
      $$FinancialAccountsTableFilterComposer,
      $$FinancialAccountsTableOrderingComposer,
      $$FinancialAccountsTableAnnotationComposer,
      $$FinancialAccountsTableCreateCompanionBuilder,
      $$FinancialAccountsTableUpdateCompanionBuilder,
      (
        FinancialAccount,
        BaseReferences<
          _$AppDatabase,
          $FinancialAccountsTable,
          FinancialAccount
        >,
      ),
      FinancialAccount,
      PrefetchHooks Function()
    >;
typedef $$CashBoxesTableCreateCompanionBuilder =
    CashBoxesCompanion Function({
      Value<int> id,
      required String code,
      required String nameArabic,
      required int currencyId,
      required int accountId,
      Value<bool> active,
      Value<String?> notes,
    });
typedef $$CashBoxesTableUpdateCompanionBuilder =
    CashBoxesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameArabic,
      Value<int> currencyId,
      Value<int> accountId,
      Value<bool> active,
      Value<String?> notes,
    });

class $$CashBoxesTableFilterComposer
    extends Composer<_$AppDatabase, $CashBoxesTable> {
  $$CashBoxesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashBoxesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashBoxesTable> {
  $$CashBoxesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashBoxesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashBoxesTable> {
  $$CashBoxesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CashBoxesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashBoxesTable,
          CashBoxe,
          $$CashBoxesTableFilterComposer,
          $$CashBoxesTableOrderingComposer,
          $$CashBoxesTableAnnotationComposer,
          $$CashBoxesTableCreateCompanionBuilder,
          $$CashBoxesTableUpdateCompanionBuilder,
          (CashBoxe, BaseReferences<_$AppDatabase, $CashBoxesTable, CashBoxe>),
          CashBoxe,
          PrefetchHooks Function()
        > {
  $$CashBoxesTableTableManager(_$AppDatabase db, $CashBoxesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashBoxesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashBoxesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashBoxesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<int> currencyId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => CashBoxesCompanion(
                id: id,
                code: code,
                nameArabic: nameArabic,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameArabic,
                required int currencyId,
                required int accountId,
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => CashBoxesCompanion.insert(
                id: id,
                code: code,
                nameArabic: nameArabic,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashBoxesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashBoxesTable,
      CashBoxe,
      $$CashBoxesTableFilterComposer,
      $$CashBoxesTableOrderingComposer,
      $$CashBoxesTableAnnotationComposer,
      $$CashBoxesTableCreateCompanionBuilder,
      $$CashBoxesTableUpdateCompanionBuilder,
      (CashBoxe, BaseReferences<_$AppDatabase, $CashBoxesTable, CashBoxe>),
      CashBoxe,
      PrefetchHooks Function()
    >;
typedef $$BanksTableCreateCompanionBuilder =
    BanksCompanion Function({
      Value<int> id,
      required String code,
      required String nameArabic,
      required int currencyId,
      required int accountId,
      Value<bool> active,
      Value<String?> notes,
    });
typedef $$BanksTableUpdateCompanionBuilder =
    BanksCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameArabic,
      Value<int> currencyId,
      Value<int> accountId,
      Value<bool> active,
      Value<String?> notes,
    });

class $$BanksTableFilterComposer extends Composer<_$AppDatabase, $BanksTable> {
  $$BanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BanksTableOrderingComposer
    extends Composer<_$AppDatabase, $BanksTable> {
  $$BanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BanksTable> {
  $$BanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$BanksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BanksTable,
          Bank,
          $$BanksTableFilterComposer,
          $$BanksTableOrderingComposer,
          $$BanksTableAnnotationComposer,
          $$BanksTableCreateCompanionBuilder,
          $$BanksTableUpdateCompanionBuilder,
          (Bank, BaseReferences<_$AppDatabase, $BanksTable, Bank>),
          Bank,
          PrefetchHooks Function()
        > {
  $$BanksTableTableManager(_$AppDatabase db, $BanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<int> currencyId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BanksCompanion(
                id: id,
                code: code,
                nameArabic: nameArabic,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameArabic,
                required int currencyId,
                required int accountId,
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BanksCompanion.insert(
                id: id,
                code: code,
                nameArabic: nameArabic,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BanksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BanksTable,
      Bank,
      $$BanksTableFilterComposer,
      $$BanksTableOrderingComposer,
      $$BanksTableAnnotationComposer,
      $$BanksTableCreateCompanionBuilder,
      $$BanksTableUpdateCompanionBuilder,
      (Bank, BaseReferences<_$AppDatabase, $BanksTable, Bank>),
      Bank,
      PrefetchHooks Function()
    >;
typedef $$WalletsTableCreateCompanionBuilder =
    WalletsCompanion Function({
      Value<int> id,
      required String code,
      required String nameArabic,
      required String provider,
      required int currencyId,
      required int accountId,
      Value<bool> active,
      Value<String?> notes,
    });
typedef $$WalletsTableUpdateCompanionBuilder =
    WalletsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameArabic,
      Value<String> provider,
      Value<int> currencyId,
      Value<int> accountId,
      Value<bool> active,
      Value<String?> notes,
    });

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTable,
          Wallet,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (Wallet, BaseReferences<_$AppDatabase, $WalletsTable, Wallet>),
          Wallet,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<int> currencyId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                code: code,
                nameArabic: nameArabic,
                provider: provider,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameArabic,
                required String provider,
                required int currencyId,
                required int accountId,
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WalletsCompanion.insert(
                id: id,
                code: code,
                nameArabic: nameArabic,
                provider: provider,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTable,
      Wallet,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (Wallet, BaseReferences<_$AppDatabase, $WalletsTable, Wallet>),
      Wallet,
      PrefetchHooks Function()
    >;
typedef $$ExchangeCompaniesTableCreateCompanionBuilder =
    ExchangeCompaniesCompanion Function({
      Value<int> id,
      required String code,
      required String nameArabic,
      required int currencyId,
      required int accountId,
      Value<bool> active,
      Value<String?> notes,
    });
typedef $$ExchangeCompaniesTableUpdateCompanionBuilder =
    ExchangeCompaniesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameArabic,
      Value<int> currencyId,
      Value<int> accountId,
      Value<bool> active,
      Value<String?> notes,
    });

class $$ExchangeCompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeCompaniesTable> {
  $$ExchangeCompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeCompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeCompaniesTable> {
  $$ExchangeCompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeCompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeCompaniesTable> {
  $$ExchangeCompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currencyId => $composableBuilder(
    column: $table.currencyId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ExchangeCompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeCompaniesTable,
          ExchangeCompany,
          $$ExchangeCompaniesTableFilterComposer,
          $$ExchangeCompaniesTableOrderingComposer,
          $$ExchangeCompaniesTableAnnotationComposer,
          $$ExchangeCompaniesTableCreateCompanionBuilder,
          $$ExchangeCompaniesTableUpdateCompanionBuilder,
          (
            ExchangeCompany,
            BaseReferences<
              _$AppDatabase,
              $ExchangeCompaniesTable,
              ExchangeCompany
            >,
          ),
          ExchangeCompany,
          PrefetchHooks Function()
        > {
  $$ExchangeCompaniesTableTableManager(
    _$AppDatabase db,
    $ExchangeCompaniesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeCompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeCompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeCompaniesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<int> currencyId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ExchangeCompaniesCompanion(
                id: id,
                code: code,
                nameArabic: nameArabic,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameArabic,
                required int currencyId,
                required int accountId,
                Value<bool> active = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ExchangeCompaniesCompanion.insert(
                id: id,
                code: code,
                nameArabic: nameArabic,
                currencyId: currencyId,
                accountId: accountId,
                active: active,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeCompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeCompaniesTable,
      ExchangeCompany,
      $$ExchangeCompaniesTableFilterComposer,
      $$ExchangeCompaniesTableOrderingComposer,
      $$ExchangeCompaniesTableAnnotationComposer,
      $$ExchangeCompaniesTableCreateCompanionBuilder,
      $$ExchangeCompaniesTableUpdateCompanionBuilder,
      (
        ExchangeCompany,
        BaseReferences<_$AppDatabase, $ExchangeCompaniesTable, ExchangeCompany>,
      ),
      ExchangeCompany,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      Value<String?> phone,
      Value<String?> address,
      required int accountId,
      Value<bool> active,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<String?> phone,
      Value<String?> address,
      Value<int> accountId,
      Value<bool> active,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                code: code,
                name: name,
                phone: phone,
                address: address,
                accountId: accountId,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required int accountId,
                Value<bool> active = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                code: code,
                name: name,
                phone: phone,
                address: address,
                accountId: accountId,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      Value<String?> phone,
      Value<String?> address,
      required int accountId,
      Value<bool> active,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<String?> phone,
      Value<String?> address,
      Value<int> accountId,
      Value<bool> active,
    });

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
          Supplier,
          PrefetchHooks Function()
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                code: code,
                name: name,
                phone: phone,
                address: address,
                accountId: accountId,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required int accountId,
                Value<bool> active = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                code: code,
                name: name,
                phone: phone,
                address: address,
                accountId: accountId,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
      Supplier,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> active,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> active,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => CategoriesCompanion(id: id, name: name, active: active),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> active = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      required String name,
      required String symbol,
      Value<bool> active,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> symbol,
      Value<bool> active,
    });

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
          Unit,
          PrefetchHooks Function()
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                name: name,
                symbol: symbol,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String symbol,
                Value<bool> active = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                name: name,
                symbol: symbol,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
      Unit,
      PrefetchHooks Function()
    >;
typedef $$WarehousesTableCreateCompanionBuilder =
    WarehousesCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      Value<String?> location,
      Value<bool> active,
    });
typedef $$WarehousesTableUpdateCompanionBuilder =
    WarehousesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<String?> location,
      Value<bool> active,
    });

class $$WarehousesTableFilterComposer
    extends Composer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WarehousesTableOrderingComposer
    extends Composer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WarehousesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$WarehousesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WarehousesTable,
          Warehouse,
          $$WarehousesTableFilterComposer,
          $$WarehousesTableOrderingComposer,
          $$WarehousesTableAnnotationComposer,
          $$WarehousesTableCreateCompanionBuilder,
          $$WarehousesTableUpdateCompanionBuilder,
          (
            Warehouse,
            BaseReferences<_$AppDatabase, $WarehousesTable, Warehouse>,
          ),
          Warehouse,
          PrefetchHooks Function()
        > {
  $$WarehousesTableTableManager(_$AppDatabase db, $WarehousesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WarehousesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WarehousesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WarehousesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => WarehousesCompanion(
                id: id,
                code: code,
                name: name,
                location: location,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                Value<String?> location = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => WarehousesCompanion.insert(
                id: id,
                code: code,
                name: name,
                location: location,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WarehousesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WarehousesTable,
      Warehouse,
      $$WarehousesTableFilterComposer,
      $$WarehousesTableOrderingComposer,
      $$WarehousesTableAnnotationComposer,
      $$WarehousesTableCreateCompanionBuilder,
      $$WarehousesTableUpdateCompanionBuilder,
      (Warehouse, BaseReferences<_$AppDatabase, $WarehousesTable, Warehouse>),
      Warehouse,
      PrefetchHooks Function()
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      required int categoryId,
      required int unitId,
      Value<String?> barcode,
      Value<double> cost,
      Value<double> salePrice,
      Value<bool> active,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<int> categoryId,
      Value<int> unitId,
      Value<String?> barcode,
      Value<double> cost,
      Value<double> salePrice,
      Value<bool> active,
    });

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
          Item,
          PrefetchHooks Function()
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                code: code,
                name: name,
                categoryId: categoryId,
                unitId: unitId,
                barcode: barcode,
                cost: cost,
                salePrice: salePrice,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                required int categoryId,
                required int unitId,
                Value<String?> barcode = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                code: code,
                name: name,
                categoryId: categoryId,
                unitId: unitId,
                barcode: barcode,
                cost: cost,
                salePrice: salePrice,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
      Item,
      PrefetchHooks Function()
    >;
typedef $$InventoryBalancesTableCreateCompanionBuilder =
    InventoryBalancesCompanion Function({
      Value<int> id,
      required int itemId,
      required int warehouseId,
      Value<double> quantity,
      Value<DateTime> updatedAt,
    });
typedef $$InventoryBalancesTableUpdateCompanionBuilder =
    InventoryBalancesCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<int> warehouseId,
      Value<double> quantity,
      Value<DateTime> updatedAt,
    });

class $$InventoryBalancesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryBalancesTable> {
  $$InventoryBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryBalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryBalancesTable> {
  $$InventoryBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryBalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryBalancesTable> {
  $$InventoryBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InventoryBalancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryBalancesTable,
          InventoryBalance,
          $$InventoryBalancesTableFilterComposer,
          $$InventoryBalancesTableOrderingComposer,
          $$InventoryBalancesTableAnnotationComposer,
          $$InventoryBalancesTableCreateCompanionBuilder,
          $$InventoryBalancesTableUpdateCompanionBuilder,
          (
            InventoryBalance,
            BaseReferences<
              _$AppDatabase,
              $InventoryBalancesTable,
              InventoryBalance
            >,
          ),
          InventoryBalance,
          PrefetchHooks Function()
        > {
  $$InventoryBalancesTableTableManager(
    _$AppDatabase db,
    $InventoryBalancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryBalancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> warehouseId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InventoryBalancesCompanion(
                id: id,
                itemId: itemId,
                warehouseId: warehouseId,
                quantity: quantity,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required int warehouseId,
                Value<double> quantity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InventoryBalancesCompanion.insert(
                id: id,
                itemId: itemId,
                warehouseId: warehouseId,
                quantity: quantity,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryBalancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryBalancesTable,
      InventoryBalance,
      $$InventoryBalancesTableFilterComposer,
      $$InventoryBalancesTableOrderingComposer,
      $$InventoryBalancesTableAnnotationComposer,
      $$InventoryBalancesTableCreateCompanionBuilder,
      $$InventoryBalancesTableUpdateCompanionBuilder,
      (
        InventoryBalance,
        BaseReferences<
          _$AppDatabase,
          $InventoryBalancesTable,
          InventoryBalance
        >,
      ),
      InventoryBalance,
      PrefetchHooks Function()
    >;
typedef $$InventoryTransactionsTableCreateCompanionBuilder =
    InventoryTransactionsCompanion Function({
      Value<int> id,
      required int itemId,
      required int warehouseId,
      required String type,
      required double quantity,
      required double cost,
      Value<DateTime> date,
      Value<String?> reference,
    });
typedef $$InventoryTransactionsTableUpdateCompanionBuilder =
    InventoryTransactionsCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<int> warehouseId,
      Value<String> type,
      Value<double> quantity,
      Value<double> cost,
      Value<DateTime> date,
      Value<String?> reference,
    });

class $$InventoryTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);
}

class $$InventoryTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTransactionsTable,
          InventoryTransaction,
          $$InventoryTransactionsTableFilterComposer,
          $$InventoryTransactionsTableOrderingComposer,
          $$InventoryTransactionsTableAnnotationComposer,
          $$InventoryTransactionsTableCreateCompanionBuilder,
          $$InventoryTransactionsTableUpdateCompanionBuilder,
          (
            InventoryTransaction,
            BaseReferences<
              _$AppDatabase,
              $InventoryTransactionsTable,
              InventoryTransaction
            >,
          ),
          InventoryTransaction,
          PrefetchHooks Function()
        > {
  $$InventoryTransactionsTableTableManager(
    _$AppDatabase db,
    $InventoryTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$InventoryTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InventoryTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> warehouseId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> reference = const Value.absent(),
              }) => InventoryTransactionsCompanion(
                id: id,
                itemId: itemId,
                warehouseId: warehouseId,
                type: type,
                quantity: quantity,
                cost: cost,
                date: date,
                reference: reference,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required int warehouseId,
                required String type,
                required double quantity,
                required double cost,
                Value<DateTime> date = const Value.absent(),
                Value<String?> reference = const Value.absent(),
              }) => InventoryTransactionsCompanion.insert(
                id: id,
                itemId: itemId,
                warehouseId: warehouseId,
                type: type,
                quantity: quantity,
                cost: cost,
                date: date,
                reference: reference,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTransactionsTable,
      InventoryTransaction,
      $$InventoryTransactionsTableFilterComposer,
      $$InventoryTransactionsTableOrderingComposer,
      $$InventoryTransactionsTableAnnotationComposer,
      $$InventoryTransactionsTableCreateCompanionBuilder,
      $$InventoryTransactionsTableUpdateCompanionBuilder,
      (
        InventoryTransaction,
        BaseReferences<
          _$AppDatabase,
          $InventoryTransactionsTable,
          InventoryTransaction
        >,
      ),
      InventoryTransaction,
      PrefetchHooks Function()
    >;
typedef $$DocumentsTableCreateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> id,
      required String number,
      required String type,
      Value<DateTime> date,
      required int accountId,
      required String currency,
      Value<double> exchangeRate,
      Value<String?> description,
      Value<String> status,
    });
typedef $$DocumentsTableUpdateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> id,
      Value<String> number,
      Value<String> type,
      Value<DateTime> date,
      Value<int> accountId,
      Value<String> currency,
      Value<double> exchangeRate,
      Value<String?> description,
      Value<String> status,
    });

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
          Document,
          PrefetchHooks Function()
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> exchangeRate = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                number: number,
                type: type,
                date: date,
                accountId: accountId,
                currency: currency,
                exchangeRate: exchangeRate,
                description: description,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String number,
                required String type,
                Value<DateTime> date = const Value.absent(),
                required int accountId,
                required String currency,
                Value<double> exchangeRate = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                number: number,
                type: type,
                date: date,
                accountId: accountId,
                currency: currency,
                exchangeRate: exchangeRate,
                description: description,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
      Document,
      PrefetchHooks Function()
    >;
typedef $$DocumentLinesTableCreateCompanionBuilder =
    DocumentLinesCompanion Function({
      Value<int> id,
      required int documentId,
      Value<int?> itemId,
      required int accountId,
      Value<double> quantity,
      Value<double> price,
      Value<double> debit,
      Value<double> credit,
      Value<String?> description,
    });
typedef $$DocumentLinesTableUpdateCompanionBuilder =
    DocumentLinesCompanion Function({
      Value<int> id,
      Value<int> documentId,
      Value<int?> itemId,
      Value<int> accountId,
      Value<double> quantity,
      Value<double> price,
      Value<double> debit,
      Value<double> credit,
      Value<String?> description,
    });

class $$DocumentLinesTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentLinesTable> {
  $$DocumentLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentLinesTable> {
  $$DocumentLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentLinesTable> {
  $$DocumentLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$DocumentLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentLinesTable,
          DocumentLine,
          $$DocumentLinesTableFilterComposer,
          $$DocumentLinesTableOrderingComposer,
          $$DocumentLinesTableAnnotationComposer,
          $$DocumentLinesTableCreateCompanionBuilder,
          $$DocumentLinesTableUpdateCompanionBuilder,
          (
            DocumentLine,
            BaseReferences<_$AppDatabase, $DocumentLinesTable, DocumentLine>,
          ),
          DocumentLine,
          PrefetchHooks Function()
        > {
  $$DocumentLinesTableTableManager(_$AppDatabase db, $DocumentLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> documentId = const Value.absent(),
                Value<int?> itemId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => DocumentLinesCompanion(
                id: id,
                documentId: documentId,
                itemId: itemId,
                accountId: accountId,
                quantity: quantity,
                price: price,
                debit: debit,
                credit: credit,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int documentId,
                Value<int?> itemId = const Value.absent(),
                required int accountId,
                Value<double> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => DocumentLinesCompanion.insert(
                id: id,
                documentId: documentId,
                itemId: itemId,
                accountId: accountId,
                quantity: quantity,
                price: price,
                debit: debit,
                credit: credit,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentLinesTable,
      DocumentLine,
      $$DocumentLinesTableFilterComposer,
      $$DocumentLinesTableOrderingComposer,
      $$DocumentLinesTableAnnotationComposer,
      $$DocumentLinesTableCreateCompanionBuilder,
      $$DocumentLinesTableUpdateCompanionBuilder,
      (
        DocumentLine,
        BaseReferences<_$AppDatabase, $DocumentLinesTable, DocumentLine>,
      ),
      DocumentLine,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$SystemAccountsTableTableManager get systemAccounts =>
      $$SystemAccountsTableTableManager(_db, _db.systemAccounts);
  $$AccountRulesTableTableManager get accountRules =>
      $$AccountRulesTableTableManager(_db, _db.accountRules);
  $$AccountLinksTableTableManager get accountLinks =>
      $$AccountLinksTableTableManager(_db, _db.accountLinks);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$JournalLinesTableTableManager get journalLines =>
      $$JournalLinesTableTableManager(_db, _db.journalLines);
  $$LedgerTableTableManager get ledger =>
      $$LedgerTableTableManager(_db, _db.ledger);
  $$BalancesTableTableManager get balances =>
      $$BalancesTableTableManager(_db, _db.balances);
  $$FinancialAccountsTableTableManager get financialAccounts =>
      $$FinancialAccountsTableTableManager(_db, _db.financialAccounts);
  $$CashBoxesTableTableManager get cashBoxes =>
      $$CashBoxesTableTableManager(_db, _db.cashBoxes);
  $$BanksTableTableManager get banks =>
      $$BanksTableTableManager(_db, _db.banks);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$ExchangeCompaniesTableTableManager get exchangeCompanies =>
      $$ExchangeCompaniesTableTableManager(_db, _db.exchangeCompanies);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$WarehousesTableTableManager get warehouses =>
      $$WarehousesTableTableManager(_db, _db.warehouses);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$InventoryBalancesTableTableManager get inventoryBalances =>
      $$InventoryBalancesTableTableManager(_db, _db.inventoryBalances);
  $$InventoryTransactionsTableTableManager get inventoryTransactions =>
      $$InventoryTransactionsTableTableManager(_db, _db.inventoryTransactions);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$DocumentLinesTableTableManager get documentLines =>
      $$DocumentLinesTableTableManager(_db, _db.documentLines);
}
