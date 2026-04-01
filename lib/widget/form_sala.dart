import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_posicao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_sala.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';

class FormSala extends StatefulWidget {
  const FormSala({super.key});

  @override
  State<FormSala> createState() => _FormSalaState();
}

class _FormSalaState extends State<FormSala> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOSala _daoSala = DAOSala();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _numFilasControlador = TextEditingController();
  final TextEditingController _numColunasControlador = TextEditingController();
  final TextEditingController _posicaoProfessoraControlador = TextEditingController();

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
    _numFilasControlador.dispose();
    _numColunasControlador.dispose();
    _posicaoProfessoraControlador.dispose();
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
        body: const Center(child: Text('Nao foi possivel carregar os dados da sala.')),
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
              TextFormField(
                controller: _numFilasControlador,
                decoration: const InputDecoration(labelText: 'Numero de filas'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o numero de filas';
                  final n = int.tryParse(value);
                  if (n == null || n < 1) return 'Numero positivo obrigatorio';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numColunasControlador,
                decoration: const InputDecoration(labelText: 'Numero de colunas'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o numero de colunas';
                  final n = int.tryParse(value);
                  if (n == null || n < 1) return 'Numero positivo obrigatorio';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _posicaoProfessoraControlador,
                decoration: const InputDecoration(labelText: 'Posicao da professora (1..colunas)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a posicao da professora';
                  final n = int.tryParse(value);
                  if (n == null || n < 1) return 'Numero positivo obrigatorio';
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
      } catch (_) {
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
    _numFilasControlador.text = sala.numeroFilas.toString();
    _numColunasControlador.text = sala.numeroColunas.toString();
    _posicaoProfessoraControlador.text = (sala.posicaoProfessora + 1).toString();
    _ativa = sala.ativa;
  }

  void _limparCampos() {
    _id = null;
    _nomeControlador.clear();
    _numFilasControlador.clear();
    _numColunasControlador.clear();
    _posicaoProfessoraControlador.clear();
    _ativa = true;
    setState(() {});
  }

  DTOSala _criarDTO() {
    return DTOSala(
      id: _id,
      nome: _nomeControlador.text,
      numeroFilas: int.parse(_numFilasControlador.text),
      numeroColunas: int.parse(_numColunasControlador.text),
      posicaoProfessora: int.parse(_posicaoProfessoraControlador.text) - 1,
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

  Future<void> _salvar() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    final numFilas = int.tryParse(_numFilasControlador.text) ?? 0;
    final numColunas = int.tryParse(_numColunasControlador.text) ?? 0;
    final posicaoInformada = int.tryParse(_posicaoProfessoraControlador.text) ?? 0;
    if (posicaoInformada < 1 || posicaoInformada > numColunas) {
      _mostrarMensagem('A posicao da professora deve estar entre 1 e $numColunas.', erro: true);
      return;
    }

    if (_id != null) {
      final posicoes = await _daoPosicaoBike.buscarTodos();
      final extrapola = posicoes.any((p) => p.fila >= numFilas || p.coluna >= numColunas);
      if (extrapola) {
        _mostrarMensagem('Nao e permitido reduzir a grade com posicoes de bike fora do novo limite.', erro: true);
        return;
      }
    }

    try {
      final dto = _criarDTO();
      await _daoSala.salvar(dto);
      if (!mounted) return;
      _mostrarMensagem(_id != null ? 'Sala atualizada com sucesso!' : 'Sala criada com sucesso!');
      if (_id == null) {
        _limparCampos();
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem('Erro ao salvar sala: $e', erro: true);
    }
  }
}
