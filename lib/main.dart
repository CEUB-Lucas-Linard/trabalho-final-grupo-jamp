import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'adicionar_receita_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCjfaK4sKnxlIP-q_5qNr4JnWrUle8MwcQ",
        authDomain: "recip-13f9c.firebaseapp.com",
        projectId: "recip-13f9c",
        storageBucket: "recip-13f9c.firebasestorage.app",
        messagingSenderId: "140229643080",
        appId: "1:140229643080:web:1344ee6a932464f480017d",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(RecipApp());
}

class RecipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recip',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[50],
        fontFamily: 'Georgia',
      ),
      home: RecipeListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
    fetchRecipes(); // refresh
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
      appBar: AppBar(
        title: Text('Recip'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarReceitaScreen()),
          ).then((_) => fetchRecipes());  // Atualiza lista ao voltar
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 12),
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
                                builder: (context) => RecipeDetailScreen(
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
                                        Text(
                                          recipe['title'],
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                            color: Colors.brown,
                                          ),
                                          onPressed: () {
                                            toggleFavorite(recipe['id'], !recipe['isFavorite']);
                                          },
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.brown[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        recipe['category'],
                                        style: TextStyle(color: Colors.brown[900]),
                                      ),
                                    ),
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
        ),
      ),
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onFavoriteToggle;
  final Function(String) onNoteChanged;

  const RecipeDetailScreen({
    required this.recipe,
    required this.onFavoriteToggle,
    required this.onNoteChanged,
  });

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.recipe['note']);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes"), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Card(
              color: Colors.brown[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            recipe['title'],
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                            color: Colors.brown,
                          ),
                          onPressed: () {
                            widget.onFavoriteToggle();
                            setState(() {});
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        recipe['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Ingredientes:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    ...recipe['ingredients'].map<Widget>((item) => Text("\u2022 $item")).toList(),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Modo de Preparo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    ...recipe['steps'].asMap().entries.map<Widget>((entry) {
                      int idx = entry.key + 1;
                      String step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text("$idx. $step"),
                      );
                    }).toList(),
                    SizedBox(height: 24),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Adicione uma nota pessoal...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (value) {
                        widget.onNoteChanged(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
