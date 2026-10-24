import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gastos_controller.dart';
import '../theme/app_theme.dart';

/// Fila de chips para filtrar los gastos por categoría. «Todas» muestra la
/// lista completa; cada otro chip corresponde a una categoría que de verdad
/// aparece en los gastos cargados (`GastosController.categoriasConGastos`).
///
/// La selección vive en el controller, no aquí: así la pantalla y el filtro
/// leen el mismo estado y el widget se queda sin lógica propia.
class FiltroCategorias extends GetView<GastosController> {
  const FiltroCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seleccionada = controller.categoriaFiltro.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            _chip(etiqueta: 'Todas', categoria: '', seleccionada: seleccionada),
            for (final categoria in controller.categoriasConGastos)
              _chip(etiqueta: categoria, categoria: categoria, seleccionada: seleccionada),
          ],
        ),
      );
    });
  }

  Widget _chip({
    required String etiqueta,
    required String categoria,
    required String seleccionada,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(etiqueta),
        selected: seleccionada == categoria,
        // Por qué se filtra también al «deseleccionar»: el filtro siempre tiene
        // un valor; volver a tocar el chip activo no debe dejar la fila sin
        // ninguna opción marcada.
        onSelected: (_) => controller.filtrarPorCategoria(categoria),
      ),
    );
  }
}
