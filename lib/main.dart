import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image 360',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;
  bool _showIndicator = false;
  Offset drag = Offset.zero;
  List<ImageProvider> images = [];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadImages(context));
    super.initState();
  }

  void loadImages(BuildContext c) async {
    for (int i = 1; i <= 18; i++) {
      images.add(AssetImage('assets/shoe/$i.jpeg'));
      await precacheImage(AssetImage('assets/shoe/$i.jpeg'), c);
    }
    setState(() {
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _loading
                    ? Expanded(
                        child: Image360(
                          key: UniqueKey(),
                          images: images,
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
            Transform.translate(
              offset: drag,
              child: Opacity(
                opacity: _showIndicator ? 1.0 : 0.0,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    border: Border.all(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Image360 extends StatefulWidget {
  const Image360({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<ImageProvider<Object>> images;

  @override
  _Image360State createState() => _Image360State();
}

class _Image360State extends State<Image360> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (update) {
        final dx = update.delta.dx ~/ 6;
        if (dx > 0) {
          for (var i = 0; i < dx; i++) {
            if (_index + 1 > widget.images.length - 1) {
              setState(() {
                _index = 0;
              });
            } else {
              setState(() {
                _index++;
              });
            }
          }
        } else {
          for (var i = 0; i < dx.abs(); i++) {
            if (_index - 1 < 0) {
              setState(() {
                _index = widget.images.length - 1;
              });
            } else {
              setState(() {
                _index--;
              });
            }
          }
        }
      },
      child: Image(
        image: widget.images[_index],
        height: 200,
      ),
    );
  }
}
