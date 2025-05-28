import 'package:flutter/material.dart';
import 'confirmacao_email.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Logo
                const Icon(Icons.restaurant_menu, color: Colors.brown, size: 50),
                const SizedBox(height: 8),
                const Text(
                  'Recip',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Redefinir senha',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          const Text('E-mail'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Digite seu e-mail',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.brown[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, preencha seu e-mail';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Você receberá um e-mail para redefinir sua senha.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ResetEmailSentScreen(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Enviar',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
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
