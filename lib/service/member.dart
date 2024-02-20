class Member {
  String name;
  String email;
  String photoURL;
  String? role;

  Member({
    // required this.id,
    required this.name,
    required this.email,
    required this.photoURL,
    this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        // id: json["id"],
        name: json["name"],
        email: json["email"],
        photoURL: json["photoURL"],
        role: json["role"],
      );
}
