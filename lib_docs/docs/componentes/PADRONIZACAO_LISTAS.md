## 10. Componentização Local (Recomendada)

- Crie métodos privados para cada parte visual importante:
  - Item da lista (ex: `_itemListaAluno`)
  - Painel de botões do item (ex: `_painelBotoesItem`)
  - Widget de estado vazio (ex: `_widgetSemDados`)
  - Botão de adicionar, recarregar, etc.
- Isso deixa o método `build` limpo e autoexplicativo, facilitando manutenção e leitura.
- Exemplo:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Alunos'),
      actions: [_botaoRecarregar()],
    ),
    body: _carregando
        ? const Center(child: CircularProgressIndicator())
        : _alunos.isEmpty
            ? _widgetSemDados()
            : ListView.builder(
                itemCount: _alunos.length,
                itemBuilder: (context, index) => _itemListaAluno(_alunos[index]),
              ),
    floatingActionButton: _botaoAdicionar(),
  );
}

Widget _widgetSemDados() { ... }
Widget _itemListaAluno(DTOAluno aluno) { ... }
Widget _painelBotoesItem(DTOAluno aluno) { ... }
Widget _botaoAdicionar() { ... }
Widget _botaoRecarregar() { ... }
```

## 11. Ordem dos Métodos no State

- Métodos override (`initState`, `build`) primeiro.
- Em seguida, métodos de definição de apresentação visual dos itens:
  - `_definirDescricao`
  - `_definirDetalhesDescricao`
- Depois, métodos de ciclo de vida, carregamento, ações e widgets auxiliares.
- Isso facilita a localização e manutenção do que é apresentado na lista.

## Checklist de Revisão

- Métodos override primeiro
- Depois, _definirDescricao e _definirDetalhesDescricao
- Componentização local aplicada
- Nomes claros e autoexplicativos
- Tratamento de erro e loading padronizados
- Botão de recarregar e adicionar presentes
- Confirmação de exclusão padronizada 