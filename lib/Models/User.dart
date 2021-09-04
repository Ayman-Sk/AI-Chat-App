class User {
  int id;
  String name;
  String phoneNumber;
  String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'phoneNumber': this.phoneNumber.replaceAll(" ", ""),
        'imageUrl': this.imageUrl,
      };

  User.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = json['name'],
        this.phoneNumber = json['phoneNumber'],
        this.imageUrl = json['imageUrl'];
}
