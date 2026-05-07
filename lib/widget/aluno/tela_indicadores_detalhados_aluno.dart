import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';
import 'package:spin_flow/dto/dto_aluno.dart';

class TelaIndicadoresDetalhadosAluno extends StatefulWidget {
  const TelaIndicadoresDetalhadosAluno({super.key});

  @override
  State<TelaIndicadoresDetalhadosAluno> createState() =>
      _TelaIndicadoresDetalhadosAlunoState();
}

class _TelaIndicadoresDetalhadosAlunoState
    extends State<TelaIndicadoresDetalhadosAluno> {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();

  bool _carregando = true;
  DTOAluno? _aluno;

  // Métricas detalhadas
  Map<String, int> _frequenciaMensal = {};
  int _aulasRealizadas = 0;
  int _aulasCanceladas = 0;
  int _faltas = 0;
  double _taxaPresenca = 0;
  double _horasDeAula = 0;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final email = SessaoUsuario.email;
    final aluno = email == null ? null : await _daoAluno.buscarPorEmailAtivo(email);

    Map<String, int> frequenciaMensal = {};
    int aulasRealizadas = 0;
    int aulasCanceladas = 0;
    int faltas = 0;
    double taxaPresenca = 0;
    double horasDeAula = 0;

    if (aluno != null) {
      final checkins = await _daoCheckin.buscarPorAluno(aluno.id ?? 0);
      final hoje = DateTime.now();
      final hojeData = DateTime(hoje.year, hoje.month, hoje.day);

      final passados = checkins.where((c) {
        final d = DateTime(c.data.year, c.data.month, c.data.day);
        return d.isBefore(hojeData);
      }).toList();

      aulasRealizadas = passados.where((c) => c.ativo).length;
      aulasCanceladas = passados.where((c) => !c.ativo).length;
      faltas = aulasCanceladas;
      final total = passados.length;
      taxaPresenca = total > 0 ? (aulasRealizadas / total) * 100 : 0;
      horasDeAula = 0;
      for (final c in passados.where((c) => c.ativo)) {
        horasDeAula += c.turma.duracaoMinutos / 60.0;
      }

      // Frequência mensal (últimos 6 meses)
      for (int i = 0; i < 6; i++) {
        final mesRef = DateTime(hoje.year, hoje.month - i, 1);
        final chave = '${_nomeMes(mesRef.month)}/${mesRef.year}';
        final count = passados.where((c) {
          return c.ativo && c.data.year == mesRef.year && c.data.month == mesRef.month;
        }).length;
        frequenciaMensal[chave] = count;
      }
    }

    if (!mounted) return;
    setState(() {
      _aluno = aluno;
      _frequenciaMensal = frequenciaMensal;
      _aulasRealizadas = aulasRealizadas;
      _aulasCanceladas = aulasCanceladas;
      _faltas = faltas;
      _taxaPresenca = taxaPresenca;
      _horasDeAula = horasDeAula;
      _carregando = false;
    });
  }

  String _nomeMes(int mes) {
    const nomes = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return nomes[(mes - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Indicadores Detalhados')),
      body: _aluno == null
          ? const Center(child: Text('Aluno nao encontrado.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(_aluno!.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _cardMetrica('Aulas realizadas', '$_aulasRealizadas', Icons.check_circle, Colors.green),
                _cardMetrica('Aulas canceladas', '$_aulasCanceladas', Icons.cancel, Colors.orange),
                _cardMetrica('Faltas', '$_faltas', Icons.close, Colors.red),
                _cardMetrica('Taxa de presenca', '${_taxaPresenca.toStringAsFixed(1)}%', Icons.percent, Colors.blue),
                _cardMetrica('Horas de aula', '${_horasDeAula.toStringAsFixed(1)}h', Icons.access_time, Colors.purple),
                const SizedBox(height: 20),
                const Text('Frequencia mensal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: _frequenciaMensal.entries.map((e) {
                        final maxVal = _frequenciaMensal.values.fold(1, (a, b) => a > b ? a : b);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(width: 80, child: Text(e.key, style: const TextStyle(fontSize: 13))),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: maxVal > 0 ? e.value / maxVal : 0,
                                  backgroundColor: Colors.grey.shade200,
                                  color: Colors.purple,
                                  minHeight: 14,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _cardMetrica(String titulo, String valor, IconData icone, Color cor) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cor.withValues(alpha: 0.15),
          child: Icon(icone, color: cor),
        ),
        title: Text(titulo),
        trailing: Text(valor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cor)),
      ),
    );
  }
}
