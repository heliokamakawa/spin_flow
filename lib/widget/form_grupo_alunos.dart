import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_grupo_alunos.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_multipla/campo_busca_multipla.dart';

class FormGrupoAlunos extends StatefulWidget {
  const FormGrupoAlunos({super.key});

  @override
  State<FormGrupoAlunos> createState() => _FormGrupoAlunosState();
}

class _FormGrupoAlunosState extends State<FormGrupoAlunos> {
  final _formKey = GlobalKey<FormState>();
  final DAOGrupoAlunos _daoGrupo = DAOGrupoAlunos();
  final DAOAluno _daoAluno = DAOAluno();

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _descricaoControlador = TextEditingController();

  String? _nome;
  String _descricao = '';
  List<DTOAluno> _alunosSelecionados = [];
  List<DTOAluno> _alunosDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  Future<void> _carregarAlunos() async {
    final alunos = await _daoAluno.buscarTodos();
    if (!mounted) return;
    setState(() {
      _alunosDisponiveis = alunos;
    });
  }

  String? _validaAlunosSelecionados() {
    if (_alunosSelecionados.isEmpty) return 'Selecione pelo menos um aluno';
    return null;
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = '';
      _alunosSelecionados.clear();
      _nomeControlador.clear();
      _descricaoControlador.clear();
    });
    _formKey.currentState?.reset();
  }

  Future<void> _salvar() async {
    final formValido = _formKey.currentState?.validate() ?? false;
    final alunosValidos = _validaAlunosSelecionados() == null;

    if (!formValido || !alunosValidos) {
      if (!alunosValidos) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_validaAlunosSelecionados()!)),
        );
      }
      return;
    }

    final dto = DTOGrupoAlunos(
      nome: _nome ?? '',
      descricao: _descricao,
      alunos: List.from(_alunosSelecionados),
    );

    await _daoGrupo.salvar(dto);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Grupo salvo com sucesso! ${dto.nome}')),
    );

    _limparFormulario();
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _descricaoControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Grupo de Alunos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome do Grupo',
                dica: 'Nome do grupo de alunos',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descricao',
                dica: 'Descricao do grupo (opcional)',
                eObrigatorio: false,
                aoAlterar: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              const Text('Alunos'),
              const SizedBox(height: 8),
              CampoBuscaMultipla<DTOAluno>(
                opcoes: _alunosDisponiveis,
                valoresSelecionados: _alunosSelecionados,
                rotulo: 'Alunos do Grupo',
                textoPadrao: 'Digite para buscar alunos...',
                rotaCadastro: Rotas.cadastroAluno,
                onChanged: (lista) => setState(() => _alunosSelecionados = lista),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

