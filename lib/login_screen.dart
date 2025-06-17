import 'package:flutter/material.dart';
import 'reset_password.dart';
import 'cadastro_screen.dart';
import 'recipe_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.restaurant_menu, color: Colors.brown, size: 50),
                    SizedBox(height: 8),
                    Text(
                      'Recip',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                              if (value == null || value.isEmpty) return 'Por favor, insira seu e-mail';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Senha'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Digite sua senha',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.brown[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) => setState(() => rememberMe = value!),
                                activeColor: Colors.brown,
                              ),
                              const Text('Lembrar de mim'),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordScreen()));
                                },
                                child: const Text('Esqueceu a senha?'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => RecipeListScreen()),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  String message = 'Erro ao fazer login';
                                  if (e.code == 'user-not-found') {
                                    message = 'Usuário não encontrado';
                                  } else if (e.code == 'wrong-password') {
                                    message = 'Senha incorreta';
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                }
                              }
                            },
                            child: const Text('Entrar', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não possui conta?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                                },
                                child: const Text('Cadastre-se'),
                              ),
                            ],
                          ),
                          const Divider(),
                          OutlinedButton.icon(
                            icon: Image.asset('google.png', height: 20, width: 20),
                            label: const Text('Entrar com o Google'),
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.brown),
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
