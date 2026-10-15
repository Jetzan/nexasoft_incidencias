enum Prioridad {
  baja,
  media,
  alta;

  String get etiqueta {
    switch (this) {
      case Prioridad.baja:
        return 'Baja';
      case Prioridad.media:
        return 'Media';
      case Prioridad.alta:
        return 'Alta';
    }
  }

  static Prioridad desdeJson(Object? valor) {
    switch (valor?.toString().trim().toLowerCase()) {
      case 'baja':
        return Prioridad.baja;
      case 'media':
        return Prioridad.media;
      case 'alta':
        return Prioridad.alta;
      default:
        return Prioridad.media;
    }
  }
}



class Incidencia {
  String id;
  String titulo;
  String descripcion;
  String cliente;
  String categoria;
  String estado;
  String fecha;
  Prioridad prioridad;

  Incidencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.cliente,
    required this.categoria,
    required this.estado,
    required this.fecha,
    this.prioridad = Prioridad.media,
  });

  factory Incidencia.desdeJson(Map<String, dynamic> m) {
    return Incidencia(
      id: m['id']?.toString() ?? '',
      titulo: m['titulo']?.toString() ?? '',
      descripcion: m['descripcion']?.toString() ?? '',
      cliente: m['cliente']?.toString() ?? '',
      categoria: m['categoria']?.toString() ?? 'Software',
      estado: m['estado']?.toString() ?? 'Pendiente',
      fecha: m['fecha']?.toString() ?? '',
      prioridad: Prioridad.desdeJson(m['prioridad']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'cliente': cliente,
      'categoria': categoria,
      'estado': estado,
      'fecha': fecha,
      'prioridad': prioridad.etiqueta,
    };
  }
}
