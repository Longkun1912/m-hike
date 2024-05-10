import 'observation.dart';

class Hike {
  int? id;
  String name;
  String location;
  String date;
  String parking;
  String length;
  String difficulty;
  String description;
  List<Observation> observations;

  Hike({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.parking,
    required this.length,
    required this.difficulty,
    required this.description,
    this.observations = const [],
  });

  Hike copyWith({
    String? name,
    String? location,
    String? date,
    String? parking,
    String? length,
    String? difficulty,
    String? description,
  }) {
    return Hike(
      id: this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      date: date ?? this.date,
      parking: parking ?? this.parking,
      length: length ?? this.length,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'parking' : parking,
      'length': length,
      'difficulty' : difficulty,
      'description' : description
    };
  }
}
