import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_checkin.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_numero.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';

class FormCheckin extends StatefulWidget {
  const FormCheckin({super.key});

  @override
  State<FormCheckin> createState() => _FormCheckinState();
}

class _FormCheckinState extends State<FormCheckin> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOAluno _daoAluno = DAOAluno();
  final DAOTurma _daoTurma = DAOTurma();

  DTOAluno? _alunoSelecionado;
  DTOTurma? _turmaSelecionada;
  DateTime? _data;
  String _fila = '0';
  String _coluna = '0';
  bool _ativo = true;

  List<DTOAluno> _alunos = [];
  List<DTOTurma> _turmas = [];

  @override
  void initState() {
    super.initState();
    _carregarOpcoes();
  }

  Future<void> _carregarOpcoes() async {
    final alunos = await _daoAluno.buscarTodos();
    final turmas = await _daoTurma.buscarTodos();
    if (!mounted) return;
    setState(() {
      _alunos = alunos;
      _turmas = turmas;
    });
  }

  DTOCheckin _criarDTO() {
    return DTOCheckin(
      aluno: _alunoSelecionado!,
      turma: _turmaSelecionada!,
      data: _data ?? DateTime.now(),
      fila: int.tryParse(_fila) ?? 0,
      coluna: int.tryParse(_coluna) ?? 0,
      ativo: _ativo,
    );
  }

  Future<void> _salvar() async {
    if (!_chaveFormulario.currentState!.validate()) return;
    if (_alunoSelecionado == null || _turmaSelecionada == null || _data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatorios.')),
      );
      return;
    }

    final dto = _criarDTO();
    try {
      await _daoCheckin.reservarComValidacao(dto);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in registrado com sucesso!')),
      );
      Navigator.of(context).pop(dto);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Check-in'),
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
              CampoOpcoes<DTOAluno>(
                opcoes: _alunos,
                valorSelecionado: _alunoSelecionado,
                rotulo: 'Aluno',
                textoPadrao: 'Selecione o aluno',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroAluno,
                aoAlterar: (value) => setState(() => _alunoSelecionado = value),
              ),
              const SizedBox(height: 16),
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
              CampoData(
                rotulo: 'Data da aula',
                valor: _data,
                eObrigatorio: true,
                aoAlterar: (data) => setState(() => _data = data),
              ),
              const SizedBox(height: 16),
              CampoNumero(
                rotulo: 'Fila',
                eObrigatorio: true,
                limiteMinimo: 0,
                aoAlterar: (value) => _fila = value,
              ),
              const SizedBox(height: 16),
              CampoNumero(
                rotulo: 'Coluna',
                eObrigatorio: true,
                limiteMinimo: 0,
                aoAlterar: (value) => _coluna = value,
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

