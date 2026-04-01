import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_posicao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_sala.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_posicao_bike.dart';
import 'package:spin_flow/dto/dto_sala.dart';

class TelaPosicionamentoBikes extends StatefulWidget {
  const TelaPosicionamentoBikes({super.key});

  @override
  State<TelaPosicionamentoBikes> createState() => _TelaPosicionamentoBikesState();
}

class _TelaPosicionamentoBikesState extends State<TelaPosicionamentoBikes> {
  final DAOSala _daoSala = DAOSala();
  final DAOBike _daoBike = DAOBike();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();

  bool _carregando = true;
  List<DTOSala> _salas = [];
  List<DTOBike> _bikes = [];
  List<DTOPosicaoBike> _posicoes = [];
  DTOSala? _salaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final salas = await _daoSala.buscarTodos();
    final bikes = await _daoBike.buscarTodos();
    final posicoes = await _daoPosicaoBike.buscarTodos();

    final salasAtivas = salas.where((s) => s.ativa).toList();
    final bikesAtivas = bikes.where((b) => b.ativa).toList();

    if (!mounted) return;
    setState(() {
      _salas = salasAtivas;
      _bikes = bikesAtivas;
      _posicoes = posicoes;
      _salaSelecionada = _salaSelecionada ?? (salasAtivas.isNotEmpty ? salasAtivas.first : null);
      _carregando = false;
    });
  }

  DTOPosicaoBike? _posicaoEm(int fila, int coluna) {
    for (final p in _posicoes) {
      if (p.fila == fila && p.coluna == coluna) return p;
    }
    return null;
  }

  Future<void> _abrirAtribuicao(int fila, int coluna) async {
    final atual = _posicaoEm(fila, coluna);
    DTOBike? bikeSelecionada = atual?.bike;

    final bikesJaUsadas = _posicoes.map((p) => p.bike.id).whereType<int>().toSet();

    final bikesDisponiveis = _bikes.where((b) {
      final id = b.id;
      if (id == null) return false;
      if (atual != null && id == atual.bike.id) return true;
      return !bikesJaUsadas.contains(id);
    }).toList();

    final acao = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Posicao F${fila + 1} C${coluna + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<DTOBike>(
                    value: bikeSelecionada,
                    items: bikesDisponiveis
                        .map((b) => DropdownMenuItem<DTOBike>(value: b, child: Text('${b.nome} (${b.numeroSerie})')))
                        .toList(),
                    onChanged: (v) => setModalState(() => bikeSelecionada = v),
                    decoration: const InputDecoration(labelText: 'Bike'),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (atual != null)
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'remover'),
                          child: const Text('Remover da posicao'),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'cancelar'),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: bikeSelecionada == null ? null : () => Navigator.pop(context, 'salvar'),
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (acao == 'remover') {
      await _daoPosicaoBike.excluirPorPosicao(fila: fila, coluna: coluna);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bike removida da posicao.')),
      );
      await _carregar();
      return;
    }

    if (acao == 'salvar' && bikeSelecionada != null) {
      await _daoPosicaoBike.salvar(
        DTOPosicaoBike(fila: fila, coluna: coluna, bike: bikeSelecionada!),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Posicionamento atualizado.')),
      );
      await _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_salaSelecionada == null) {
      return const Scaffold(body: Center(child: Text('Nenhuma sala ativa disponivel.')));
    }

    final sala = _salaSelecionada!;
    final total = sala.numeroFilas * sala.numeroColunas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posicionamento de Bikes'),
        actions: [IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<DTOSala>(
              value: sala,
              items: _salas
                  .map((s) => DropdownMenuItem<DTOSala>(value: s, child: Text('${s.nome} (${s.numeroFilas}x${s.numeroColunas})')))
                  .toList(),
              onChanged: (v) => setState(() => _salaSelecionada = v),
              decoration: const InputDecoration(labelText: 'Sala'),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: sala.numeroColunas,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: total,
              itemBuilder: (context, index) {
                final fila = index ~/ sala.numeroColunas;
                final coluna = index % sala.numeroColunas;
                final posicao = _posicaoEm(fila, coluna);
                final isProf = fila == 0 && coluna == sala.posicaoProfessora;

                Color cor = Colors.green;
                String texto = 'Livre';

                if (isProf) {
                  cor = Colors.orange;
                  texto = 'Professora';
                } else if (posicao != null) {
                  cor = Colors.blue;
                  texto = posicao.bike.nome;
                }

                return InkWell(
                  onTap: isProf ? null : () => _abrirAtribuicao(fila, coluna),
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
