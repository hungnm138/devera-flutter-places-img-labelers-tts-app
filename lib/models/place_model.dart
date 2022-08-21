class PlaceModel {
  String name;
  String img;
  int price;
  int people;
  int stars;
  String description;
  String location;
  PlaceModel({
    required this.name,
    required this.img,
    required this.price,
    required this.people,
    required this.stars,
    required this.description,
    required this.location,
  });
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name'],
      img: json['img'],
      price: json['price'],
      people: json['people'],
      stars: json['stars'],
      description: json['description'],
      location: json['location'],
    );
  }
}
