import 'package:flutter/material.dart';

void main() => runApp(RecipApp());

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

  List<Map<String, dynamic>> recipes = [
    {
      "title": "Bolo de Chocolate",
      "image": "https://cdn.pixabay.com/photo/2016/11/22/18/52/cake-1850011_1280.jpg",
      "category": "Sobremesa",
      "ingredients": ["2 ovos", "1 xícara de açúcar", "1 xícara de chocolate em pó"],
      "steps": ["Misture tudo", "Asse por 40 min"],
      "isFavorite": false,
      "note": ""
    },
    {
      "title": "Salada Vegana",
      "image": "https://cdn.pixabay.com/photo/2023/09/25/07/55/salad-8274421_1280.jpg",
      "category": "Vegetariano",
      "ingredients": ["Alface", "Tomate", "Azeite"],
      "steps": ["Lave bem os ingredientes", "Misture tudo"],
      "isFavorite": false,
      "note": ""
    },
    {
      "title": "Lasanha de Frango",
      "image": "https://cdn.pixabay.com/photo/2016/12/11/22/41/lasagna-1900529_1280.jpg",
      "category": "Prato Principal",
      "ingredients": ["Frango desfiado", "Massa de lasanha", "Molho branco"],
      "steps": ["Monte as camadas", "Leve ao forno por 30 minutos"],
      "isFavorite": false,
      "note": ""
    },
    {
      "title": "Panqueca Integral",
      "image": "https://cdn.pixabay.com/photo/2017/01/30/13/49/pancakes-2020863_1280.jpg",
      "category": "Vegetariano",
      "ingredients": ["Farinha integral", "Ovo", "Leite"],
      "steps": ["Misture os ingredientes", "Frite em uma frigideira antiaderente"],
      "isFavorite": false,
      "note": ""
    },
    {
      "title": "Torta de Maçã",
      "image": "https://cdn.pixabay.com/photo/2020/09/25/15/13/pie-5601654_1280.jpg",
      "category": "Sobremesa",
      "ingredients": ["Maçãs", "Canela", "Massa para torta"],
      "steps": ["Monte a torta", "Asse por 45 minutos"],
      "isFavorite": false,
      "note": ""
    },
  ];

  List<String> categories = ['Todos', 'Sobremesa', 'Prato Principal', 'Vegetariano'];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRecipes = recipes.where((recipe) {
      final matchesTitle = recipe['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'Todos' || recipe['category'] == selectedCategory;
      return matchesTitle && matchesCategory;
    }).toList();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.restaurant_menu, color: Colors.brown, size: 50),
                const SizedBox(height: 8),
                const Text(
                  'Recip',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar receita...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
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
                          onSelected: (_) {
                            setState(() => selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
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
                                    setState(() => recipe['isFavorite'] = !recipe['isFavorite']);
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
                                            setState(() => recipe['isFavorite'] = !recipe['isFavorite']);
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

// TELA DE DETALHES
class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onFavoriteToggle;

  const RecipeDetailScreen({required this.recipe, required this.onFavoriteToggle});

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes"),
        centerTitle: true,
      ),
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
                            widget.recipe['title'],
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            widget.recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border,
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
                        widget.recipe['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ingredientes:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    ...widget.recipe['ingredients'].map<Widget>((item) => Text("\u2022 $item")).toList(),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Modo de Preparo:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    ...widget.recipe['steps'].asMap().entries.map<Widget>((entry) {
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
                        widget.recipe['note'] = value;
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
