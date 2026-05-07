import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/dto/dto_manutencao.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaManutencoes extends StatefulWidget {
  const ListaManutencoes({super.key});

  @override
  State<ListaManutencoes> createState() => _ListaManutencoesState();
}

class _ListaManutencoesState extends State<ListaManutencoes> {
  final DAOManutencao _dao = DAOManutencao();
  List<DTOManutencao> _itens = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final itens = await _dao.buscarTodos();
      setState(() {
        _itens = itens;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar manutenções: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _excluirItem(DTOManutencao item) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente cancelar a manutenção da bike "${item.bike.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmacao != true) return;
    try {
      await _dao.excluir(item.id!);
      await _carregarDados();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Manutenção cancelada com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manutenções'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarDados, tooltip: 'Recarregar'),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _itens.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.build_circle, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Nenhuma manutenção registrada', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        onPressed: () => Navigator.pushNamed(context, Rotas.cadastroManutencao).then((_) => _carregarDados()),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _itens.length,
                  itemBuilder: (context, index) {
                    final item = _itens[index];
                    final status = item.ativo ? 'Pendente' : 'Cancelada';
                    final cor = item.ativo ? Colors.orange : Colors.grey;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: cor, child: const Icon(Icons.build, color: Colors.white)),
                        title: Text('${item.bike.nome} — ${item.tipoManutencao.nome}'),
                        subtitle: Text(
                          'Solicitação: ${_formatarData(item.dataSolicitacao)}\n'
                          'Descrição: ${item.descricao}\n'
                          'Status: $status',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => Navigator.pushNamed(context, Rotas.cadastroManutencao, arguments: item).then((_) => _carregarDados()),
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirItem(item),
                              tooltip: 'Cancelar',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.cadastroManutencao).then((_) => _carregarDados()),
        tooltip: 'Nova Manutenção',
        child: const Icon(Icons.add),
      ),
    );
  }
}
