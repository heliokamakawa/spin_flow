import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_sala.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_hora.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_numero.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';

import 'componentes/campos/selecao_multipla/campo_dias_semana.dart';

class FormTurma extends StatefulWidget {
  const FormTurma({super.key});

  @override
  State<FormTurma> createState() => _FormTurmaState();
}

class _FormTurmaState extends State<FormTurma> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOTurma _daoTurma = DAOTurma();
  final DAOSala _daoSala = DAOSala();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;

  String? _nome;
  String _descricao = '';
  String _duracao = '';
  List<String> _diasSelecionados = [];
  String? _horarioInicio;
  DTOSala? _salaSelecionada;
  bool _ativo = true;

  List<DTOSala> _salas = [];

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _descricaoControlador = TextEditingController();

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
    _descricaoControlador.dispose();
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
        appBar: AppBar(title: const Text('Erro ao carregar turma')),
        body: const Center(child: Text('Nao foi possivel carregar os dados da turma.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(_id != null ? 'Editar Turma' : 'Cadastro de Turma')),
      body: Form(
        key: _chaveFormulario,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome da Turma',
                dica: 'Nome da turma',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descricao',
                dica: 'Descricao da turma (opcional)',
                eObrigatorio: false,
                aoAlterar: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              CampoDiasSemana(
                diasSelecionados: _diasSelecionados,
                rotulo: 'Dias da Semana',
                eObrigatorio: true,
                validador: (dias) => dias.isEmpty ? 'Selecione pelo menos um dia da semana' : null,
                aoAlterar: (List<String> novosDias) {
                  setState(() {
                    _diasSelecionados = novosDias;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoHora(
                rotulo: 'Hora Inicial',
                valor: _horarioInicio,
                aoAlterarString: (novoHorario) {
                  setState(() {
                    _horarioInicio = novoHorario;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoNumero(
                rotulo: 'Duracao da aula (minutos)',
                dica: 'Ex: 45',
                eObrigatorio: true,
                limiteMinimo: 1,
                limiteMaximo: 180,
                aoAlterar: (value) => _duracao = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOSala>(
                opcoes: _salas,
                valorSelecionado: _salaSelecionada,
                rotulo: 'Sala / Local da aula',
                rotaCadastro: Rotas.cadastroSala,
                aoAlterar: (DTOSala? novaSala) {
                  setState(() {
                    _salaSelecionada = novaSala;
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Ativo'),
                value: _ativo,
                onChanged: (bool? valor) {
                  setState(() {
                    _ativo = valor ?? true;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: Text(_id != null ? 'Atualizar turma' : 'Salvar turma'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _carregarDadosEdicao() async {
    final argumentos = ModalRoute.of(context)?.settings.arguments;
    try {
      final salas = await _daoSala.buscarTodos();
      if (!mounted) return;
      if (argumentos != null && argumentos is DTOTurma) {
        _preencherCampos(argumentos);
      }
      setState(() {
        _salas = salas;
        _dadosCarregados = true;
        _erroCarregamento = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = true;
      });
    }
  }

  void _preencherCampos(DTOTurma turma) {
    _id = turma.id;
    _nome = turma.nome;
    _descricao = turma.descricao;
    _nomeControlador.text = turma.nome;
    _descricaoControlador.text = turma.descricao;
    _diasSelecionados = List<String>.from(turma.diasSemana);
    _horarioInicio = turma.horarioInicio;
    _duracao = turma.duracaoMinutos > 0 ? turma.duracaoMinutos.toString() : '';
    _salaSelecionada = turma.sala;
    _ativo = turma.ativo;
  }

  void _limparCampos() {
    _id = null;
    _nome = null;
    _descricao = '';
    _duracao = '';
    _diasSelecionados = [];
    _horarioInicio = null;
    _salaSelecionada = null;
    _ativo = true;
    _nomeControlador.clear();
    _descricaoControlador.clear();
    setState(() {});
  }

  DTOTurma _criarDTO() {
    return DTOTurma(
      id: _id,
      nome: _nome ?? '',
      descricao: _descricao,
      diasSemana: _diasSelecionados,
      horarioInicio: _horarioInicio ?? '',
      duracaoMinutos: int.tryParse(_duracao) ?? 0,
      sala: _salaSelecionada!,
      ativo: _ativo,
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
    if (_id != null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(Rotas.listaTurmas);
    }
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate() == false) return;
    if ((_nome ?? '').isEmpty || _diasSelecionados.isEmpty || (_horarioInicio == null || _horarioInicio!.isEmpty) || _salaSelecionada == null) {
      _mostrarMensagem('Preencha todos os campos obrigatorios.', erro: true);
      return;
    }
    try {
      final dto = _criarDTO();
      await _daoTurma.salvar(dto);
      if (!mounted) return;
      _mostrarMensagem(_id != null ? 'Turma atualizada com sucesso!' : 'Turma criada com sucesso!');
      if (_id == null) {
        _limparCampos();
      }
      _redirecionarAposSalvar();
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem('Erro ao salvar turma: $e', erro: true);
    }
  }
}

