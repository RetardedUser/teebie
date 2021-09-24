import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:teebie/modelos/Resenia.dart';
import 'package:teebie/modelos/Restaurant.dart';
import 'package:teebie/modelos/TipoComida.dart';

enum ModosAdmin { editar, eliminar, visualizar }

class ControllerJetX extends GetxController {
  var modo = ModosAdmin.visualizar.obs;
  var restaurantes = <Restaurant>[].obs;
  var resenias = <Resenia>[].obs;
  var tiposComida = <TipoComida>[].obs;
  var filtroSeleccionado = RxString('');
  String languageCode = 'es';

  void cambiarIdioma() {
    if (Get.locale!.languageCode == 'es') {
      languageCode = 'en';
      Get.updateLocale(Locale('en', 'US'));
    } else {
      languageCode = 'es';
      Get.updateLocale(Locale('es', 'MX'));
    }
  }

  void traerRestaurantes({String? foodTypeSlug}) async {
    print(foodTypeSlug);

    var url = foodTypeSlug == null
        ? Uri.parse('https://tellurium.behuns.com/api/restaurants/')
        : Uri.parse(
            'https://tellurium.behuns.com/api/restaurants/?food_type__slug=$foodTypeSlug');

    var response = await http.get(url, headers: {
      'accept': 'application/json',
      'accept-language': languageCode
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      restaurantes.clear();
      var decoded = jsonDecode(response.body);
      for (var item in decoded) {
        restaurantes.add(Restaurant.fromJson(item));
      }
    }
  }

  void traerResenias({String? restaurantSlug}) async {
    resenias.clear();

    var url = Uri.parse(
        'https://tellurium.behuns.com/api/restaurants/$restaurantSlug/');
    var response = await http.get(url, headers: {
      'accept': 'application/json',
      'accept-language': languageCode
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      var restaurant = Restaurant.fromJson(decoded);
      for (var item in restaurant.reviews) {
        resenias.add(Resenia.fromJson(item));
      }
    }
  }

  void traerTiposComida() async {
    tiposComida.clear();
    var url = Uri.parse('https://tellurium.behuns.com/api/food_types/');
    var response = await http.get(url, headers: {
      'accept': 'application/json',
      'accept-language': languageCode
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      for (var item in decoded) {
        tiposComida.add(TipoComida.fromJson(item));
      }
      filtroSeleccionado.value = tiposComida.first.slug;
    }
  }

  Future<void> subirRestaurante({
    required String name,
    required String description,
    required List<String> foodTypes,
  }) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/restaurants/');

    var response = await http.post(
      url,
      body: {
        "name": name,
        "description": description,
        "food_type": jsonEncode(foodTypes),
      },
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> actualizarRestaurante({
    required String name,
    required String description,
    required List<String> foodType,
    required String slug,
  }) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/restaurants/$slug/');
    var response = await http.patch(
      url,
      body: {
        "name": name,
        "description": description,
        "food_type": foodType.first,
      },
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> eliminarRestaurante({
    required String slug,
  }) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/restaurants/$slug/');

    var response = await http.delete(
      url,
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> subirResenia(
      {required String restaurantSlug,
      required String email,
      required String comments,
      required int rating}) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/reviews/');
    var response = await http.post(
      url,
      body: {
        "restaurant": restaurantSlug,
        "email": email,
        "comments": comments,
        "rating": rating.toString()
      },
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> subirTipoComida({
    required String name,
  }) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/food_types/');
    var response = await http.post(
      url,
      body: {
        "name": name,
      },
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> actualizarTipoComida({
    required String name,
    required String slug,
  }) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/food_types/$slug/');
    var response = await http.patch(
      url,
      body: {
        "name": name,
      },
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> eliminarTipoComida({
    required String slug,
  }) async {
    var url = Uri.parse('https://tellurium.behuns.com/api/food_types/$slug/');

    var response = await http.delete(
      url,
      headers: {'accept': 'application/json', 'accept-language': languageCode},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
