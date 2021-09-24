import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebie/Traducciones.dart';
import 'package:teebie/controller.dart';
import 'package:teebie/pantallas/CrearPantalla.dart';
import 'package:teebie/pantallas/TiposComidaPantalla.dart';
import 'package:teebie/widgets/ElementoRestauranteLista.dart';

void main() {
  final ControllerJetX c = Get.put(ControllerJetX());
  c.traerRestaurantes();
  c.traerTiposComida();
  runApp(
    GetMaterialApp(
      translations: Traducciones(),
      locale: Locale('es', 'MX'),
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    ControllerJetX c = Get.find();
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text('traducir'.tr),
                trailing: Icon(Icons.language),
                onTap: () {
                  c.cambiarIdioma();
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('filtrar'.tr, style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => DropdownButton<String>(
                    onChanged: (value) {
                      c.filtroSeleccionado.value = value as String;
                      c.traerRestaurantes(
                          foodTypeSlug: c.filtroSeleccionado.value);
                    },
                    value: c.filtroSeleccionado.value,
                    items: c.tiposComida
                        .map(
                          (element) => DropdownMenuItem(
                            value: element.slug,
                            child: Text(element.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'tipos_comida'.tr,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('crear'.tr),
                onTap: () => Get.to(
                  () => CrearPantalla(restaurante: false),
                ),
              ),
              ListTile(
                title: Text(
                  'editar'.tr,
                ),
                onTap: () async {
                  c.traerTiposComida();
                  c.modo.value = ModosAdmin.editar;
                  await Get.to(
                    () => TiposComidaPantalla(),
                  );
                  c.modo.value = ModosAdmin.visualizar;
                },
              ),
              ListTile(
                title: Text(
                  'eliminar'.tr,
                ),
                onTap: () async {
                  c.traerTiposComida();
                  c.modo.value = ModosAdmin.eliminar;
                  await Get.to(
                    () => TiposComidaPantalla(),
                  );
                  c.modo.value = ModosAdmin.visualizar;
                },
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'restaurantes'.tr,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'crear'.tr,
                ),
                onTap: () => Get.to(
                  () => CrearPantalla(restaurante: true),
                ),
              ),
              ListTile(
                title: Text(
                  'editar'.tr,
                ),
                onTap: () {
                  c.modo.value = ModosAdmin.editar;
                  Get.back();
                },
              ),
              ListTile(
                title: Text(
                  'eliminar'.tr,
                ),
                onTap: () {
                  c.modo.value = ModosAdmin.eliminar;
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFf7f7f7),
      appBar: AppBar(
        title: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c.modo.value == ModosAdmin.visualizar
                    ? 'restaurantes'.tr
                    : c.modo.value == ModosAdmin.editar
                        ? 'editar'.tr + ' ' + 'restaurantes'.tr
                        : 'eliminar'.tr + ' ' + 'restaurantes'.tr),
                GestureDetector(
                  onTap: () {
                    c.modo.value = ModosAdmin.visualizar;
                  },
                  child: c.modo.value == ModosAdmin.visualizar
                      ? SizedBox.shrink()
                      : Icon(Icons.cancel_outlined),
                ),
              ],
            )),
      ),
      body: Obx(
        () => c.restaurantes.isNotEmpty
            ? ListView.builder(
                itemCount: c.restaurantes.length,
                itemBuilder: (context, i) {
                  return ElementoRestauranteLista(
                      restaurante: c.restaurantes[i]);
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
