import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class ListaPadrao<T extends DTO> extends StatefulWidget {
  final String titulo;
  final IconData icone;
  final String mensagemVazia;
  final String rotaCadastro;
  final Future<List<T>> Function() carregar;
  final Future<void> Function(int id) excluir;
  final bool Function(T) ativo;
  final String Function(T) detalhes;

  const ListaPadrao({
    super.key,
    required this.titulo,
    required this.icone,
    required this.mensagemVazia,
    required this.rotaCadastro,
    required this.carregar,
    required this.excluir,
    required this.ativo,
    required this.detalhes,
  });

  @override
  State<ListaPadrao<T>> createState() => _ListaPadraoState<T>();
}

class _ListaPadraoState<T extends DTO> extends State<ListaPadrao<T>> {
  List<T> _itens = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        actions: [_botaoRecarregar()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _itens.isEmpty
              ? _widgetSemDados()
              : ListView.builder(
                  itemCount: _itens.length,
                  itemBuilder: (context, index) => _itemLista(_itens[index]),
                ),
      floatingActionButton: _botaoAdicionar(),
    );
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final itens = await widget.carregar();
      setState(() {
        _itens = itens;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar ${widget.titulo.toLowerCase()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirItem(T item) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir "${item.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmacao != true) return;
    try {
      await widget.excluir(item.id!);
      await _carregarDados();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${item.nome}" excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editarItem(T item) {
    Navigator.pushNamed(
      context,
      widget.rotaCadastro,
      arguments: item,
    ).then((_) => _carregarDados());
  }

  Widget _widgetSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icone, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            widget.mensagemVazia,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _botaoAdicionar(),
        ],
      ),
    );
  }

  Widget _itemLista(T item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.ativo(item) ? Colors.green : Colors.grey,
          child: Icon(widget.icone, color: Colors.white),
        ),
        title: Text(item.nome),
        subtitle: Text(widget.detalhes(item)),
        trailing: _painelBotoesItem(item),
      ),
    );
  }

  Widget _painelBotoesItem(T item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _editarItem(item),
          tooltip: 'Editar',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _excluirItem(item),
          tooltip: 'Excluir',
        ),
      ],
    );
  }

  Widget _botaoAdicionar() {
    return FloatingActionButton(
      onPressed: () =>
          Navigator.pushNamed(context, widget.rotaCadastro).then((_) => _carregarDados()),
      tooltip: 'Adicionar',
      child: const Icon(Icons.add),
    );
  }

  Widget _botaoRecarregar() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _carregarDados,
      tooltip: 'Recarregar',
    );
  }
}
