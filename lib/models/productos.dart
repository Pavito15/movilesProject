

class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
  });
  final int id;
  final String nombre;  
  final double precio;
  final String imagen;
  final String descripcion;
}