import 'package:flutter/material.dart';


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
        // Cria um fator de sensibilidade
        final factorSensibility = 6;
        // coleta avariação no movimento
        final dx = update.delta.dx ~/ factorSensibility;
        // verifica se o movimento foi para direita
        if (dx > 0) {
          swipeToRight(dx);
        } else {
          swipeToLeft(dx);
        }
      },
      child: Image(
        image: widget.images[_index],
        height: 200,
      ),
    );
  }

  swipeToRight(int dx) {
    // percorre a variação
    for (var i = 0; i < dx; i++) {
      // verifica se o array de imagens chegou ao fim
      // se sim determina que a proxima imagem será a primeira
      if (_index + 1 > widget.images.length - 1) {
        setState(() {
          _index = 0;
        });
      } else {
        // caso contrario avança nas imagens
        setState(() {
          _index++;
        });
      }
    }
  }

  swipeToLeft(int dx) {
    // percorre a variação
    for (var i = 0; i < dx.abs(); i++) {
      // verifica se o array de imagens chegou ao inicio
      // se sim determina que a proxima imagem será a ultima
      if (_index - 1 < 0) {
        setState(() {
          _index = widget.images.length - 1;
        });
      } else {
        // caso contratio retrocesse nas imagens
        setState(() {
          _index--;
        });
      }
    }
  }
}
