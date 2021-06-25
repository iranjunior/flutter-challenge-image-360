import 'package:flutter/material.dart';
import 'package:image_360/widgets/image_360.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;
  List<ImageProvider> images = [];

  @override
  void initState() {
    // Deixa a seguencia de imagens precarregadas no app
    WidgetsBinding.instance!
    .addPostFrameCallback((_) => loadImages(context));
    super.initState();
  }

  void loadImages(BuildContext c) async {
    for (int i = 1; i <= 52; i++) {
      // adiciona as imagens numa numa lista de imagem
      images
      .add(AssetImage('assets/car/$i.png'));
      // pre carrega as imagens
      await precacheImage(AssetImage('assets/car/$i.png'), c);
    }
    setState(() {
      // indica finalização do carregamento das imagens
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _loading
                ? Expanded(
                    child: Image360(
                      // Passa uma unique Key para o componente
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
      ),
    );
  }
}