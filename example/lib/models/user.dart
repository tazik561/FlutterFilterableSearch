class User {
  final String name;
  final int age;
  final String location;

  User({required this.name, required this.age, required this.location});

  // Example toJson method for searching
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'location': location,
      };
}
