import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebie/controller.dart';
import 'package:teebie/widgets/ElementoTipoComidaLista.dart';

class TiposComidaPantalla extends StatelessWidget {
  @override
  Widget build(context) {
    ControllerJetX c = Get.find();

    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      appBar: AppBar(
        title: Text(c.modo.value == ModosAdmin.visualizar
            ? 'tipos_comida'.tr
            : c.modo.value == ModosAdmin.editar
                ? 'editar'.tr + ' ' + 'tipos_comida'.tr
                : 'eliminar'.tr + ' ' + 'tipos_comida'.tr),
      ),
      body: Obx(
        () => c.tiposComida.isNotEmpty
            ? ListView.builder(
                itemCount: c.tiposComida.length,
                itemBuilder: (context, i) {
                  return ElementoTipoComidaLista(tipoComida: c.tiposComida[i]);
                },
              )
            : Center(
                child: Text(
                  'no_resultados'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
