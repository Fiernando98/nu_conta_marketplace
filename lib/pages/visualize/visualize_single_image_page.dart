import 'package:flutter/material.dart';

class VisualizeSingleImagePage extends StatefulWidget {
  final String imagePath;

  const VisualizeSingleImagePage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _VisualizeSingleImagePageState createState() =>
      _VisualizeSingleImagePageState();
}

class _VisualizeSingleImagePageState extends State<VisualizeSingleImagePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: Stack(children: [
          SizedBox.fromSize(
              size: MediaQuery.of(context).size,
              child: InteractiveViewer(
                  maxScale: 10,
                  scaleEnabled: true,
                  panEnabled: true,
                  child: Center(
                      child: Hero(
                          child: Image.network(widget.imagePath,
                              fit: BoxFit.fill, loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                0)
                                        : null,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white)));
                          }),
                          tag: widget.imagePath)))),
          const SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: BackButton(color: Colors.white)))
        ]));
  }
}
