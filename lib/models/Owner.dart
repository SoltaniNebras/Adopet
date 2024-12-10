class Owner {
  final String name;
  final String description;
  final String imagePath;

  Owner({
    this.name = "John Doe",
    this.description = "Loves to take Rex on long walks.",
    this.imagePath = "assets/owner.png",
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'] ?? "John Doe", 
      description: json['description'] ?? "Loves to take Rex on long walks.",
      imagePath: 'assets/${json['imagePath'] ?? "owner.png"}', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "imagePath": imagePath,
    };
  }
}
