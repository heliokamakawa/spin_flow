import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/dto/dto_checkin.dart';
import 'package:spin_flow/dto/dto_turma.dart';

/// Tela de Relatórios Gerenciais (UC18).
/// Apresenta métricas operacionais agregadas para a professora:
/// ocupação por turma, frequência de alunos, bikes em manutenção,
/// taxa de cancelamento e resumo geral do período.
class TelaRelatoriosProfessora extends StatefulWidget {
  const TelaRelatoriosProfessora({super.key});

  @override
  State<TelaRelatoriosProfessora> createState() => _TelaRelatoriosProfessoraState();
}

class _TelaRelatoriosProfessoraState extends State<TelaRelatoriosProfessora> {
  bool _carregando = true;

  // Métricas gerais
  int _totalAlunos = 0;
  int _alunosAtivos = 0;
  int _totalBikes = 0;
  int _bikesAtivas = 0;
  int _bikesEmManutencao = 0;
  int _totalTurmas = 0;
  int _turmasAtivas = 0;
  int _totalCheckins = 0;
  int _checkinsAtivos = 0;
  int _checkinsCancelados = 0;
  int _checkinsConcluidos = 0;
  int _checkinsAgendados = 0;

  // Ocupação por turma
  List<_OcupacaoTurma> _ocupacaoTurmas = [];

  // Top alunos
  List<_FrequenciaAluno> _topAlunos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final daoAluno = DAOAluno();
      final daoBike = DAOBike();
      final daoManut = DAOManutencao();
      final daoTurma = DAOTurma();
      final daoCheckin = DAOCheckin();

      final alunos = await daoAluno.buscarTodos();
      final bikes = await daoBike.buscarTodos();
      final bikesManut = await daoManut.buscarBikeIdsEmManutencaoAtiva();
      final turmas = await daoTurma.buscarTodos();
      final checkins = await daoCheckin.buscarTodos();

      final agora = DateTime.now();
      final hojeSemHora = DateTime(agora.year, agora.month, agora.day);

      int ativos = 0;
      int cancelados = 0;
      int concluidos = 0;
      int agendados = 0;
      for (final c in checkins) {
        if (!c.ativo) {
          cancelados++;
        } else {
          ativos++;
          final dataSemHora = DateTime(c.data.year, c.data.month, c.data.day);
          if (dataSemHora.isBefore(hojeSemHora)) {
            concluidos++;
          } else {
            agendados++;
          }
        }
      }

      // Ocupação por turma
      final Map<int, List<DTOCheckin>> checkinsPorTurma = {};
      for (final c in checkins) {
        if (c.ativo && c.turma.id != null) {
          checkinsPorTurma.putIfAbsent(c.turma.id!, () => []).add(c);
        }
      }
      final ocupacao = <_OcupacaoTurma>[];
      for (final turma in turmas) {
        if (turma.id == null) continue;
        final totalVagas = turma.sala.numeroFilas * turma.sala.numeroColunas;
        final lista = checkinsPorTurma[turma.id!] ?? [];
        ocupacao.add(_OcupacaoTurma(
          turma: turma,
          totalCheckins: lista.length,
          totalVagas: totalVagas > 0 ? totalVagas : 1,
        ));
      }
      ocupacao.sort((a, b) => b.totalCheckins.compareTo(a.totalCheckins));

      // Top alunos por frequência
      final Map<String, int> freqAluno = {};
      for (final c in checkins) {
        if (c.ativo) {
          freqAluno[c.aluno.nome] = (freqAluno[c.aluno.nome] ?? 0) + 1;
        }
      }
      final topAlunos = freqAluno.entries.map((e) => _FrequenciaAluno(nome: e.key, aulas: e.value)).toList();
      topAlunos.sort((a, b) => b.aulas.compareTo(a.aulas));

