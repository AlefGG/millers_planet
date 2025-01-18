class CardModel {
  final String text;
  final String imagePath;

  CardModel({
    required this.text,
    required this.imagePath,
  });

  CardModel copyWith({
    String? title,
    String? imagePath,
  }) {
    return CardModel(
      text: title ?? this.text,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
