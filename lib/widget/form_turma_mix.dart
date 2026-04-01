import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_mix.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma_mix.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/dto/dto_turma_mix.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';

class FormTurmaMix extends StatefulWidget {
  const FormTurmaMix({super.key});

  @override
  State<FormTurmaMix> createState() => _FormTurmaMixState();
}

class _FormTurmaMixState extends State<FormTurmaMix> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();
  final DAOTurma _daoTurma = DAOTurma();
  final DAOMix _daoMix = DAOMix();

  DTOTurma? _turmaSelecionada;
  DTOMix? _mixSelecionado;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _ativo = true;

  List<DTOTurma> _turmas = [];
  List<DTOMix> _mixes = [];

  @override
  void initState() {
    super.initState();
    _carregarOpcoes();
  }

  Future<void> _carregarOpcoes() async {
    final turmas = await _daoTurma.buscarTodos();
    final mixes = await _daoMix.buscarTodos();
    if (!mounted) return;
    setState(() {
      _turmas = turmas;
      _mixes = mixes;
    });
  }

  DTOTurmaMix _criarDTO() {
    return DTOTurmaMix(
      turma: _turmaSelecionada!,
      mix: _mixSelecionado!,
      dataInicio: _dataInicio ?? DateTime.now(),
      dataFim: _dataFim ?? _dataInicio ?? DateTime.now(),
      ativo: _ativo,
    );
  }

  Future<void> _salvar() async {
    if (!_chaveFormulario.currentState!.validate()) return;
    if (_turmaSelecionada == null || _mixSelecionado == null || _dataInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatorios.')),
      );
      return;
    }

    final dto = _criarDTO();
    await _daoTurmaMix.salvar(dto);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TurmaMix registrado com sucesso!')),
    );
    Navigator.of(context).pop(dto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de TurmaMix'),
        actions: [
          IconButton(onPressed: _salvar, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _chaveFormulario,
          child: ListView(
            children: [
              CampoOpcoes<DTOTurma>(
                opcoes: _turmas,
                valorSelecionado: _turmaSelecionada,
                rotulo: 'Turma',
                textoPadrao: 'Selecione a turma',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroTurma,
                aoAlterar: (value) => setState(() => _turmaSelecionada = value),
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOMix>(
                opcoes: _mixes,
                valorSelecionado: _mixSelecionado,
                rotulo: 'Mix',
                textoPadrao: 'Selecione o mix',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroMix,
                aoAlterar: (value) => setState(() => _mixSelecionado = value),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de inicio',
                valor: _dataInicio,
                eObrigatorio: true,
                aoAlterar: (data) => setState(() => _dataInicio = data),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de fim',
                valor: _dataFim,
                eObrigatorio: false,
                aoAlterar: (data) => setState(() => _dataFim = data),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _ativo,
                onChanged: (value) => setState(() => _ativo = value),
                title: const Text('Ativo'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}

