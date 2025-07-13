
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycowmanager/presentation/viewmodels/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Register'),),
      body: LayoutBuilder(builder:
      (context, constraints)=>
      SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child:   Stack(
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
                  height: 150,
                ),
              ),

              // Page content
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 14),

                    // App logo
                    Align(
                      alignment: Alignment.topLeft,
                      child:  Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 120,
                        ),
                      ),

                    ),

                 //   const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(labelText: 'Full Name',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.person)
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(labelText: 'Email',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.email)),
                              validator: (v) => v != null && v.contains('@') ? null : 'Invalid',
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(labelText: 'Phone',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.phone)),
                              validator: (v) => v != null && v.length >= 9 ? null : 'Invalid',
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(labelText: 'Password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.lock)),
                              validator: (v) => v != null && v.length >= 6 ? null : 'Min 6',
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(labelText: 'Confirm Password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.lock)),
                              validator: (v) => v == _passwordCtrl.text ? null : 'Mismatch',
                            ),
                            const SizedBox(height: 24),
                            if (vm.error != null)
                              Text(vm.error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: vm.isLoading
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  vm.signUp(
                                    name: _nameCtrl.text.trim(),
                                    email: _emailCtrl.text.trim(),
                                    phone: _phoneCtrl.text.trim(),
                                    password: _passwordCtrl.text.trim(),
                                  );
                                }
                              },
                              child: vm.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('CREATE ACCOUNT'),
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


      ),))


    );
  }
}

