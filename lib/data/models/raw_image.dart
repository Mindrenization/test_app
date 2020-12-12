class RawImage {
  final String id;
  final String secret;
  final String server;
  final int farm;

  RawImage({this.id, this.farm, this.secret, this.server});

  factory RawImage.fromJson(Map<String, dynamic> json) {
    return RawImage(
      id: json['id'],
      farm: json['farm'],
      server: json['server'],
      secret: json['secret'],
    );
  }
}
