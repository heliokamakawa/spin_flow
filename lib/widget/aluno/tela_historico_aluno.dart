import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_checkin.dart';

class TelaHistoricoAluno extends StatefulWidget {
  const TelaHistoricoAluno({super.key});

  @override
  State<TelaHistoricoAluno> createState() => _TelaHistoricoAlunoState();
}

class _TelaHistoricoAlunoState extends State<TelaHistoricoAluno> {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();

  bool _carregando = true;
  DTOAluno? _aluno;
  List<DTOCheckin> _checkins = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final aluno = await _buscarAlunoLogado();
    final checkins = aluno == null ? <DTOCheckin>[] : await _daoCheckin.buscarPorAluno(aluno.id ?? 0);
    checkins.sort((a, b) => b.data.compareTo(a.data));

    if (!mounted) return;
    setState(() {
      _aluno = aluno;
      _checkins = checkins;
      _carregando = false;
    });
  }

  Future<DTOAluno?> _buscarAlunoLogado() async {
    final email = SessaoUsuario.email;
    if (email == null || email.isEmpty) return null;
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);

    final ativos = _checkins.where((c) => c.ativo).toList();
    final concluidas = ativos.where((c) => DateTime(c.data.year, c.data.month, c.data.day).isBefore(hoje)).toList();
    final agendadas = ativos.where((c) {
      final d = DateTime(c.data.year, c.data.month, c.data.day);
      return d.isAtSameMomentAs(hoje) || d.isAfter(hoje);
    }).toList();
    final concluidasAno = concluidas.where((c) => c.data.year == agora.year).length;
    final concluidasMes = concluidas.where((c) => c.data.year == agora.year && c.data.month == agora.month).length;

    final Map<String, int> recorrenciaPorDia = {};
    final Map<String, int> recorrenciaPorPosicao = {};
    final Map<String, int> recorrenciaPosicaoPorTurma = {};

    for (final c in ativos) {
      final dia = _diaSemana(c.data);
      recorrenciaPorDia[dia] = (recorrenciaPorDia[dia] ?? 0) + 1;

      final posicao = 'F${c.fila + 1}C${c.coluna + 1}';
      recorrenciaPorPosicao[posicao] = (recorrenciaPorPosicao[posicao] ?? 0) + 1;
      final chaveTurmaPosicao = '${c.turma.nome}::$posicao';
      recorrenciaPosicaoPorTurma[chaveTurmaPosicao] = (recorrenciaPosicaoPorTurma[chaveTurmaPosicao] ?? 0) + 1;
    }

    final posicaoMaisRecorrente = recorrenciaPorPosicao.entries.isEmpty
        ? null
        : (recorrenciaPorPosicao.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first;

    final turmaPosicaoMaisRecorrente = recorrenciaPosicaoPorTurma.entries.isEmpty
        ? null
        : (recorrenciaPosicaoPorTurma.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Historico'),
        actions: [IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh))],
      ),
      body: _aluno == null
          ? const Center(child: Text('Aluno autenticado nao encontrado.'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Text('Aluno: ${_aluno!.nome}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetricaCard(titulo: 'Concluidas', valor: '${concluidas.length}'),
                    _MetricaCard(titulo: 'No ano', valor: '$concluidasAno'),
                    _MetricaCard(titulo: 'No mes', valor: '$concluidasMes'),
                    _MetricaCard(titulo: 'Agendadas', valor: '${agendadas.length}'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Padroes de uso', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recorrencia por dia', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        if (recorrenciaPorDia.isEmpty) const Text('Sem dados suficientes.'),
                        ...recorrenciaPorDia.entries.map((e) => Text('${e.key}: ${e.value}')),
                        const SizedBox(height: 10),
                        Text(
                          posicaoMaisRecorrente == null
                              ? 'Posicao mais recorrente: sem dados'
                              : 'Posicao mais recorrente: ${posicaoMaisRecorrente.key} (${posicaoMaisRecorrente.value}x)',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          turmaPosicaoMaisRecorrente == null
                              ? 'Turma com maior recorrencia da posicao: sem dados'
                              : 'Turma/posicao mais recorrente: ${turmaPosicaoMaisRecorrente.key.replaceAll('::', ' - ')} (${turmaPosicaoMaisRecorrente.value}x)',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Check-ins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (_checkins.isEmpty)
                  const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('Nenhum check-in encontrado.'))),
                ..._checkins.map(
                  (c) => Card(
                    child: ListTile(
                      leading: Icon(c.ativo ? Icons.check_circle : Icons.cancel, color: c.ativo ? Colors.green : Colors.red),
                      title: Text('${c.turma.nome} - ${c.data.toString().split(' ')[0]}'),
                      subtitle: Text('Posicao: fila ${c.fila + 1}, coluna ${c.coluna + 1}'),
                      trailing: Text(c.ativo ? 'Ativo' : 'Cancelado'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _diaSemana(DateTime data) {
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
}

class _MetricaCard extends StatelessWidget {
  final String titulo;
  final String valor;

  const _MetricaCard({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

