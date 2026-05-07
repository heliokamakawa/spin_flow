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

class _TelaHistoricoAlunoState extends State<TelaHistoricoAluno> with SingleTickerProviderStateMixin {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();

  late TabController _tabController;
  bool _carregando = true;
  DTOAluno? _aluno;
  List<DTOCheckin> _checkins = [];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
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

  List<DTOCheckin> _checkinsFiltrados() {
    final agora = DateTime.now();
    switch (_tabController.index) {
      case 1: // Este mês
        return _checkins.where((c) => c.data.year == agora.year && c.data.month == agora.month).toList();
      case 2: // Últimos 3 meses
        final limite = DateTime(agora.year, agora.month - 3, agora.day);
        return _checkins.where((c) => c.data.isAfter(limite)).toList();
      default: // Todas
        return _checkins;
    }
  }

  String _statusCheckin(DTOCheckin c) {
    final hoje = DateTime.now();
    final dataCheckin = DateTime(c.data.year, c.data.month, c.data.day);
    if (!c.ativo) return 'Falta';
    if (dataCheckin.isBefore(DateTime(hoje.year, hoje.month, hoje.day))) return 'Presente';
    return 'Agendado';
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'Presente':
        return Colors.green;
      case 'Falta':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _iconeStatus(String status) {
    switch (status) {
      case 'Presente':
        return Icons.check_circle;
      case 'Falta':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  void _abrirDetalheAula(DTOCheckin c) {
    final status = _statusCheckin(c);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _TelaDetalheAula(checkin: c, status: status),
      ),
    );
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

    final filtrados = _checkinsFiltrados();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Historico'),
        actions: [IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh))],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Este mes'),
            Tab(text: 'Ultimos 3 meses'),
          ],
        ),
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
                Text('Check-ins (${filtrados.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (filtrados.isEmpty)
                  const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('Nenhum check-in encontrado.'))),
                ...filtrados.map((c) {
                  final status = _statusCheckin(c);
                  final cor = _corStatus(status);
                  final dataStr = '${c.data.day.toString().padLeft(2, '0')}/${c.data.month.toString().padLeft(2, '0')}/${c.data.year}';
                  return Card(
                    child: InkWell(
                      onTap: () => _abrirDetalheAula(c),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Icon(_iconeStatus(status), color: cor, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.turma.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(height: 2),
                                  Text('$dataStr - ${c.turma.horarioInicio}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                  Text(c.turma.sala.nome, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(status, style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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

class _TelaDetalheAula extends StatelessWidget {
  final DTOCheckin checkin;
  final String status;

  const _TelaDetalheAula({required this.checkin, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = checkin;
    Color corStatus;
    switch (status) {
      case 'Presente':
        corStatus = Colors.green;
        break;
      case 'Falta':
        corStatus = Colors.red;
        break;
      default:
        corStatus = Colors.blue;
    }

    final diaSemana = _nomeDiaSemana(c.data);
    final dataFormatada = '${c.data.day.toString().padLeft(2, '0')}/${c.data.month.toString().padLeft(2, '0')}/${c.data.year} ($diaSemana)';

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe da Aula')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.turma.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(c.turma.sala.nome, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const Divider(height: 24),
                  _linhaDetalheComIcone(Icons.calendar_today, 'Data', dataFormatada),
                  _linhaDetalheComIcone(Icons.access_time, 'Horario', c.turma.horarioInicio),
                  _linhaDetalheComIcone(Icons.timer, 'Duracao', '${c.turma.duracaoMinutos} min'),
                  _linhaDetalheComIcone(Icons.pedal_bike, 'Bike', 'F${c.fila + 1} C${c.coluna + 1}'),
                  const SizedBox(height: 12),
                  _linhaDetalheComIcone(
                    Icons.check_circle_outline,
                    'Status',
                    status,
                    valorCor: corStatus,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar para historico'),
            ),
          ),
        ],
      ),
    );
  }

  String _nomeDiaSemana(DateTime data) {
    switch (data.weekday) {
      case DateTime.monday: return 'Segunda';
      case DateTime.tuesday: return 'Terca';
      case DateTime.wednesday: return 'Quarta';
      case DateTime.thursday: return 'Quinta';
      case DateTime.friday: return 'Sexta';
      case DateTime.saturday: return 'Sabado';
      default: return 'Domingo';
    }
  }

  Widget _linhaDetalheComIcone(IconData icone, String label, String valor, {Color? valorCor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valorCor),
            ),
          ),
        ],
      ),
    );
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

