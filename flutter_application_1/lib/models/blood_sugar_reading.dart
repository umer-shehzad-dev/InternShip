class BloodSugarReading {
  const BloodSugarReading({
    this.id,
    required this.valueMgDl,
    required this.recordedAt,
    this.conditions = const [],
    this.notes = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final double valueMgDl;
  final DateTime recordedAt;
  final List<String> conditions;
  final List<String> notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BloodSugarReading copyWith({
    int? id,
    double? valueMgDl,
    DateTime? recordedAt,
    List<String>? conditions,
    List<String>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BloodSugarReading(
      id: id ?? this.id,
      valueMgDl: valueMgDl ?? this.valueMgDl,
      recordedAt: recordedAt ?? this.recordedAt,
      conditions: conditions ?? this.conditions,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value_mg_dl': valueMgDl,
      'recorded_at': recordedAt.millisecondsSinceEpoch,
      'conditions': conditions.join('|'),
      'notes': notes.join('|'),
      'created_at': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
      'updated_at': (updatedAt ?? DateTime.now()).millisecondsSinceEpoch,
    };
  }

  factory BloodSugarReading.fromMap(Map<String, dynamic> map) {
    return BloodSugarReading(
      id: map['id'] as int?,
      valueMgDl: (map['value_mg_dl'] as num).toDouble(),
      recordedAt: DateTime.fromMillisecondsSinceEpoch(map['recorded_at'] as int),
      conditions: _splitList(map['conditions'] as String?),
      notes: _splitList(map['notes'] as String?),
      createdAt: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
    );
  }

  static List<String> _splitList(String? value) {
    if (value == null || value.isEmpty) return [];
    return value.split('|').where((item) => item.isNotEmpty).toList();
  }
}

class ReadingStats {
  const ReadingStats({
    required this.average,
    required this.minimum,
    required this.maximum,
    required this.count,
    required this.inRangePercent,
  });

  final double average;
  final double minimum;
  final double maximum;
  final int count;
  final double inRangePercent;
}

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.preview,
    required this.content,
  });

  final String id;
  final String title;
  final String category;
  final String preview;
  final String content;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      preview: json['preview'] as String,
      content: json['content'] as String,
    );
  }
}
