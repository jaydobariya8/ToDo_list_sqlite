class noteModel {
  final int? id;
  final String title;
  final int age;
  final String description;
  final String email;

  noteModel(
      {this.id,
      required this.title,
      required this.age,
      required this.description,
      required this.email});

  noteModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        age = res['age'],
        description = res['description'],
        email = res['email'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'age': age,
      'description': description,
      'email': email
    };
  }
}
