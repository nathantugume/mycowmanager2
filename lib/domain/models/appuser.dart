class AppUser {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final String role;
  final String? farmId;
  final String? profilePictureUrl;

  AppUser({
    required this.uid,
     this.name,
     this.email,
    this.phone,
    required this.role,
    this.farmId,
    this.profilePictureUrl,
  });



  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    uid: json['uid'] as String,
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? json['phoneNumber'] as String? ?? '',
    role: json['role'] as String? ?? 'Manager',
    farmId: json['farmId'] as String?,
    profilePictureUrl: json['profilePictureUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'farmId': farmId,
    'profilePictureUrl': profilePictureUrl,
  };
}