class Pokemon {
  String? name;
  Pokemon({this.name});

  Pokemon.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
  }
}
