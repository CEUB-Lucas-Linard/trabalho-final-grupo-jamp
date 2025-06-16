import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarReceitaScreen extends StatefulWidget {
  @override
  _AdicionarReceitaScreenState createState() => _AdicionarReceitaScreenState();
}

class _AdicionarReceitaScreenState extends State<AdicionarReceitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();
  final noteController = TextEditingController();
  final imageUrlController = TextEditingController();

  String? selectedCategory;

  void salvarReceita() async {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      // Converte texto em lista de strings separadas por linha
      List<String> ingredientsList = ingredientsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      List<String> stepsList = stepsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await FirebaseFirestore.instance.collection('receitas').add({
        'title': titleController.text.trim(),
        'ingredients': ingredientsList,
        'steps': stepsList,
        'note': noteController.text.trim(),
        'image': imageUrlController.text.trim(),
        'category': selectedCategory!,
        'isFavorite': false,
        'createdAt': Timestamp.now(),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Receita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) =>
                  value!.isEmpty ? 'Digite o título' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: ingredientsController,
                  decoration: InputDecoration(
                      labelText: 'Ingredientes (1 por linha)'),
                  maxLines: null,
                  validator: (value) =>
                  value!.isEmpty ? 'Digite os ingredientes' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: stepsController,
                  decoration:
                  InputDecoration(labelText: 'Passo a passo (1 por linha)'),
                  maxLines: null,
                  validator: (value) =>
                  value!.isEmpty ? 'Digite o passo a passo' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: 'Anotação'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'URL da imagem'),
                  validator: (value) =>
                  value!.isEmpty ? 'Informe o link da imagem' : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: [
                    DropdownMenuItem(
                        value: 'Sobremesa', child: Text('Sobremesa')),
                    DropdownMenuItem(
                        value: 'Prato Principal',
                        child: Text('Prato Principal')),
                    DropdownMenuItem(
                        value: 'Vegetariano', child: Text('Vegetariano')),
                  ],
                  onChanged: (value) =>
                      setState(() => selectedCategory = value),
                  decoration: InputDecoration(labelText: 'Categoria'),
                  validator: (value) =>
                  value == null ? 'Selecione uma categoria' : null,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: salvarReceita,
                  child: Text('Salvar Receita'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    ingredientsController.dispose();
    stepsController.dispose();
    noteController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }
}
