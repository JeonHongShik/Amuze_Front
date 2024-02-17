import 'package:shared_preferences/shared_preferences.dart';

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

  // savePreference(Member member) async {
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   // pref.setInt('id', member.id);
  //   pref.setString('name', member.name);
  //   pref.setString('email', member.email);
  //   pref.setString('photoURL', member.photoURL);
  //   pref.setString('role', member.role ?? "");
  //   // member.userRole == 'ROLE_USER'
  //   //     ? pref.setInt('interest', member.interest!)
  //   //     : pref.setInt('major', member.major!);
  // }
}
