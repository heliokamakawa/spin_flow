import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fila_espera_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_posicao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma_mix.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_usuario.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_checkin.dart';
import 'package:spin_flow/dto/dto_posicao_bike.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/dto/dto_turma_mix.dart';

class TelaMapaCheckin extends StatefulWidget {
  const TelaMapaCheckin({super.key});

  @override
  State<TelaMapaCheckin> createState() => _TelaMapaCheckinState();
}

class _TelaMapaCheckinState extends State<TelaMapaCheckin> {
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOAluno _daoAluno = DAOAluno();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();
  final DAOUsuario _daoUsuario = DAOUsuario();
  final DAOFilaEsperaCheckin _daoFilaEspera = DAOFilaEsperaCheckin();

  DTOTurma? _turma;
  DateTime? _data;
  DTOAluno? _alunoLogado;
  bool _carregando = true;
  List<DTOCheckin> _checkinsAtivos = [];
  List<DTOPosicaoBike> _posicoesBloqueadas = [];
  List<DTOPosicaoBike> _posicoesSala = [];
  DTOCheckin? _meuCheckin;
  DTOTurmaMix? _mixAtivo;
  String _nomeProfessora = 'Professora';
  int _filaEspera = 0;
  String? _erroCarregamento;

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
    if (_turma == null || _data == null) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = 'Turma/data não informados para abrir o mapa.';
        _carregando = false;
      });
      return;
    }
    setState(() {
      _carregando = true;
      _erroCarregamento = null;
    });

    try {
      final aluno = await _buscarAlunoLogado();
      final checkins = await _daoCheckin.buscarAtivosPorTurmaData(
        turmaId: _turma!.id ?? 0,
        data: _data!,
      );
      final bikesBloqueadas = await _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
      final posicoesBloqueadas = await _daoPosicaoBike.buscarPorBikeIds(bikesBloqueadas);
      final posicoesSala = (await _daoPosicaoBike.buscarTodos()).where((p) => _estaNaGrade(p)).toList();
      final mix = await _daoTurmaMix.buscarAtivoPorTurma(_turma!.id ?? 0, data: _data!);
      final professora = await _daoUsuario.buscarPrimeiraProfessoraAtiva();
      final fila = await _daoFilaEspera.buscarAtivosPorTurmaData(turmaId: _turma!.id ?? 0, data: _data!);

      DTOCheckin? meu;
      if (aluno != null) {
        for (final c in checkins) {
          if (c.aluno.id == aluno.id) {
            meu = c;
            break;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _alunoLogado = aluno;
        _checkinsAtivos = checkins;
        _posicoesBloqueadas = posicoesBloqueadas;
        _posicoesSala = posicoesSala;
        _meuCheckin = meu;
        _mixAtivo = mix;
        _nomeProfessora = (professora?['nome'] as String?) ?? 'Professora';
        _filaEspera = fila.length;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = 'Erro ao carregar mapa da turma: $e';
        _carregando = false;
      });
    }
  }

  Future<DTOAluno?> _buscarAlunoLogado() async {
    final email = SessaoUsuario.email;
    if (email == null || email.isEmpty) return null;
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  DTOPosicaoBike? _posicaoBike(int fila, int coluna) {
    for (final p in _posicoesSala) {
      if (p.fila == fila && p.coluna == coluna) return p;
    }
    return null;
  }

  Future<void> _reservar(int fila, int coluna) async {
    if (_alunoLogado == null || _turma == null || _data == null) return;
    if (_meuCheckin != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voce ja possui check-in ativo para esta turma e data.')),
      );
      return;
    }

    final dto = DTOCheckin(
      aluno: _alunoLogado!,
      turma: _turma!,
      data: _data!,
      fila: fila,
      coluna: coluna,
      ativo: true,
    );

    try {
      await _daoCheckin.reservarComValidacao(dto);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva realizada com sucesso!')),
      );
      await _carregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _cancelarMeuCheckin() async {
    if (_meuCheckin?.id == null) return;
    await _daoCheckin.cancelar(_meuCheckin!.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in cancelado. A fila de espera foi processada automaticamente.')),
    );
    await _carregar();
  }

  Future<void> _entrarFilaDeEspera() async {
    if (_alunoLogado?.id == null || _turma?.id == null || _data == null) return;
    try {
      await _daoFilaEspera.entrarNaFila(
        alunoId: _alunoLogado!.id!,
        turmaId: _turma!.id!,
        data: _data!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno inserido na fila de espera desta turma.')),
      );
      await _carregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _abrirModalMix() {
    if (_mixAtivo == null) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Mix da aula'),
          content: const Text('Nao ha mix ativo para esta turma.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final musicas = _mixAtivo!.mix.musicas;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 420,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_mixAtivo!.mix.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Periodo: ${_mixAtivo!.dataInicio.toString().split(' ')[0]} ate ${_mixAtivo!.dataFim.toString().split(' ')[0]}'),
                const SizedBox(height: 10),
                const Text('Musicas da aula', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Expanded(
                  child: ListView.builder(
                    itemCount: musicas.length,
                    itemBuilder: (_, index) {
                      final m = musicas[index];
                      return ListTile(
                        dense: true,
                        title: Text('${index + 1}. ${m.nome}'),
                        subtitle: Text('Artista: ${m.artista.nome}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _EstadoPosicao _estadoPosicao(int fila, int coluna) {
    if (_turma == null) return _EstadoPosicao.livre;
    if (fila == 0 && coluna == _turma!.sala.posicaoProfessora) {
      return _EstadoPosicao.professora;
    }

    final posicao = _posicaoBike(fila, coluna);
    if (posicao == null) {
      return _EstadoPosicao.semBike;
    }

    final bloqueada = _posicoesBloqueadas.any((p) => p.fila == fila && p.coluna == coluna);
    if (bloqueada) return _EstadoPosicao.bloqueada;

    DTOCheckin? checkin;
    for (final item in _checkinsAtivos) {
      if (item.fila == fila && item.coluna == coluna) {
        checkin = item;
        break;
      }
    }
    if (checkin == null) return _EstadoPosicao.livre;
    if (_alunoLogado != null && checkin.aluno.id == _alunoLogado!.id) {
      return _EstadoPosicao.minha;
    }
    return _EstadoPosicao.ocupada;
  }

  int _livresReservaveis() {
    if (_turma == null) return 0;
    int livres = 0;
    for (int fila = 0; fila < _turma!.sala.numeroFilas; fila++) {
      for (int coluna = 0; coluna < _turma!.sala.numeroColunas; coluna++) {
        if (_estadoPosicao(fila, coluna) == _EstadoPosicao.livre) {
          livres++;
        }
      }
    }
    return livres;
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_erroCarregamento != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa da Aula')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_erroCarregamento!, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    if (_turma == null || _data == null) {
      return const Scaffold(body: Center(child: Text('Dados de turma/data nao informados.')));
    }

    final filas = _turma!.sala.numeroFilas;
    final colunas = _turma!.sala.numeroColunas;
    final livres = _livresReservaveis();
    final mapaInvalido = filas <= 0 || colunas <= 0 || _posicoesSala.isEmpty;
    final reservaLiberada = _reservaLiberadaAgora();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa da Aula - ${_turma!.nome}'),
        actions: [
          IconButton(onPressed: _abrirModalMix, icon: const Icon(Icons.library_music)),
          IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data: ${_data!.toString().split(' ')[0]} | Horario: ${_turma!.horarioInicio}'),
                Text('Sala: ${_turma!.sala.nome} | Professora: $_nomeProfessora'),
                Text('Vagas livres: $livres | Fila de espera: $_filaEspera'),
                if (livres == 0)
                  const Text(
                    'Turma lotada no momento. Voce pode entrar na fila de espera.',
                    style: TextStyle(color: Colors.red),
                  ),
                if (!reservaLiberada)
                  const Text(
                    'Reserva bloqueada: liberada somente 30 minutos antes do início da aula.',
                    style: TextStyle(color: Colors.orange),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: const [
                    _Legenda(cor: Colors.green, texto: 'Livre'),
                    _Legenda(cor: Colors.red, texto: 'Ocupada'),
                    _Legenda(cor: Colors.grey, texto: 'Manutencao'),
                    _Legenda(cor: Colors.black45, texto: 'Sem bike'),
                    _Legenda(cor: Colors.orange, texto: 'Professora'),
                    _Legenda(cor: Colors.blue, texto: 'Minha reserva'),
                  ],
                ),
                if (_meuCheckin != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _cancelarMeuCheckin,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar meu check-in'),
                    ),
                  ),
                if (_meuCheckin == null && livres == 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _entrarFilaDeEspera,
                      icon: const Icon(Icons.queue),
                      label: const Text('Entrar na fila de espera'),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: mapaInvalido
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 42, color: Colors.orange),
                          const SizedBox(height: 12),
                          const Text(
                            'Turma sem mapa operacional configurado.\nNao e possivel reservar bike nesta turma.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Voltar'),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
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
                      final estado = _estadoPosicao(fila, coluna);
                      final posicao = _posicaoBike(fila, coluna);
                      final bike = posicao?.bike;

                      final podeReservar = estado == _EstadoPosicao.livre;
                      final rotuloBike = _rotuloBike(bike);

                      return InkWell(
                        onTap: podeReservar ? () => _reservar(fila, coluna) : null,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _corEstado(estado),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'F${fila + 1} C${coluna + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rotuloBike,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 11),
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

  String _rotuloBike(DTOBike? bike) {
    if (bike == null) return 'Sem bike';
    final id = bike.id?.toString() ?? '-';
    if (bike.numeroSerie.isNotEmpty) {
      return 'Bike $id\n${bike.numeroSerie}';
    }
    return 'Bike $id';
  }

  Color _corEstado(_EstadoPosicao estado) {
    switch (estado) {
      case _EstadoPosicao.livre:
        return Colors.green;
      case _EstadoPosicao.ocupada:
        return Colors.red;
      case _EstadoPosicao.professora:
        return Colors.orange;
      case _EstadoPosicao.minha:
        return Colors.blue;
      case _EstadoPosicao.bloqueada:
        return Colors.grey;
      case _EstadoPosicao.semBike:
        return Colors.black45;
    }
  }

  bool _estaNaGrade(DTOPosicaoBike p) {
    if (_turma == null) return false;
    return p.fila >= 0 && p.fila < _turma!.sala.numeroFilas && p.coluna >= 0 && p.coluna < _turma!.sala.numeroColunas;
  }

  bool _reservaLiberadaAgora() {
    if (_turma == null || _data == null) return false;
    final partes = _turma!.horarioInicio.split(':');
    final h = partes.isNotEmpty ? int.tryParse(partes[0]) ?? 0 : 0;
    final m = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    final inicio = DateTime(_data!.year, _data!.month, _data!.day, h, m);
    final limite = inicio.subtract(const Duration(minutes: 30));
    return !DateTime.now().isBefore(limite);
  }
}

enum _EstadoPosicao { livre, ocupada, professora, minha, bloqueada, semBike }

class _Legenda extends StatelessWidget {
  final Color cor;
  final String texto;

  const _Legenda({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, color: cor),
        const SizedBox(width: 4),
        Text(texto),
      ],
    );
  }
}
