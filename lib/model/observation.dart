class Observation {
  int? id;
  String title;
  String time;
  String comment;
  int hikeId;

  Observation({
    this.id,
    required this.title,
    required this.time,
    required this.comment,
    required this.hikeId,
  });

  Observation copyWith({
    String? title,
    String? time,
    String? comment,
  })
  {
    return Observation(
        id: this.id,
        title: title ?? this.title,
        time: time ?? this.time,
        comment: comment ?? this.comment,
        hikeId: this.hikeId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'comment': comment,
      'hikeId': hikeId,
    };
  }
}