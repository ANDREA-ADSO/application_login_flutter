import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../home/home.dart';
import '../user/form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _registeredUsername;
  String? _registeredPassword;

  @override
  void initState() {
    super.initState();
    _usernameController.text = _registeredUsername ?? '';
    _passwordController.text = _registeredPassword ?? '';
  }

  void _navigateToRegister() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserFormScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _registeredUsername = result['username'];
        _registeredPassword = result['password'];
        _usernameController.text = _registeredUsername ?? '';
        _passwordController.text = _registeredPassword ?? '';
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado exitosamente')),
      );
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: username,
            password: password,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Iniciar Sesión'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logos/stamp.webp',
                height: 100,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  // Expresión regular para validar el formato de email
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Por favor ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  // Validaciones para la contraseña
                  if (value.length < 8 || value.length > 16) {
                    return 'La contraseña debe tener entre 8 y 16 caracteres';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'Debe contener al menos una mayúscula';
                  }
                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return 'Debe contener al menos una minúscula';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'Debe contener al menos un dígito';
                  }
                  if (!RegExp(r'[^a-zA-Z0-9]').hasMatch(value)) {
                    return 'Debe contener al menos un carácter no alfanumérico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Ingresar'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _navigateToRegister,
                child: const Text('¿No tienes cuenta? Regístrate aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
