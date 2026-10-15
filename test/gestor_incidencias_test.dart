import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/model/incidencia.dart';
import 'package:nexasoft_incidencias/services/gestor_incidencias.dart';

void main() {
  test('combina búsqueda, estado y prioridad', () {
    final gestor = GestorIncidencias()
      ..incidencias = [
        _incidencia(
          'INC-1',
          'Error de red',
          'Sin conexión',
          'Pendiente',
          Prioridad.alta,
        ),
        _incidencia(
          'INC-2',
          'Error de red',
          'Sin conexión',
          'Pendiente',
          Prioridad.media,
        ),
        _incidencia(
          'INC-3',
          'Error de red',
          'Sin conexión',
          'En proceso',
          Prioridad.alta,
        ),
        _incidencia(
          'INC-4',
          'Error de pantalla',
          'Sin conexión',
          'Pendiente',
          Prioridad.alta,
        ),
      ];

    final resultado = gestor.buscar(
      'red',
      estado: 'Pendiente',
      prioridad: Prioridad.alta,
    );

    expect(resultado.map((incidencia) => incidencia.id), ['INC-1']);
  });

  test('sin filtros devuelve todas las incidencias', () {
    final gestor = GestorIncidencias()
      ..incidencias = [
        _incidencia('INC-1', 'Primera', 'Detalle', 'Pendiente', Prioridad.baja),
        _incidencia('INC-2', 'Segunda', 'Detalle', 'Resuelta', Prioridad.alta),
      ];

    expect(gestor.buscar('').length, 2);
  });
}

Incidencia _incidencia(
  String id,
  String titulo,
  String descripcion,
  String estado,
  Prioridad prioridad,
) {
  return Incidencia(
    id: id,
    titulo: titulo,
    descripcion: descripcion,
    cliente: 'Cliente',
    categoria: 'Software',
    estado: estado,
    fecha: '2026-10-15',
    prioridad: prioridad,
  );
}
