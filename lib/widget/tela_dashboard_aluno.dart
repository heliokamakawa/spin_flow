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

  // Indicadores Meu Painel (RF-CA-4.2.8)
  int _totalAulas3Meses = 0;
  double _presencaMedia = 0;
  int _sequenciaAtual = 0;
  int _melhorSequencia = 0;

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
    int totalAulas3Meses = 0;
    double presencaMedia = 0;
    int sequenciaAtual = 0;
    int melhorSequencia = 0;

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

      // Indicadores (RF-CA-4.2.8)
      final limite3Meses = DateTime(hoje.year, hoje.month - 3, hoje.day);
      final passados = checkins.where((c) {
        final d = DateTime(c.data.year, c.data.month, c.data.day);
        return d.isBefore(hojeData) && d.isAfter(limite3Meses);
      }).toList();
      totalAulas3Meses = passados.where((c) => c.ativo).length;
      final totalPassados = passados.length;
      presencaMedia = totalPassados > 0 ? (passados.where((c) => c.ativo).length / totalPassados) * 100 : 0;

      // Sequência consecutiva de presenças
      final checkinsPorData = List.of(checkins)
        ..sort((a, b) => b.data.compareTo(a.data));
      int seqAtual = 0;
      int seqMelhor = 0;
      int seqTemp = 0;
      bool contandoAtual = true;
      for (final c in checkinsPorData) {
        final d = DateTime(c.data.year, c.data.month, c.data.day);
        if (d.isAfter(hojeData) || d.isAtSameMomentAs(hojeData)) continue;
        if (c.ativo) {
          seqTemp++;
          if (contandoAtual) seqAtual = seqTemp;
        } else {
          if (seqTemp > seqMelhor) seqMelhor = seqTemp;
          seqTemp = 0;
          contandoAtual = false;
        }
      }
      if (seqTemp > seqMelhor) seqMelhor = seqTemp;
      melhorSequencia = seqMelhor;
      sequenciaAtual = seqAtual;
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
      _totalAulas3Meses = totalAulas3Meses;
      _presencaMedia = presencaMedia;
      _sequenciaAtual = sequenciaAtual;
      _melhorSequencia = melhorSequencia;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Painel'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarResumo,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple.shade400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(radius: 28, child: Icon(Icons.person, size: 32)),
                  const SizedBox(height: 8),
                  Text(SessaoUsuario.nome ?? 'Aluno', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(SessaoUsuario.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pin_drop),
              title: const Text('Check-in'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Rotas.checkinAluno);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Meu Painel'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Rotas.historicoAluno);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Rotas.perfil);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                SessaoUsuario.encerrar();
                Navigator.pushReplacementNamed(context, Rotas.login);
              },
            ),
          ],
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Resumo geral (mockup B.3 - 2.1)
                const Text('Resumo geral', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _resumoGrandeCard('Aulas realizadas', '$_concluidasMes', 'Este mes'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _resumoGrandeCard('Presenca', '${_presencaMedia.toStringAsFixed(0)}%', 'Este mes'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Indicadores (mockup B.3 - 2.1: rows com ícone + label + valor)
                const Text('Indicadores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _indicadorRow(Icons.fitness_center, 'Total de aulas', 'Ultimos 3 meses', '$_totalAulas3Meses'),
                _indicadorRow(Icons.pie_chart_outline, 'Presenca media', 'Ultimos 3 meses', '${_presencaMedia.toStringAsFixed(0)}%'),
                _indicadorRow(Icons.local_fire_department, 'Sequencia atual', 'Consecutivos', '$_sequenciaAtual aulas'),
                _indicadorRow(Icons.emoji_events, 'Melhor sequencia', 'Consecutivos', '$_melhorSequencia aulas'),
                const SizedBox(height: 8),

                _indicadorRow(Icons.today, 'Turmas hoje', '', '$_aulasHoje'),
                _indicadorRow(Icons.event_available, 'Agendadas', 'Proximas', '$_agendadas'),
                const SizedBox(height: 8),

                // Próxima aula
                if (_proximaAula != '-') ...[
                  const SizedBox(height: 12),
                  const Text('Proxima aula', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.schedule, color: Colors.purple.shade400),
                      title: Text(_proximaAula),
                      subtitle: const Text('Hoje'),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                _cardCheckinDestaque(context),
                const SizedBox(height: 16),

                // Acessos rápidos (mockup B.3 - 1.2)
                const Text('Acessos rapidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _tile(context, 'Historico de aulas', Icons.history, Rotas.historicoAluno),
                _tile(context, 'Indicadores', Icons.bar_chart, Rotas.indicadoresDetalhadosAluno),
                _tile(context, 'Agenda completa', Icons.calendar_month, Rotas.agendaAluno),
                _tile(context, 'Mix da turma', Icons.music_note, Rotas.mixTurmaAluno),
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

  Widget _resumoGrandeCard(String titulo, String valor, String subtitulo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(valor, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitulo, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _indicadorRow(IconData icone, String titulo, String subtitulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.purple.shade50,
            child: Icon(icone, size: 18, color: Colors.purple.shade400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitulo, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