      if (!mounted) return;
      setState(() {
        _totalAlunos = alunos.length;
        _alunosAtivos = alunos.where((a) => a.ativo).length;
        _totalBikes = bikes.length;
        _bikesAtivas = bikes.where((b) => b.ativa).length;
        _bikesEmManutencao = bikesManut.length;
        _totalTurmas = turmas.length;
        _turmasAtivas = turmas.where((t) => t.ativo).length;
        _totalCheckins = checkins.length;
        _checkinsAtivos = ativos;
        _checkinsCancelados = cancelados;
        _checkinsConcluidos = concluidos;
        _checkinsAgendados = agendados;
        _ocupacaoTurmas = ocupacao;
        _topAlunos = topAlunos.take(10).toList();
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar relatórios: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios Gerenciais'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregar, tooltip: 'Recarregar'),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _secaoResumoGeral(),
                const SizedBox(height: 24),
                _secaoCheckins(),
                const SizedBox(height: 24),
                _secaoOcupacaoTurma(),
                const SizedBox(height: 24),
                _secaoTopAlunos(),
              ],
            ),
    );
  }

  Widget _secaoResumoGeral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resumo Geral', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _cardMetrica('Alunos Ativos', '$_alunosAtivos/$_totalAlunos', Icons.person, Colors.blue),
            _cardMetrica('Bikes Ativas', '$_bikesAtivas/$_totalBikes', Icons.directions_bike, Colors.green),
            _cardMetrica('Em Manutenção', '$_bikesEmManutencao', Icons.build, Colors.orange),
            _cardMetrica('Turmas Ativas', '$_turmasAtivas/$_totalTurmas', Icons.event, Colors.purple),
            _cardMetrica('Total Check-ins', '$_totalCheckins', Icons.pin_drop, Colors.teal),
            _cardMetrica(
              'Taxa Cancelamento',
              _totalCheckins > 0 ? '${(_checkinsCancelados * 100 / _totalCheckins).toStringAsFixed(1)}%' : '0%',
              Icons.cancel,
              Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _secaoCheckins() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Check-ins', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _barraProgresso('Ativos', _checkinsAtivos, _totalCheckins, Colors.teal),
        const SizedBox(height: 8),
        _barraProgresso('Concluídos', _checkinsConcluidos, _totalCheckins, Colors.green),
        const SizedBox(height: 8),
        _barraProgresso('Agendados', _checkinsAgendados, _totalCheckins, Colors.blue),
        const SizedBox(height: 8),
        _barraProgresso('Cancelados', _checkinsCancelados, _totalCheckins, Colors.red),
      ],
    );
  }

  Widget _secaoOcupacaoTurma() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ocupação por Turma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_ocupacaoTurmas.isEmpty)
          const Text('Nenhuma turma com check-ins', style: TextStyle(color: Colors.grey))
        else
          ..._ocupacaoTurmas.map((o) {
            final pct = o.totalVagas > 0 ? (o.totalCheckins / o.totalVagas) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${o.turma.nome} (${o.turma.horarioInicio})', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct.clamp(0.0, 1.0),
                            minHeight: 16,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(pct > 0.8 ? Colors.red : Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${o.totalCheckins} reservas', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _secaoTopAlunos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alunos mais Frequentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_topAlunos.isEmpty)
          const Text('Nenhum dado de frequência disponível', style: TextStyle(color: Colors.grey))
        else
          ...List.generate(_topAlunos.length, (i) {
            final a = _topAlunos[i];
            return ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(a.nome),
              trailing: Text('${a.aulas} aulas', style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }),
      ],
    );
  }

  Widget _cardMetrica(String titulo, String valor, IconData icone, Color cor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: cor, size: 24),
            const SizedBox(height: 4),
            Text(valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cor)),
            Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _barraProgresso(String label, int valor, int total, Color cor) {
    final pct = total > 0 ? valor / total : 0.0;
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 14,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(cor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('$valor', style: TextStyle(fontWeight: FontWeight.bold, color: cor)),
      ],
    );
  }
}

class _OcupacaoTurma {
  final DTOTurma turma;
  final int totalCheckins;
  final int totalVagas;

  _OcupacaoTurma({required this.turma, required this.totalCheckins, required this.totalVagas});
}

class _FrequenciaAluno {
  final String nome;
  final int aulas;

  _FrequenciaAluno({required this.nome, required this.aulas});
}
