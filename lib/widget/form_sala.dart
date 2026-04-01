import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_sala.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';

class FormSala extends StatefulWidget {
  const FormSala({super.key});

  @override
  State<FormSala> createState() => _FormSalaState();
}

class _FormSalaState extends State<FormSala> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOSala _daoSala = DAOSala();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;
  
  // Controllers para os campos
  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _numBikesControlador = TextEditingController();
  final TextEditingController _numFilasControlador = TextEditingController();
  final TextEditingController _limiteBikesControlador = TextEditingController();
  
  // Campos do formulário
  bool _ativa = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosEdicao();
    });
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _numBikesControlador.dispose();
    _numFilasControlador.dispose();
    _limiteBikesControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_dadosCarregados && _id != null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_erroCarregamento) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro ao carregar sala')),
        body: const Center(child: Text('Não foi possível carregar os dados da sala.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Sala' : 'Nova Sala'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _chaveFormulario,
          child: ListView(
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome da Sala',
                dica: 'Nome da sala',
                eObrigatorio: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numBikesControlador,
                      decoration: const InputDecoration(labelText: 'Nº Bikes'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Informe Nº de Bikes';
                        final n = int.tryParse(value);
                        if (n == null || n < 1) return 'Número positivo obrigatório';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _numFilasControlador,
                      decoration: const InputDecoration(labelText: 'Nº Filas'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Informe Nº de Filas';
                        final n = int.tryParse(value);
                        if (n == null || n < 1) return 'Número positivo obrigatório';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limiteBikesControlador,
                decoration: const InputDecoration(labelText: 'Limite Bikes por Fila'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o limite';
                  final n = int.tryParse(value);
                  if (n == null || n < 1) return 'Número positivo obrigatório';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativa'),
                value: _ativa,
                onChanged: (valor) {
                  setState(() => _ativa = valor);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _carregarDadosEdicao() {
    final argumentos = ModalRoute.of(context)?.settings.arguments;
    if (argumentos != null && argumentos is DTOSala) {
      try {
        _preencherCampos(argumentos);
        setState(() {
          _dadosCarregados = true;
          _erroCarregamento = false;
        });
      } catch (e) {
        setState(() {
          _erroCarregamento = true;
        });
      }
    } else {
      setState(() {
        _dadosCarregados = true;
        _erroCarregamento = false;
      });
    }
  }

  void _preencherCampos(DTOSala sala) {
    _id = sala.id;
    _nomeControlador.text = sala.nome;
    _numBikesControlador.text = sala.numeroBikes.toString();
    _numFilasControlador.text = sala.numeroFilas.toString();
    _limiteBikesControlador.text = sala.limiteBikesPorFila.toString();
    _ativa = sala.ativa;
  }

  void _limparCampos() {
    _id = null;
    _nomeControlador.clear();
    _numBikesControlador.clear();
    _numFilasControlador.clear();
    _limiteBikesControlador.clear();
    _ativa = true;
    setState(() {});
  }

  DTOSala _criarDTO() {
    final numBikes = int.parse(_numBikesControlador.text);
    final numFilas = int.parse(_numFilasControlador.text);
    final limiteBikes = int.parse(_limiteBikesControlador.text);

    // Criar grade básica
    List<List<bool>> gradeBikes = List.generate(
      numFilas + 1, // +1 fila da professora
      (_) => List.generate(limiteBikes, (_) => false),
    );

    // Preencher a bike da professora na fila 0 meio da fila
    if (limiteBikes > 0) {
      int bikeProf = limiteBikes ~/ 2;
      gradeBikes[0][bikeProf] = true;
    }

    // Distribuir bikes restantes
    int bikesRestantes = numBikes - 1;
    if (bikesRestantes < 0) bikesRestantes = 0;

    for (int fila = 1; fila <= numFilas && bikesRestantes > 0; fila++) {
      for (int bike = 0; bike < limiteBikes && bikesRestantes > 0; bike++) {
        gradeBikes[fila][bike] = true;
        bikesRestantes--;
      }
    }

    return DTOSala(
      id: _id,
      nome: _nomeControlador.text,
      numeroBikes: numBikes,
      numeroFilas: numFilas,
      limiteBikesPorFila: limiteBikes,
      gradeBikes: gradeBikes,
      ativa: _ativa,
    );
  }

  void _mostrarMensagem(String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.red : Colors.green,
      ),
    );
  }

  void _redirecionarAposSalvar() {
    // TODO: Implementar lógica de redirecionamento
    // Se for edição (_id != null): voltar para tela anterior
    // Se for novo item (_id == null): ir para lista de salas
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      try {
        final dto = _criarDTO();
        debugPrint(dto.toString());
        await _daoSala.salvar(dto);
        if (!mounted) return;
        _mostrarMensagem(_id != null ? 'Sala atualizada com sucesso!' : 'Sala criada com sucesso!');
        if (_id == null) {
          _limparCampos();
        }
        _redirecionarAposSalvar();
      } catch (e) {
        if (!mounted) return;
        _mostrarMensagem('Erro ao salvar sala: $e', erro: true);
      }
    }
  }
}
