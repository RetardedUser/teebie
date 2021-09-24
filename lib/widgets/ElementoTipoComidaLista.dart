import 'package:flutter/material.dart';
import 'package:teebie/controller.dart';
import 'package:get/get.dart';
import 'package:teebie/modelos/TipoComida.dart';
import 'package:teebie/pantallas/EditarPantalla.dart';

class ElementoTipoComidaLista extends StatelessWidget {
  final TipoComida tipoComida;
  ElementoTipoComidaLista({
    required this.tipoComida,
  });

  void alertaEliminar(
      ControllerJetX controllerJetX, BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('alerta_eliminar'.tr + ' ${tipoComida.name}'),
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
                      await controllerJetX.eliminarTipoComida(
                          slug: tipoComida.slug);
                      controllerJetX.traerTiposComida();
                      Get.back();
                    },
                    child: Text(
                      ('eliminar'.tr).toUpperCase(),
                    ),
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
                restaurante: false,
                objetoEditable: tipoComida,
              ),
            );
            break;
          case ModosAdmin.eliminar:
            alertaEliminar(controllerJetX, context);
            break;
          default:
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
          child: Text(
            tipoComida.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
