class RawImage {
  final String id;
  final String secret;
  final String server;
  final int farm;

  RawImage({
    this.id,
    this.secret,
    this.server,
    this.farm,
  });

  factory RawImage.fromJson(Map<String, dynamic> json) {
    return RawImage(
      id: json['id'],
      secret: json['secret'],
      server: json['server'],
      farm: json['farm'],
    );
  }
}
