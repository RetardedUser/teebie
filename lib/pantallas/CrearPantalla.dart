import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebie/controller.dart';
import 'package:teebie/modelos/TipoComida.dart';

class CrearPantalla extends StatelessWidget {
  final bool restaurante;
  CrearPantalla({this.restaurante = true});

  @override
  Widget build(context) {
    ControllerJetX controllerJetX = Get.find();
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    var tiposComidaSeleccionados = <TipoComida>[].obs;
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      appBar: AppBar(
        title: Text('crear'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('nombre'.tr),
                TextField(
                  maxLength: 32,
                  controller: nameController,
                ),
                SizedBox(
                  height: 10,
                ),
                restaurante
                    ? Column(
                        children: [
                          Text('descripcion'.tr),
                          TextField(
                            controller: descriptionController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => DropdownButton(
                              onChanged: (value) {
                                if (!tiposComidaSeleccionados.contains(value)) {
                                  tiposComidaSeleccionados
                                      .add(value as TipoComida);
                                }
                              },
                              value: controllerJetX.tiposComida.first,
                              items: controllerJetX.tiposComida
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e.name,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => Wrap(
                              alignment: WrapAlignment.center,
                              children: tiposComidaSeleccionados
                                  .map(
                                    (element) => InkWell(
                                      onTap: () => tiposComidaSeleccionados
                                          .remove(element),
                                      child: Container(
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
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                element.name,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () async {
                    if (restaurante &&
                        nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      var foodTypes = tiposComidaSeleccionados
                          .map((element) => element.slug)
                          .toList();
                      await controllerJetX.subirRestaurante(
                          name: nameController.text,
                          description: descriptionController.text,
                          foodTypes: foodTypes);
                      controllerJetX.traerRestaurantes();
                      Get.back();
                    } else if (!restaurante && nameController.text.isNotEmpty) {
                      await controllerJetX.subirTipoComida(
                          name: nameController.text);
                      controllerJetX.traerTiposComida();
                      Get.back();
                    }
                  },
                  child: Text('crear'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
