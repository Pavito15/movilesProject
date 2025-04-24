import 'package:flutter/material.dart';
import 'package:project_v1/provider/cardProvider.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/buttons/primary_button.dart';


class PaymentScreen extends StatefulWidget {
  final double totalCompra; // Se recibe el total de la compra

  const PaymentScreen({super.key, required this.totalCompra});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();

  String? _selectedCountry;
  final List<String> _countries = ['Canadá', 'México', 'EE.UU.'];

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Mostrar alerta de confirmación
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pago exitoso"),
            content: const Text("El producto ha sido pagado correctamente."),
            actions: [
              TextButton(
                onPressed: () {
                  // Vaciar el carrito
                  Provider.of<CartProvider>(context, listen: false).clearCart();
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  Navigator.of(context).pop(); // Regresar a la pantalla anterior
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Pago"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Entrega",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Nombre
              const Text("Nombre Completo"),
              CustomTextField(
                labelText: "Ingresa tu nombre",
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 15),

              // Selección de país
              const Text("País"),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Selecciona un país" : null,
              ),
              const SizedBox(height: 15),

              // Dirección
              const Text("Dirección"),
              CustomTextField(
                labelText: "Ingresa tu dirección",
                controller: _addressController,
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 15),

              // Código postal
              const Text("Código Postal"),
              CustomTextField(
                labelText: "Ingresa tu código postal",
                controller: _zipController,
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 15),

              // Número de teléfono
              const Text("Teléfono"),
              CustomTextField(
                labelText: "Ingresa tu número de teléfono",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 15),

              // Ciudad
              const Text("Ciudad"),
              CustomTextField(
                labelText: "Ingresa tu ciudad",
                controller: _cityController,
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 15),

              // Estado
              const Text("Estado"),
              CustomTextField(
                labelText: "Ingresa tu estado",
                controller: _stateController,
                validator: (value) =>
                    value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 20),

              // Sección desplegable para tarjeta de crédito
              ExpansionTile(
                title: const Text(
                  "Añadir tarjeta de crédito",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  const Text("Número de tarjeta"),
                  CustomTextField(
                    labelText: "Ingresa el número de tarjeta",
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Este campo es obligatorio" : null,
                  ),
                  const SizedBox(height: 15),

                  const Text("Fecha de expiración"),
                  CustomTextField(
                    labelText: "MM/AA",
                    controller: _expiryDateController,
                    keyboardType: TextInputType.datetime,
                    validator: (value) =>
                        value!.isEmpty ? "Este campo es obligatorio" : null,
                  ),
                  const SizedBox(height: 15),

                  const Text("CVV"),
                  CustomTextField(
                    labelText: "Código de seguridad",
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Este campo es obligatorio" : null,
                  ),
                  const SizedBox(height: 15),

                  const Text("Nombre del titular"),
                  CustomTextField(
                    labelText: "Ingresa el nombre del titular",
                    controller: _cardHolderNameController,
                    validator: (value) =>
                        value!.isEmpty ? "Este campo es obligatorio" : null,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              const SizedBox(height: 20),

              // Total de compra
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("\$${widget.totalCompra.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botón de pago
              PrimaryButton(
                text: "Pagar",
                onPressed: _processPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}