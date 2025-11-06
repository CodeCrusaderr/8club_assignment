class Experience {
  final String id;
  final String name;
  final String imageUrl;

  const Experience({required this.id, required this.name, required this.imageUrl});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      imageUrl: (json['image_url'] ?? '').toString(),
    );
  }
}


