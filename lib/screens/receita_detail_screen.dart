import 'package:flutter/material.dart';
import 'package:receitas_culinarias/models/receita.dart';

class ReceitaDetailScreen extends StatelessWidget {
  final Receita receita;

  ReceitaDetailScreen({required this.receita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receita.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(receita.imagemUrl),
              SizedBox(height: 16),
              Text(
                receita.nome,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 8),
              Text(
                'Ingredientes:',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(receita.ingredientes),
              SizedBox(height: 16),
              Text(
                'Modo de Preparo:',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(receita.modoPreparo),
            ],
          ),
        ),
      ),
    );
  }
}
