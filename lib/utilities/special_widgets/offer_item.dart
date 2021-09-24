import 'package:flutter/material.dart';

class OfferItem extends StatelessWidget {
  final String title;
  final double price;
  final String? imagePath;
  final VoidCallback? onTap;

  const OfferItem(
      {Key? key,
      required this.title,
      required this.price,
      this.imagePath,
      this.onTap})
      : super(key: key);

  Widget _image({final double size = 100}) {
    if (imagePath == null) {
      return SizedBox(
          height: size,
          width: size,
          child:
              const Center(child: Icon(Icons.image_not_supported, size: 50)));
    }
    return Image.network(imagePath!,
        height: size,
        width: size,
        fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
          child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 0)
                  : null,
              valueColor: const AlwaysStoppedAnimation(Colors.white)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Row(children: [
          _image(),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(title), Text("\$$price")])))
        ]));
  }
}
