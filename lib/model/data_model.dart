class InputData {
  String data;
  String action;
  InputData({
    required this.data,
    required this.action,
  });

  InputData.fromJson(Map<String, Object?> json)
      : this(
          data: (json['data']! as String),
          action: json['action']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'data': data,
      'action': action,
    };
  }
}
