import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fabricante.dart';
import 'package:spin_flow/widget/componentes/borda_com_titulo.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_telefone.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class FormFabricante extends StatefulWidget {
  const FormFabricante({super.key});

  @override
  State<FormFabricante> createState() => _FormFabricanteState();
}

class _FormFabricanteState extends State<FormFabricante> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOFabricante _daoFabricante = DAOFabricante();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _descricaoControlador = TextEditingController();
  final TextEditingController _responsavelControlador = TextEditingController();
  final TextEditingController _emailControlador = TextEditingController();
  final TextEditingController _telefoneControlador = TextEditingController();
  
  bool _ativo = true;

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
    _responsavelControlador.dispose();
    _emailControlador.dispose();
    _telefoneControlador.dispose();
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
        appBar: AppBar(title: const Text('Erro ao carregar fabricante')),
        body: const Center(child: Text('Não foi possível carregar os dados do fabricante.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Fabricante' : 'Novo Fabricante'),
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
              _camposFabricante(),
              _camposContato(),
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
    if (argumentos != null && argumentos is DTOFabricante) {
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

  void _preencherCampos(DTOFabricante fabricante) {
    _id = fabricante.id;
    _nomeControlador.text = fabricante.nome;
    _descricaoControlador.text = fabricante.descricao ?? '';
    _responsavelControlador.text = fabricante.nomeContatoPrincipal ?? '';
    _emailControlador.text = fabricante.emailContato ?? '';
    _telefoneControlador.text = fabricante.telefoneContato ?? '';
    _ativo = fabricante.ativo;
  }

  void _limparCampos() {
    _id = null;
    _nomeControlador.clear();
    _descricaoControlador.clear();
    _responsavelControlador.clear();
    _emailControlador.clear();
    _telefoneControlador.clear();
    _ativo = true;
    setState(() {});
  }

  DTOFabricante _criarDTO() {
    return DTOFabricante(
      id: _id,
      nome: _nomeControlador.text,
      descricao: _descricaoControlador.text.isEmpty ? null : _descricaoControlador.text,
      nomeContatoPrincipal: _responsavelControlador.text.isEmpty ? null : _responsavelControlador.text,
      emailContato: _emailControlador.text.isEmpty ? null : _emailControlador.text,
      telefoneContato: _telefoneControlador.text.isEmpty ? null : _telefoneControlador.text,
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
      Navigator.of(context).pushReplacementNamed(Rotas.listaFabricantes);
    }
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      try {
        final dto = _criarDTO();
        debugPrint(dto.toString());
        await _daoFabricante.salvar(dto);
        if (!mounted) return;
        _mostrarMensagem(_id != null ? 'Fabricante atualizado com sucesso!' : 'Fabricante criado com sucesso!');
        if (_id == null) {
          _limparCampos();
        }
        _redirecionarAposSalvar();
      } catch (e) {
        if (!mounted) return;
        _mostrarMensagem('Erro ao salvar fabricante: $e', erro: true);
      }
    }
  }

  Widget _camposFabricante() {
    return BordaComTitulo(
      titulo: 'Fabricante',
      filhos: [
        CampoTexto(
          controle: _nomeControlador,
          rotulo: 'Nome*',
          dica: 'Nome do fabricante',
          eObrigatorio: true,
        ),
        const SizedBox(height: 12),
        CampoTexto(
          controle: _descricaoControlador,
          rotulo: 'Descrição',
          dica: 'Descrição opcional',
          eObrigatorio: false,
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Ativo'),
          value: _ativo,
          onChanged: (valor) {
            setState(() => _ativo = valor);
          },
        ),
      ],
    );
  }

  Widget _camposContato() {
    return BordaComTitulo(
      titulo: 'Contato',
      filhos: [
        CampoTexto(
          controle: _responsavelControlador,
          rotulo: 'Responsável',
          dica: 'Nome do responsável',
          eObrigatorio: false,
        ),
        const SizedBox(height: 16),
        CampoEmail(
          controle: _emailControlador,
          rotulo: 'E-mail',
          eObrigatorio: false,
        ),
        const SizedBox(height: 16),
        CampoTelefone(
          controle: _telefoneControlador,
          rotulo: 'Telefone',
          eObrigatorio: false,
        ),
      ],
    );
  }
}



