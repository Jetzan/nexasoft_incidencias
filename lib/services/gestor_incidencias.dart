import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  AlmacenLocal? _datos;
  AlmacenLocal get datos => _datos ??= AlmacenLocal();
  List<Incidencia> incidencias = [];
  int cantidadPendientes = 0;

  Future<void> iniciar() async {
    incidencias = await datos.leer();
    cantidadPendientes =
        incidencias.where((x) => x.estado == 'Pendiente').length;
  }

  List<Incidencia> buscar(
    String texto, {
    String? estado,
    Prioridad? prioridad,
  }) {
    final consulta = texto.trim().toLowerCase();

    return incidencias.where((x) {
      final titulo = x.titulo.toLowerCase();
      final descripcion = x.descripcion.toLowerCase();

      final coincideTexto = consulta.isEmpty ||
          titulo.contains(consulta) ||
          descripcion.contains(consulta);
      final coincideEstado = estado == null || x.estado == estado;
      final coincidePrioridad = prioridad == null || x.prioridad == prioridad;

      return coincideTexto && coincideEstado && coincidePrioridad;
    }).toList();
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  int contar(String estado) {
    if (estado == 'Pendiente') return cantidadPendientes;
    return incidencias.where((x) => x.estado == estado).length;
  }

  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        final estadoAnterior = incidencias[i].estado;
        incidencias[i].estado = estado;

        try {
          await datos.guardar(incidencias);
        } catch (_) {
          incidencias[i].estado = estadoAnterior;
          rethrow;
        }

        // cantidadPendientes se mantiene en memoria y alimenta el resumen.
        if (estadoAnterior == 'Pendiente' && estado != 'Pendiente') {
          cantidadPendientes--;
        } else if (estadoAnterior != 'Pendiente' && estado == 'Pendiente') {
          cantidadPendientes++;
        }
        return;
      }
    }
  }

  Future<void> crear(String titulo, String descripcion, String cliente,
      String categoria, Prioridad prioridad) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      prioridad: prioridad,
      fecha: DateTime.now().toIso8601String().split('T').first,
    );
    incidencias.insert(0, nuevo);
    cantidadPendientes++;
    await datos.guardar(incidencias);
  }

  Future<void> cambiarPrioridad(String id, Prioridad prioridad) async {
  for (final incidencia in incidencias) {
    if (incidencia.id == id) {
      final prioridadAnterior = incidencia.prioridad;
      incidencia.prioridad = prioridad;

      try {
        await datos.guardar(incidencias);
      } catch (_) {
        incidencia.prioridad = prioridadAnterior;
        rethrow;
      }
      return;
    }
  }
}

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
