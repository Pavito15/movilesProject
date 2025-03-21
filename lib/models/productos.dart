class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    this.stock, // Ahora es opcional
  });
  final int id;
  final String nombre;  
  final double precio;
  final String imagen;
  final String descripcion;
  final int? stock; // Declarado como nullable
}
