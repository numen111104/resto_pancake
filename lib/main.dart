import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:open_whatsapp/open_whatsapp.dart';
import 'package:pancake_resto/const/variabels.dart';
import 'package:pancake_resto/model/pancake_resto_model.dart';
import 'package:pancake_resto/provider/cart_provider.dart';
import 'package:pancake_resto/widgets/menu_pancake.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            primaryColor: Colors.green,
            fontFamily: GoogleFonts.poppins().fontFamily),
        title: 'Resto Aplication',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController orderName = TextEditingController();
  TextEditingController orderTable = TextEditingController();

  void openDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                height: 266,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('Masukkan Informasi Pesanan'),
                    const SizedBox(height: 15),
                    TextField(
                      controller: orderName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        prefixIcon: Icon(Icons.person, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: orderTable,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nomor Meja',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        prefixIcon:
                            Icon(Icons.table_bar_outlined, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Consumer<CartProvider>(builder: (context, value, _) {
                      String strPesanan = '';
                      for (var element in value.cart) {
                        strPesanan +=
                            "\n ${element.name} : ${element.quantity}";
                      }
                      return ElevatedButton(
                          onPressed: () async {
                            String phone = "6285716895658";
                            String pesanan =
                                "Nama: ${orderName.text}\n Nomor Meja: ${orderTable.text}\n\n Pesanan: -$strPesanan";
                            FlutterOpenWhatsapp.sendSingleMessage(
                                phone, pesanan);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green)),
                          child: const Text("Pesan Sekarang",
                              style: TextStyle(color: Colors.white)));
                    }),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pancake Resto'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: openDialog,
        child: badges.Badge(
          badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
          badgeContent: Consumer<CartProvider>(
            builder: (context, value, _) {
              return Text(
                value.total > 0 ? value.total.toString() : '',
                style: const TextStyle(color: Colors.white, fontSize: 12.5),
              );
            },
          ),
          child: const Icon(
            Icons.shopping_bag_sharp,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      body: const ListMenuResto(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    orderName.dispose();
    orderTable.dispose();
  }
}

class ListMenuResto extends StatefulWidget {
  const ListMenuResto({super.key});

  @override
  State<ListMenuResto> createState() => _ListMenuRestoState();
}

class _ListMenuRestoState extends State<ListMenuResto> {
  Future<List<RestoPancake>> fetchData() async {
    List<RestoPancake> listPancake = [];
    final response = await http.get(Uri.parse(baseApi));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      for (var e in data) {
        listPancake.add(RestoPancake.fromMap(e));
      }
    } else {
      throw Exception('Failed to load data');
    }
    return listPancake;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RestoPancake>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
            ));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                await fetchData();
              },
              color: Colors.green,
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListMenuPancake(
                      key: ValueKey(snapshot.data![index].id.toString()),
                      namaPancake: snapshot.data![index].name,
                      deskripsi: snapshot.data![index].description,
                      harga:
                          convertRpToK(snapshot.data![index].price.toString()),
                      urlImage: snapshot.data![index].image,
                      funcDecr: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addRemoveCart(snapshot.data![index].name,
                                snapshot.data![index].id, false);
                      },
                      funcIncr: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addRemoveCart(snapshot.data![index].name,
                                snapshot.data![index].id, true);
                      },
                      funcCart:
                          Consumer<CartProvider>(builder: (context, value, _) {
                        var id = value.cart.indexWhere((element) =>
                            element.menuId == snapshot.data![index].id);
                        return Text(
                          (id == -1) ? '0' : value.cart[id].quantity.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              letterSpacing: 0.5,
                              overflow: TextOverflow.ellipsis,
                              wordSpacing: 1.4),
                          maxLines: 2,
                        );
                      }),
                    );
                  }),
            );
          }
        });
  }

  String convertRpToK(String input) {
    RegExp regex = RegExp(r'(\d+)(\.\d+)?');
    RegExpMatch? match = regex.firstMatch(input);
    if (match != null) {
      double angka = double.parse(match.group(0)!);
      if (angka >= 1000) {
        int ribuan = (angka / 1000).round();
        return '${ribuan}k';
      } else {
        return match.group(0)!;
      }
    }
    return input; // Kembalikan input jika tidak ada angka dalam string
  }
}
