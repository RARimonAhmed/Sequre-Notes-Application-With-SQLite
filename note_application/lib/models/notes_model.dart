class NoteModel {
  final int? id;
  final int age;
  final String title;
  final String email;
  final String description;
  NoteModel(
      {this.id,
      required this.age,
      required this.email,
      required this.title,
      required this.description});
  NoteModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        age = res['age'],
        email = res['email'],
        title = res['title'],
        description = res['description'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'age': age,
      'email': email,
      'title': title,
      'description': description
    };
  }
}
