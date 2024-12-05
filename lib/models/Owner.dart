class Owner {
  final String name;
  final String description;
  final String imagePath;

  Owner({
    required this.name,
    required this.description,
    required this.imagePath,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'],
      description: json['description'],
      imagePath: 'assets/${json['imagePath']}',
    );
  }
}
