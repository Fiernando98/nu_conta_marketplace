import 'package:flutter/material.dart';

class ImageLoadNetwork extends StatelessWidget {
  final String? imagePath;
  final double size;

  const ImageLoadNetwork({Key? key, this.imagePath, this.size = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return SizedBox(
          height: size,
          width: size,
          child:
              const Center(child: Icon(Icons.image_not_supported, size: 50)));
    }
    return Hero(
        tag: imagePath!,
        child: Image.network(imagePath!,
            height: size, width: size, fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
              height: size,
              width: size,
              child: Center(
                  child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 0)
                          : null)));
        }));
  }
}
