class Image {
  final String id;
  final String secret;
  final String server;
  final int farm;

  Image({this.id, this.farm, this.secret, this.server});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      farm: json['farm'],
      server: json['server'],
      secret: json['secret'],
    );
  }
}
