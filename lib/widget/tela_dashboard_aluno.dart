import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';
import 'package:spin_flow/dto/dto_turma.dart';

class TelaDashboardAluno extends StatefulWidget {
  const TelaDashboardAluno({super.key});

  @override
  State<TelaDashboardAluno> createState() => _TelaDashboardAlunoState();
}

class _TelaDashboardAlunoState extends State<TelaDashboardAluno> {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOTurma _daoTurma = DAOTurma();

  bool _carregando = true;
  int _aulasHoje = 0;
  int _agendadas = 0;
  int _concluidasMes = 0;
  String _proximaAula = '-';

  @override
  void initState() {
    super.initState();
    _carregarResumo();
  }

  Future<void> _carregarResumo() async {
    setState(() => _carregando = true);
    final email = SessaoUsuario.email;
    final aluno = email == null ? null : await _daoAluno.buscarPorEmailAtivo(email);

    final hoje = DateTime.now();
    final hojeData = DateTime(hoje.year, hoje.month, hoje.day);

    int agendadas = 0;
    int concluidasMes = 0;
    if (aluno != null) {
      final checkins = await _daoCheckin.buscarPorAluno(aluno.id ?? 0);
      final ativos = checkins.where((c) => c.ativo).toList();
      agendadas = ativos.where((c) {
        final d = DateTime(c.data.year, c.data.month, c.data.day);
        return d.isAtSameMomentAs(hojeData) || d.isAfter(hojeData);
      }).length;
      concluidasMes = ativos.where((c) {
        final d = DateTime(c.data.year, c.data.month, c.data.day);
        return d.isBefore(hojeData) && d.year == hoje.year && d.month == hoje.month;
      }).length;
    }

    final turmas = await _daoTurma.buscarAtivas();
    final turmasHoje = turmas.where((t) => _diaCompativel(t, hojeData)).toList()
      ..sort((a, b) => a.horarioInicio.compareTo(b.horarioInicio));

    String proxima = '-';
    for (final t in turmasHoje) {
      final inicio = _inicioAula(t, hojeData);
      if (inicio.isAfter(hoje)) {
        proxima = '${t.nome} - ${t.horarioInicio}';
        break;
      }
    }

    if (!mounted) return;
    setState(() {
      _aulasHoje = turmasHoje.length;
      _agendadas = agendadas;
      _concluidasMes = concluidasMes;
      _proximaAula = proxima;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Aluno'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarResumo,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              SessaoUsuario.encerrar();
              Navigator.pushReplacementNamed(context, Rotas.login);
            },
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _cardCheckinDestaque(context),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(SessaoUsuario.nome ?? 'Aluno'),
                    subtitle: Text(SessaoUsuario.email ?? ''),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Resumo rapido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoCard('Turmas hoje', '$_aulasHoje', Icons.today),
                    _infoCard('Agendadas', '$_agendadas', Icons.event_available),
                    _infoCard('Concluidas no mes', '$_concluidasMes', Icons.insights),
                    _infoCard('Proxima aula', _proximaAula, Icons.schedule),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Outras opcoes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _tile(context, 'Meu historico e metricas', Icons.insights, Rotas.historicoAluno),
                _tile(context, 'Agenda completa', Icons.calendar_month, Rotas.agendaAluno),
              ],
            ),
    );
  }

  Widget _cardCheckinDestaque(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Check-in da aula', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Veja as turmas disponiveis hoje e reserve sua bike de forma grafica.'),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, Rotas.checkinAluno),
                icon: const Icon(Icons.pin_drop),
                label: const Text('Fazer check-in agora'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String titulo, String valor, IconData icone) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 18),
          const SizedBox(height: 6),
          Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(valor, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String titulo, IconData icone, String rota) {
    return Card(
      child: ListTile(
        leading: Icon(icone),
        title: Text(titulo),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, rota),
      ),
    );
  }

  bool _diaCompativel(DTOTurma turma, DateTime data) {
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

  DateTime _inicioAula(DTOTurma turma, DateTime dataAula) {
    final partes = turma.horarioInicio.split(':');
    final h = partes.isNotEmpty ? int.tryParse(partes[0]) ?? 0 : 0;
    final m = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    return DateTime(dataAula.year, dataAula.month, dataAula.day, h, m);
  }
}

