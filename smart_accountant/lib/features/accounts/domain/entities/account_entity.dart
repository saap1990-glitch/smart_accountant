class AccountEntity {
  final int id;

  final String number;

  final String nameArabic;

  final String? nameEnglish;

  final int level;

  final String type;

  final String nature;

  final int? parentId;

  final bool active;

  const AccountEntity({
    required this.id,

    required this.number,

    required this.nameArabic,

    this.nameEnglish,

    required this.level,

    required this.type,

    required this.nature,

    this.parentId,

    required this.active,
  });
}
