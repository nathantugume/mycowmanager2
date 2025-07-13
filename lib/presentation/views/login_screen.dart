import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycowmanager/presentation/views/dashboard_screen.dart';
import 'package:mycowmanager/presentation/views/register_screen.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Stack(
              children: [
                // Top wave background
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,

                  child: Image.asset(
                    'assets/images/top_bg.png',
                    width: size.width,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),

                // Bottom wave background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/bottom_bg.png',
                    width: size.width,
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),

                // Page content
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // App logo
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            height: 120,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailCtrl,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                ),
                                validator: (v) =>
                                v != null && v.contains('@') ? null : 'Invalid',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.lock),

                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                                validator: (v) => v != null && v.length >= 6
                                    ? null
                                    : 'Min 6 chars',
                              ),
                              const SizedBox(height: 24),
                              if (vm.error != null)
                                Text(
                                  vm.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: vm.isLoading
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    dynamic ok = vm.signIn(
                                      _emailCtrl.text.trim(),
                                      _passwordCtrl.text.trim(),
                                    );

                                    if (ok) {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) =>const DashboardScreen(),));
                                    }
                                  }
                                },
                                child: vm.isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('LOGIN'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                ),
                                child: const Text("Don't have an account? Sign Up"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
