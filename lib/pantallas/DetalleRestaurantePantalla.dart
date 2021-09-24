import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebie/controller.dart';
import 'package:teebie/modelos/Resenia.dart';
import 'package:teebie/modelos/Restaurant.dart';
import 'package:teebie/modelos/TipoComida.dart';

class DetalleRestaurantePantalla extends StatelessWidget {
  final Restaurant restaurante;
  final ControllerJetX c = Get.find();
  DetalleRestaurantePantalla({required this.restaurante});

  Widget alertaResenia() {
    TextEditingController controladorComentario = TextEditingController();
    TextEditingController controladorEmail = TextEditingController();
    var calificacion = 5.obs;
    List<int> listaCalificacion = [
      1,
      2,
      3,
      4,
      5,
    ];

    return AlertDialog(
      title: Text('alerta_escribir_resenia'.tr),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text('comentarios'.tr),
              TextField(
                controller: controladorComentario,
              ),
              Text('correo'.tr),
              TextField(
                controller: controladorEmail,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('calificacion'.tr),
                  Obx(
                    () => DropdownButton(
                      onChanged: (value) {
                        calificacion.value = value as int;
                      },
                      value: calificacion.value,
                      items: listaCalificacion
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.toString(),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controladorEmail.text.isNotEmpty &&
                      controladorComentario.text.isNotEmpty) {
                    await c.subirResenia(
                        restaurantSlug: restaurante.slug,
                        email: controladorEmail.text,
                        comments: controladorComentario.text,
                        rating: calificacion.value);
                    c.traerResenias(restaurantSlug: restaurante.slug);
                    Get.back();
                  }
                },
                child: Text('subir_resenia'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    c.traerResenias(restaurantSlug: restaurante.slug);

    var tiposComida = <TipoComida>[];
    for (var item in restaurante.foodType) {
      for (var item2 in c.tiposComida) {
        if (item2.slug == item) {
          tiposComida.add(item2);
        }
      }
    }
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      appBar: AppBar(
        title: Text(restaurante.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(
                restaurante.logo != null
                    ? restaurante.logo!
                    : 'https://pbs.twimg.com/media/CbDqppJUkAE2Q3S.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                restaurante.description,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              restaurante.rating != null
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          restaurante.rating!
                                              .toStringAsPrecision(2),
                                          style: TextStyle(
                                              color: Colors.brown,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: tiposComida
                                .map(
                                  (element) => Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        element.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    child: ElevatedButton(
                      onPressed: () async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alertaResenia();
                          },
                        );
                      },
                      child: Text('escribir_resenia'.tr),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'resenia'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Obx(
                            () => ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: c.resenias.length,
                              itemBuilder: (context, i) {
                                Resenia resenia = c.resenias[i];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(resenia.email),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              resenia.rating
                                                  .toStringAsPrecision(2),
                                              style: TextStyle(
                                                  color: Colors.brown,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(resenia.comments),
                                    i != restaurante.reviews.length - 1
                                        ? Divider()
                                        : SizedBox.shrink()
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
