import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_posicao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/dto/dto_checkin.dart';
import 'package:spin_flow/dto/dto_posicao_bike.dart';
import 'package:spin_flow/dto/dto_turma.dart';

class TelaMapaOperacionalProfessora extends StatefulWidget {
  const TelaMapaOperacionalProfessora({super.key});

  @override
  State<TelaMapaOperacionalProfessora> createState() => _TelaMapaOperacionalProfessoraState();
}

class _TelaMapaOperacionalProfessoraState extends State<TelaMapaOperacionalProfessora> {
  final DAOTurma _daoTurma = DAOTurma();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();

  List<DTOTurma> _turmas = [];
  DTOTurma? _turmaSelecionada;
  DateTime _data = DateTime.now();
  bool _carregando = true;
  List<DTOCheckin> _checkins = [];
  List<DTOPosicaoBike> _bloqueadas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final turmas = await _daoTurma.buscarAtivas();
    DTOTurma? turma = _turmaSelecionada;
    if (turma == null && turmas.isNotEmpty) turma = turmas.first;

    List<DTOCheckin> checkins = [];
    if (turma != null) {
      checkins = await _daoCheckin.buscarAtivosPorTurmaData(turmaId: turma.id ?? 0, data: _data);
    }

    final bikesBloqueadas = await _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
    final posicoesBloqueadas = await _daoPosicaoBike.buscarPorBikeIds(bikesBloqueadas);

    if (!mounted) return;
    setState(() {
      _turmas = turmas;
      _turmaSelecionada = turma;
      _checkins = checkins;
      _bloqueadas = posicoesBloqueadas;
      _carregando = false;
    });
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data == null) return;
    setState(() => _data = data);
    await _carregar();
  }

  DTOCheckin? _checkinNaPosicao(int fila, int coluna) {
    for (final c in _checkins) {
      if (c.fila == fila && c.coluna == coluna) return c;
    }
    return null;
  }

  Future<void> _cancelarCheckin(DTOCheckin c) async {
    if (c.id == null) return;
    final confirma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar check-in'),
        content: Text('Cancelar reserva de ${c.aluno.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Nao')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sim')),
        ],
      ),
    );
    if (confirma != true) return;

    await _daoCheckin.cancelar(c.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in cancelado com sucesso.')),
    );
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_turmaSelecionada == null) {
      return const Scaffold(body: Center(child: Text('Nenhuma turma ativa disponivel.')));
    }

    final turma = _turmaSelecionada!;
    final filas = turma.sala.numeroFilas;
    final colunas = turma.sala.numeroColunas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Operacional (Professora)'),
        actions: [
          IconButton(onPressed: _selecionarData, icon: const Icon(Icons.calendar_month)),
          IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                DropdownButtonFormField<DTOTurma>(
                  value: turma,
                  items: _turmas
                      .map((t) => DropdownMenuItem<DTOTurma>(value: t, child: Text('${t.nome} - ${t.horarioInicio}')))
                      .toList(),
                  onChanged: (v) async {
                    setState(() => _turmaSelecionada = v);
                    await _carregar();
                  },
                  decoration: const InputDecoration(labelText: 'Turma'),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Data: ${_data.toString().split(' ')[0]} | Sala: ${turma.sala.nome}'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colunas,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filas * colunas,
              itemBuilder: (context, index) {
                final fila = index ~/ colunas;
                final coluna = index % colunas;
                final isProf = fila == 0 && coluna == turma.sala.posicaoProfessora;
                final checkin = _checkinNaPosicao(fila, coluna);

                Color cor = Colors.green;
                String texto = 'Livre';
                VoidCallback? onTap;

                if (isProf) {
                  cor = Colors.orange;
                  texto = 'Prof';
                } else if (_bloqueadas.any((p) => p.fila == fila && p.coluna == coluna)) {
                  cor = Colors.grey;
                  texto = 'Manut';
                } else if (checkin != null) {
                  cor = Colors.red;
                  texto = checkin.aluno.nome;
                  onTap = () => _cancelarCheckin(checkin);
                }

                return InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('F${fila + 1} C${coluna + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          texto,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

