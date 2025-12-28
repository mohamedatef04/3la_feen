class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? password;
  final String? profilePic;
  final String? cardIdPic;
  final String? carPic;
  final String? licensePic;
  final String? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.profilePic,
    this.cardIdPic,
    this.carPic,
    this.licensePic,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    profilePic: json['profile_pic'] as String?,
    cardIdPic: json['card_id_pic'] as String?,
    carPic: json['car_pic'] as String?,
    licensePic: json['license_pic'] as String?,
    role: json['role'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profile_pic': profilePic,
    'card_id_pic': cardIdPic,
    'car_pic': carPic,
    'license_pic': licensePic,
    'role': role,
  };
}
