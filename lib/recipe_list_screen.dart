import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adicionar_receita_page.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String searchQuery = '';
  String selectedCategory = 'Todos';
  List<Map<String, dynamic>> recipes = [];

  List<String> categories = ['Todos', 'Sobremesa', 'Prato Principal', 'Vegetariano'];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final snapshot = await FirebaseFirestore.instance.collection('receitas').get();
    final data = snapshot.docs.map((doc) {
      final r = doc.data();
      r['id'] = doc.id;
      return r;
    }).toList();

    setState(() {
      recipes = data;
    });
  }

  Future<void> toggleFavorite(String id, bool newValue) async {
    await FirebaseFirestore.instance.collection('receitas').doc(id).update({'isFavorite': newValue});
    fetchRecipes();
  }

  Future<void> updateNote(String id, String note) async {
    await FirebaseFirestore.instance.collection('receitas').doc(id).update({'note': note});
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = recipes.where((recipe) {
      final matchesTitle = recipe['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'Todos' || recipe['category'] == selectedCategory;
      return matchesTitle && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Receitas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AdicionarReceitaScreen())).then((_) => fetchRecipes());
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar receita...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) => setState(() => selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: recipes.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              recipe: recipe,
                              onFavoriteToggle: () {
                                toggleFavorite(recipe['id'], !recipe['isFavorite']);
                              },
                              onNoteChanged: (note) {
                                updateNote(recipe['id'], note);
                              },
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              recipe['image'],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(recipe['title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(
                                        recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.brown,
                                      ),
                                      onPressed: () {
                                        toggleFavorite(recipe['id'], !recipe['isFavorite']);
                                      },
                                    ),
                                  ],
                                ),
                                Text(recipe['category']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onFavoriteToggle;
  final Function(String) onNoteChanged;

  const RecipeDetailScreen({
    required this.recipe,
    required this.onFavoriteToggle,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final noteController = TextEditingController(text: recipe['note']);

    return Scaffold(
      appBar: AppBar(title: Text('Detalhes')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(recipe['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Image.network(recipe['image'], height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text("Ingredientes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...recipe['ingredients'].map<Widget>((i) => Text('• $i')).toList(),
            SizedBox(height: 16),
            Text("Modo de preparo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...recipe['steps'].asMap().entries.map((e) => Text('${e.key + 1}. ${e.value}')),
            SizedBox(height: 16),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Adicione uma nota...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => onNoteChanged(value),
            ),
            IconButton(
              icon: Icon(recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border, color: Colors.brown),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}
