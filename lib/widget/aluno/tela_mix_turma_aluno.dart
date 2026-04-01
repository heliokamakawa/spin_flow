import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma_mix.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/dto/dto_turma_mix.dart';

class TelaMixTurmaAluno extends StatefulWidget {
  const TelaMixTurmaAluno({super.key});

  @override
  State<TelaMixTurmaAluno> createState() => _TelaMixTurmaAlunoState();
}

class _TelaMixTurmaAlunoState extends State<TelaMixTurmaAluno> {
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();

  DTOTurma? _turma;
  DateTime? _data;
  bool _carregando = true;
  DTOTurmaMix? _mixAtivo;
  List<DTOTurmaMix> _historico = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_turma != null) return;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _turma = args?['turma'] as DTOTurma?;
    _data = args?['data'] as DateTime?;
    _carregar();
  }

  Future<void> _carregar() async {
    if (_turma == null) return;
    setState(() => _carregando = true);

    final ativo = await _daoTurmaMix.buscarAtivoPorTurma(_turma!.id ?? 0, data: _data);
    final historico = await _daoTurmaMix.buscarPorTurma(_turma!.id ?? 0);
    historico.sort((a, b) => b.dataInicio.compareTo(a.dataInicio));

    if (!mounted) return;
    setState(() {
      _mixAtivo = ativo;
      _historico = historico;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_turma == null) {
      return const Scaffold(body: Center(child: Text('Turma nao informada.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mix da Turma - ${_turma!.nome}'),
        actions: [IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (_mixAtivo == null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Sem mix ativo para esta turma.'),
              ),
            ),
          if (_mixAtivo != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_mixAtivo!.mix.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Periodo: ${_mixAtivo!.dataInicio.toString().split(' ')[0]} ate ${_mixAtivo!.dataFim.toString().split(' ')[0]}'),
                    if (_mixAtivo!.mix.descricao.isNotEmpty) Text('Descricao: ${_mixAtivo!.mix.descricao}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Musicas do mix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ..._mixAtivo!.mix.musicas.asMap().entries.map(
              (entry) {
                final idx = entry.key + 1;
                final musica = entry.value;
                final categorias = musica.categorias.map((c) => c.nome).join(', ');
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$idx. ${musica.nome}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Artista: ${musica.artista.nome}'),
                        Text('Categorias: $categorias'),
                        if (musica.linksVideoAula.isNotEmpty)
                          ...musica.linksVideoAula.map((v) => Text('Video: ${v.nome} - ${v.linkVideo}')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 12),
          const Text('Historico de mixes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          if (_historico.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('Sem historico de mixes.'))),
          ..._historico.map(
            (h) => Card(
              child: ListTile(
                title: Text(h.mix.nome),
                subtitle: Text('Periodo: ${h.dataInicio.toString().split(' ')[0]} ate ${h.dataFim.toString().split(' ')[0]}'),
                trailing: Text(h.ativo ? 'Ativo' : 'Inativo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

