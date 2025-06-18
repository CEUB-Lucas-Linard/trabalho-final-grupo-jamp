# Recip - Seu Gerenciador de Receitas Pessoal 🍲

"Recip" é um aplicativo Flutter intuitivo e fácil de usar, projetado para ajudar você a gerenciar e visualizar suas receitas favoritas. Com uma interface fluida, o Recip permite buscar, filtrar e explorar detalhes de receitas, além de oferecer a funcionalidade de marcar favoritos e adicionar notas pessoais.

Este projeto demonstra boas práticas de UI/UX em Flutter e serve como uma base sólida para um produto de mercado robusto e escalável.

## ✨ Funcionalidades

* **Busca de Receitas:** Encontre receitas rapidamente utilizando a barra de busca por título.
* **Filtro por Categoria:** Organize e filtre suas receitas por categorias como "Sobremesa", "Prato Principal" e "Vegetariano" utilizando chips interativos.
* **Detalhes da Receita:** Visualize informações completas de cada receita, incluindo ingredientes e modo de preparo.
* **Favoritos:** Marque suas receitas preferidas para acesso rápido e fácil.
* **Notas Pessoais:** Adicione anotações e observações personalizadas a cada receita.
* **Interface Acolhedora:** Desfrute de uma experiência visual agradável com uma paleta de cores em tons de marrom, um fundo suave (`Colors.brown[50]`) e a fonte 'Georgia', conferindo uma estética culinária.

## 🚀 Tecnologias

* **Flutter:** Framework principal de desenvolvimento do aplicativo, garantindo uma experiência de usuário fluida.
* **Dart:** Linguagem de programação utilizada.
* **Firebase:** Banco de Dados
## Dependências
 * flutter:
 *   sdk: flutter
 * firebase_core: ^2.32.0
 * cloud_firestore: ^4.17.5
 * image_picker: ^1.0.0
 * uuid: ^4.0.0
 * firebase_auth: ^4.17.0
 * js: ^0.6.7

## 🏗️ Estrutura do Código

O código-fonte do "Recip" está organizado em um único arquivo, `main.dart`, e é composto por três componentes principais:

1.  **`main()`**: O ponto de entrada da aplicação, responsável por inicializar e rodar o `RecipApp`.
2.  **`RecipApp`**: O widget raiz da aplicação, um `StatelessWidget` que configura o `MaterialApp`, o tema visual e a tela inicial (`RecipeListScreen`).
3.  **`RecipeListScreen`**: A tela principal do aplicativo, implementada como um `StatefulWidget`, que oferece uma interface rica para o usuário explorar receitas. As receitas são atualmente armazenadas em uma lista estática (`recipes`). Gerencia o termo de busca (`searchQuery`) e a categoria selecionada (`selectedCategory`) utilizando `setState`.
4. **`RecipeDetailScreen`**: Este `StatefulWidget` apresenta as informações completas de uma receita selecionada. Recebe o objeto da receita da tela de listagem, e permite comunicar mudanças no status de favorito de volta para a `RecipeListScreen` através de um `onFavoriteToggle`. Utiliza um `TextEditingController` (`noteController`) para gerenciar as anotações pessoais.

## 🔮 Próximos Passos e Oportunidades de Melhoria

Para evoluir o "Recip" para um produto de mercado de alta qualidade, as seguintes melhorias arquiteturais e de desenvolvimento são essenciais:

* **Modelagem de Dados Fortemente Tipada:** Criar classes Dart explícitas (e.g., `Recipe`, `Ingredient`, `Step`) com propriedades e tipos bem definidos, em vez de usar `Map<String, dynamic>`. Isso melhora a segurança de tipo, facilita o autocompletar e a refatoração, e torna o código mais legível e robusto.
* **Gerenciamento de Estado Otimizado:** Adotar soluções robustas de gerenciamento de estado global e reativo como Provider, BLoC/Cubit ou Riverpod, em vez de `setState` local. Isso promove o desacoplamento da lógica de negócio da interface do usuário, aumenta a escalabilidade e melhora a testabilidade.
* **Persistência de Dados:** Integrar uma solução de persistência local como Hive ou sqflite para armazenar receitas, status de favoritos e notas. Isso garante que as informações do usuário sejam salvas e recuperadas entre sessões, oferecendo uma experiência contínua.
* **Arquitetura em Camadas (Clean Architecture):** Estruturar o projeto em camadas bem definidas (Domínio, Dados, Apresentação) para aumentar a manutenibilidade, testabilidade e flexibilidade.
* **Injeção de Dependência:** Utilizar ferramentas como GetIt para registrar e resolver as dependências das camadas, o que reduz o acoplamento, facilita a criação de mocks para testes e melhora a organização do código.
* **Tratamento de Imagens e Rede:** Usar `cached_network_image` para cachear imagens e implementar tratamento de erros e indicadores de carregamento para imagens e outras operações de rede.

Com essas melhorias, o "Recip" tem o potencial de se tornar uma aplicação Flutter exemplar, robusta e preparada para o crescimento.

## 👥 Equipe

1. **Arthur Lima Dantas**
2. **João Pedro Gome Vellasco**
3. **Miguel Araújo**
4. **Pedro Henrique da Silva de Santana**
