import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_posicao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma_mix.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_posicao_bike.dart';
import 'package:spin_flow/dto/dto_turma.dart';

class TelaAgendaAluno extends StatefulWidget {
  const TelaAgendaAluno({super.key});

  @override
  State<TelaAgendaAluno> createState() => _TelaAgendaAlunoState();
}

class _TelaAgendaAlunoState extends State<TelaAgendaAluno> {
  final DAOTurma _daoTurma = DAOTurma();
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();

  DateTime _dataSelecionada = DateTime.now();
  bool _carregando = true;
  List<_ResumoTurma> _resumos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final turmas = await _daoTurma.buscarAtivas();
    final bikesBloqueadas = await _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
    final posicoesBloqueadas = await _daoPosicaoBike.buscarPorBikeIds(bikesBloqueadas);
    final List<_ResumoTurma> resumos = [];

    for (final turma in turmas) {
      final checkins = await _daoCheckin.buscarAtivosPorTurmaData(
        turmaId: turma.id ?? 0,
        data: _dataSelecionada,
      );
      final totalBikes = turma.sala.numeroFilas * turma.sala.numeroColunas;
      final ocupadas = checkins.length;
      final bloqueadasNaGrade = _contarBloqueadasNaGrade(
        posicoesBloqueadas,
        turma.sala.numeroFilas,
        turma.sala.numeroColunas,
      );
      final vagas = (totalBikes - ocupadas - bloqueadasNaGrade).clamp(0, totalBikes);
      final mixAtivo = await _daoTurmaMix.buscarAtivoPorTurma(
        turma.id ?? 0,
        data: _dataSelecionada,
      );

      resumos.add(
        _ResumoTurma(
          turma: turma,
          vagas: vagas,
          total: totalBikes,
          bloqueadas: bloqueadasNaGrade,
          mixNome: mixAtivo?.mix.nome,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _resumos = resumos;
      _carregando = false;
    });
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data == null) return;
    setState(() => _dataSelecionada = data);
    await _carregar();
  }

  void _abrirMapa(_ResumoTurma resumo) {
    if (!_dataCompativelComTurma(resumo.turma, _dataSelecionada)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data selecionada nao pertence aos dias da turma.')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      Rotas.mapaCheckin,
      arguments: {
        'turma': resumo.turma,
        'data': _dataSelecionada,
      },
    ).then((_) => _carregar());
  }

  bool _dataCompativelComTurma(DTOTurma turma, DateTime data) {
    final dia = _nomeDia(data);
    if (turma.diasSemana.contains(dia)) return true;
    if (dia == 'Sab' && turma.diasSemana.contains('Sáb')) return true;
    return false;
  }

  String _nomeDia(DateTime data) {
    switch (data.weekday) {
      case DateTime.monday:
        return 'Seg';
      case DateTime.tuesday:
        return 'Ter';
      case DateTime.wednesday:
        return 'Qua';
      case DateTime.thursday:
        return 'Qui';
      case DateTime.friday:
        return 'Sex';
      case DateTime.saturday:
        return 'Sab';
      default:
        return 'Dom';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Semanal'),
        actions: [
          IconButton(onPressed: _selecionarData, icon: const Icon(Icons.calendar_month)),
          IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _resumos.isEmpty
              ? const Center(child: Text('Nenhuma turma ativa encontrada.'))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _gradeSemanal(),
                    const SizedBox(height: 12),
                    ..._resumos.map(_cardResumo),
                  ],
                ),
    );
  }

  Widget _gradeSemanal() {
    final dias = _datasDaSemana(_dataSelecionada);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grade semanal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dias.map((diaData) {
                  final dia = _nomeDia(diaData);
                  final turmasDia = _resumos.where((r) => _turmaContemDia(r.turma, dia)).toList()
                    ..sort((a, b) => a.turma.horarioInicio.compareTo(b.turma.horarioInicio));
                  return Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${diaData.day}/${diaData.month} - $dia', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        if (turmasDia.isEmpty) const Text('Sem turmas'),
                        ...turmasDia.map((t) => Text('${t.turma.horarioInicio} - ${t.turma.nome}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardResumo(_ResumoTurma resumo) {
    final lotada = resumo.vagas == 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    resumo.turma.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Chip(
                  label: Text(lotada ? 'Lotada' : 'Vagas: ${resumo.vagas}/${resumo.total}'),
                  backgroundColor: lotada ? Colors.red.shade100 : Colors.green.shade100,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Horario: ${resumo.turma.horarioInicio}'),
            Text('Sala: ${resumo.turma.sala.nome}'),
            Text('Dias: ${resumo.turma.diasSemana.join(', ')}'),
            Text('Mix atual: ${resumo.mixNome ?? 'Sem mix ativo'}'),
            Text('Bikes indisponiveis (manutencao): ${resumo.bloqueadas}'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Rotas.mixTurmaAluno,
                      arguments: {
                        'turma': resumo.turma,
                        'data': _dataSelecionada,
                      },
                    );
                  },
                  icon: const Icon(Icons.library_music),
                  label: const Text('Ver mix'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: lotada ? null : () => _abrirMapa(resumo),
                  icon: const Icon(Icons.map),
                  label: const Text('Ver mapa e reservar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _contarBloqueadasNaGrade(List<DTOPosicaoBike> posicoes, int filas, int colunas) {
    return posicoes.where((p) => p.fila >= 0 && p.fila < filas && p.coluna >= 0 && p.coluna < colunas).length;
  }

  List<DateTime> _datasDaSemana(DateTime base) {
    final hoje = DateTime(base.year, base.month, base.day);
    final inicio = hoje.subtract(Duration(days: hoje.weekday - 1));
    return List.generate(7, (i) => inicio.add(Duration(days: i)));
  }

  bool _turmaContemDia(DTOTurma turma, String dia) {
    if (turma.diasSemana.contains(dia)) return true;
    if (dia == 'Sab' && turma.diasSemana.contains('Sáb')) return true;
    return false;
  }
}

class _ResumoTurma {
  final DTOTurma turma;
  final int vagas;
  final int total;
  final int bloqueadas;
  final String? mixNome;

  _ResumoTurma({
    required this.turma,
    required this.vagas,
    required this.total,
    required this.bloqueadas,
    required this.mixNome,
  });
}


