import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Servidor falso con lo justo para abrir la pantalla Gastos con sesión
/// iniciada: token, usuario, categorías y una lista fija de gastos. No
/// necesita el backend ni el emulador (mismo patrón que `sesion_08_test`).
class _Servidor implements HttpClientAdapter {
  static const gastos = [
    {'id': 1, 'descripcion': 'Almuerzo en el Mercado Central', 'monto': 6.5, 'categoria': 'comida', 'fecha': '2026-10-20'},
    {'id': 2, 'descripcion': 'Taxi al aeropuerto', 'monto': 12.0, 'categoria': 'transporte', 'fecha': '2026-10-21'},
    {'id': 3, 'descripcion': 'Encebollado', 'monto': 3.0, 'categoria': 'comida', 'fecha': '2026-10-22'},
  ];

  ResponseBody _json(Object? cuerpo, int codigo, [Map<String, List<String>> h = const {}]) =>
      ResponseBody.fromString(jsonEncode(cuerpo), codigo,
          headers: {Headers.contentTypeHeader: ['application/json'], ...h});

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? cuerpo, Future<void>? cancelar) async {
    switch (o.path) {
      case '/usuarios/token':
        return _json({'access_token': 'tok-a@b.com', 'token_type': 'bearer'}, 200);
      case '/usuarios/me':
        return _json({'id': 1, 'email': 'a@b.com'}, 200);
      case '/gastos/categorias':
        return _json({'categorias': ['comida', 'transporte', 'entretenimiento', 'otros'], 'limite_por_categoria': 500.0}, 200);
      case '/gastos/':
        return _json(gastos, 200, {'x-total-count': ['${gastos.length}']});
    }
    return _json({'detail': 'ruta no prevista en la prueba: ${o.path}'}, 404);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => Hive.init(Directory.systemTemp.createTempSync('hive_filtro').path));

  /// Alterna tiempo real (para las «peticiones» falsas y el disco) con avance
  /// del reloj de la prueba, igual que en `sesion_09_test`.
  Future<void> esperarRed(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 40));
    }
  }

  Future<void> abrirGastos(WidgetTester tester) async {
    await tester.runAsync(() async {
      Get.reset();
      Get.testMode = true;
      await Hive.deleteFromDisk();
      FlutterSecureStorage.setMockInitialValues({});
      Get.put(ApiClient(dio: Dio(BaseOptions(baseUrl: 'http://prueba'))..httpClientAdapter = _Servidor()));
      final auth = Get.put(AuthController());
      await auth.iniciarSesion('a@b.com', 'clave-1234');
      Get.put(GastosController());
    });
    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await esperarRed(tester);
  }

  testWidgets('elegir «comida» deja solo los gastos de comida', (tester) async {
    await abrirGastos(tester);

    // Sin filtro se ven los tres gastos.
    expect(find.text('Almuerzo en el Mercado Central'), findsOneWidget);
    expect(find.text('Encebollado'), findsOneWidget);
    expect(find.text('Taxi al aeropuerto'), findsOneWidget);

    // El chip «comida» está en la fila de filtros (no en los subtítulos, que
    // llevan además la fecha), así que se busca dentro del ChoiceChip.
    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pumpAndSettle();

    expect(find.text('Almuerzo en el Mercado Central'), findsOneWidget);
    expect(find.text('Encebollado'), findsOneWidget);
    expect(find.text('Taxi al aeropuerto'), findsNothing);
  });

  testWidgets('«Todas» vuelve a mostrar todos los gastos', (tester) async {
    await abrirGastos(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'transporte'));
    await tester.pumpAndSettle();
    expect(find.text('Almuerzo en el Mercado Central'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pumpAndSettle();
    expect(find.text('Almuerzo en el Mercado Central'), findsOneWidget);
    expect(find.text('Taxi al aeropuerto'), findsOneWidget);
  });
}
