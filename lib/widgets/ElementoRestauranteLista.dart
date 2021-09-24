import 'package:flutter/material.dart';
import 'package:teebie/controller.dart';
import 'package:teebie/modelos/Restaurant.dart';
import 'package:get/get.dart';
import 'package:teebie/pantallas/DetalleRestaurantePantalla.dart';
import 'package:teebie/pantallas/EditarPantalla.dart';

class ElementoRestauranteLista extends StatelessWidget {
  final Restaurant restaurante;
  ElementoRestauranteLista({required this.restaurante});

  void alertaEliminar(
      ControllerJetX controllerJetX, BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('alerta_eliminar'.tr + ' ${restaurante.name}'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          content: Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controllerJetX.eliminarRestaurante(
                          slug: restaurante.slug);
                      controllerJetX.traerRestaurantes();
                      Get.back();
                    },
                    child: Text(('eliminar'.tr).toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ControllerJetX controllerJetX = Get.find();
    return GestureDetector(
      onTap: () async {
        switch (controllerJetX.modo.value) {
          case ModosAdmin.editar:
            Get.to(
              () => EditarPantalla(
                restaurante: true,
                objetoEditable: restaurante,
              ),
            );
            break;
          case ModosAdmin.eliminar:
            alertaEliminar(controllerJetX, context);
            break;
          case ModosAdmin.visualizar:
            Get.to(
              () => DetalleRestaurantePantalla(restaurante: restaurante),
            );
            break;
        }
      },
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurante.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(restaurante.description),
                ],
              ),
              restaurante.rating != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          restaurante.rating!.toStringAsPrecision(2),
                          style: TextStyle(
                              color: Colors.brown, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
