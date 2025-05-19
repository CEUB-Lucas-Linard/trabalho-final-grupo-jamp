import 'package:flutter/material.dart';
import 'package:receitas_culinarias/models/receita.dart';
import 'receita_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Receita> receitas = [
    Receita(
      nome: 'Feijoada',
      descricao: 'Feijoada tradicional brasileira.',
      ingredientes: 'Feijão preto, carne seca, linguiça, etc.',
      modoPreparo: 'Cozinhar tudo junto por algumas horas...',
      imagemUrl: 'https://www.example.com/feijoada.jpg',
    ),
    Receita(
      nome: 'Bolo de Cenoura',
      descricao: 'Bolo de cenoura delicioso e fofinho.',
      ingredientes: 'Cenoura, açúcar, farinha, ovos...',
      modoPreparo: 'Bater os ingredientes e assar...',
      imagemUrl: 'https://www.example.com/bolo_cenoura.jpg',
    ),
    // Adicione mais receitas conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas Culinárias'),
      ),
      body: ListView.builder(
        itemCount: receitas.length,
        itemBuilder: (ctx, index) {
          final receita = receitas[index];
          return ListTile(
            leading: Image.network(receita.imagemUrl),
            title: Text(receita.nome),
            subtitle: Text(receita.descricao),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ReceitaDetailScreen(receita: receita),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
