import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:pancake_resto/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ListMenuPancake extends StatelessWidget {
  final String namaPancake;
  final String deskripsi;
  final String harga;
  final String urlImage;
  final VoidCallback? funcIncr;
  final VoidCallback? funcDecr;
  final Consumer<CartProvider> funcCart;

  const ListMenuPancake(
      {super.key,
      required this.namaPancake,
      required this.deskripsi,
      required this.harga,
      required this.urlImage,
      required this.funcIncr,
      required this.funcDecr,
      required this.funcCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: FancyShimmerImage(
                imageUrl: urlImage,
                boxFit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 150,
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    namaPancake,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    deskripsi,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      height: 1.5,
                      letterSpacing: 0.2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      harga,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          letterSpacing: 0.5,
                          overflow: TextOverflow.ellipsis,
                          wordSpacing: 1.4),
                      maxLines: 2,
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: funcDecr,
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 32,
                        )),
                    funcCart,
                    IconButton(
                        onPressed: funcIncr,
                        icon: const Icon(
                          Icons.add_circle_outlined,
                          color: Colors.green,
                          size: 32,
                        ))
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
