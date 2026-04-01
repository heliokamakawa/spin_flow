import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fila_espera_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_posicao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_posicao_bike.dart';
import 'package:spin_flow/dto/dto_turma.dart';

class TelaCheckinAluno extends StatefulWidget {
  const TelaCheckinAluno({super.key});

  @override
  State<TelaCheckinAluno> createState() => _TelaCheckinAlunoState();
}

class _TelaCheckinAlunoState extends State<TelaCheckinAluno> {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOTurma _daoTurma = DAOTurma();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  final DAOFilaEsperaCheckin _daoFilaEspera = DAOFilaEsperaCheckin();

  bool _carregando = true;
  final DateTime _hoje = DateTime.now();
  List<_ResumoTurmaHoje> _resumos = [];
  String? _erroCarregamento;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erroCarregamento = null;
    });
    try {
      final turmas = await _daoTurma.buscarAtivas();
      final bikesBloqueadas = await _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
      final posicoesBloqueadas = await _daoPosicaoBike.buscarPorBikeIds(bikesBloqueadas);
      final posicoesTodas = await _daoPosicaoBike.buscarTodos();

      final List<_ResumoTurmaHoje> lista = [];
      for (final t in turmas) {
        if (!_diaCompativel(t, _hoje)) continue;

        final checkins = await _daoCheckin.buscarAtivosPorTurmaData(turmaId: t.id ?? 0, data: _hoje);
        final fila = await _daoFilaEspera.buscarAtivosPorTurmaData(turmaId: t.id ?? 0, data: _hoje);

        final posicionadas = posicoesTodas.where((p) => _estaNaGrade(p, t)).toList();
        final bloqueadas = posicoesBloqueadas.where((p) => _estaNaGrade(p, t)).toList();

        final reservaveis = posicionadas.where((p) => !_ehProfessora(t, p) && !_contido(bloqueadas, p)).length;
        if (reservaveis <= 0) {
          continue;
        }
        final vagas = (reservaveis - checkins.length).clamp(0, reservaveis);

        lista.add(
          _ResumoTurmaHoje(
            turma: t,
            reservaveis: reservaveis,
            vagas: vagas,
            filaEspera: fila.length,
            checkinsAtivos: checkins.length,
            podeReservarAgora: _podeReservarAgora(t),
          ),
        );
      }

      lista.sort((a, b) => a.turma.horarioInicio.compareTo(b.turma.horarioInicio));

      if (!mounted) return;
      setState(() {
        _resumos = lista;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = 'Erro ao carregar turmas para check-in: $e';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in de Hoje'),
        actions: [IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh))],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erroCarregamento != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_erroCarregamento!, textAlign: TextAlign.center),
                  ),
                )
              : _resumos.isEmpty
                  ? const Center(child: Text('Nao ha turmas disponiveis para hoje.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _resumos.length,
                      itemBuilder: (context, index) {
                        final r = _resumos[index];
                        final lotada = r.vagas == 0;
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
                                        r.turma.nome,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                    Chip(
                                      label: Text(lotada ? 'Lotada' : 'Vagas: ${r.vagas}/${r.reservaveis}'),
                                      backgroundColor: lotada ? Colors.red.shade100 : Colors.green.shade100,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text('Horario: ${r.turma.horarioInicio}'),
                                Text('Sala: ${r.turma.sala.nome}'),
                                Text('Fila de espera: ${r.filaEspera}'),
                                Text('Check-ins ativos: ${r.checkinsAtivos}'),
                                Text(
                                  r.podeReservarAgora
                                      ? 'Reserva liberada (janela de 30 min aberta).'
                                      : 'Reserva ainda bloqueada: abre 30 min antes da aula.',
                                  style: TextStyle(color: r.podeReservarAgora ? Colors.green : Colors.orange.shade800),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _aoTocarTurma(r),
                                    icon: Icon(lotada ? Icons.queue : Icons.map),
                                    label: Text(lotada ? 'Turma lotada' : 'Abrir mapa da aula'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  Future<void> _aoTocarTurma(_ResumoTurmaHoje resumo) async {
    if (!resumo.podeReservarAgora) {
      final inicio = _inicioAula(resumo.turma, _hoje);
      final limite = inicio.subtract(const Duration(minutes: 30));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reserva bloqueada. Liberada a partir de ${_formatarHora(limite)}.'),
        ),
      );
      return;
    }

    if (resumo.vagas == 0) {
      await _mostrarDialogoTurmaLotada(resumo);
      return;
    }

    if (!mounted) return;
    await Navigator.pushNamed(
      context,
      Rotas.mapaCheckin,
      arguments: {
        'turma': resumo.turma,
        'data': DateTime(_hoje.year, _hoje.month, _hoje.day),
      },
    );
    await _carregar();
  }

  Future<void> _mostrarDialogoTurmaLotada(_ResumoTurmaHoje resumo) async {
    final entrarNaFila = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Turma lotada'),
        content: Text(
          'A turma ${resumo.turma.nome} esta sem vagas no momento. Deseja entrar na fila de espera?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Entrar na fila'),
          ),
        ],
      ),
    );

    if (entrarNaFila == true) {
      await _entrarFilaDeEspera(resumo);
    }
  }

  Future<void> _entrarFilaDeEspera(_ResumoTurmaHoje resumo) async {
    try {
      final aluno = await _buscarAlunoLogado();
      if (aluno?.id == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aluno logado nao encontrado para entrar na fila de espera.')),
        );
        return;
      }

      final jaTemCheckin = await _daoCheckin.existeCheckinAtivoAluno(
        alunoId: aluno!.id!,
        turmaId: resumo.turma.id ?? 0,
        data: _hoje,
      );
      if (jaTemCheckin) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Voce ja possui check-in ativo para esta turma.')),
        );
        return;
      }

      await _daoFilaEspera.entrarNaFila(
        alunoId: aluno.id!,
        turmaId: resumo.turma.id ?? 0,
        data: _hoje,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voce entrou na fila de espera da turma.')),
      );
      await _carregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<DTOAluno?> _buscarAlunoLogado() async {
    final email = SessaoUsuario.email;
    if (email == null || email.trim().isEmpty) return null;
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  bool _diaCompativel(DTOTurma turma, DateTime data) {
    final dia = _nomeDia(data);
    if (turma.diasSemana.contains(dia)) return true;
    if (dia == 'Sab' && turma.diasSemana.contains('Sáb')) return true;
    return false;
  }

  bool _podeReservarAgora(DTOTurma turma) {
    final inicio = _inicioAula(turma, _hoje);
    final limite = inicio.subtract(const Duration(minutes: 30));
    return !DateTime.now().isBefore(limite);
  }

  DateTime _inicioAula(DTOTurma turma, DateTime dataAula) {
    final partes = turma.horarioInicio.split(':');
    final h = partes.isNotEmpty ? int.tryParse(partes[0]) ?? 0 : 0;
    final m = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    return DateTime(dataAula.year, dataAula.month, dataAula.day, h, m);
  }

  String _formatarHora(DateTime data) {
    final h = data.hour.toString().padLeft(2, '0');
    final m = data.minute.toString().padLeft(2, '0');
    return '$h:$m';
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

  bool _estaNaGrade(DTOPosicaoBike p, DTOTurma turma) {
    return p.fila >= 0 &&
        p.fila < turma.sala.numeroFilas &&
        p.coluna >= 0 &&
        p.coluna < turma.sala.numeroColunas;
  }

  bool _ehProfessora(DTOTurma turma, DTOPosicaoBike p) {
    return p.fila == 0 && p.coluna == turma.sala.posicaoProfessora;
  }

  bool _contido(List<DTOPosicaoBike> lista, DTOPosicaoBike alvo) {
    return lista.any((p) => p.fila == alvo.fila && p.coluna == alvo.coluna);
  }
}

class _ResumoTurmaHoje {
  final DTOTurma turma;
  final int reservaveis;
  final int vagas;
  final int filaEspera;
  final int checkinsAtivos;
  final bool podeReservarAgora;

  _ResumoTurmaHoje({
    required this.turma,
    required this.reservaveis,
    required this.vagas,
    required this.filaEspera,
    required this.checkinsAtivos,
    required this.podeReservarAgora,
  });
}
