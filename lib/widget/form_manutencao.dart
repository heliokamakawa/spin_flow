import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_tipo_manutencao.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_manutencao.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';

class FormManutencao extends StatefulWidget {
  const FormManutencao({super.key});

  @override
  State<FormManutencao> createState() => _FormManutencaoState();
}

class _FormManutencaoState extends State<FormManutencao> {
  final _chaveFormulario = GlobalKey<FormState>();
  final TextEditingController _descricaoControlador = TextEditingController();
  final DAOBike _daoBike = DAOBike();
  final DAOTipoManutencao _daoTipo = DAOTipoManutencao();
  final DAOManutencao _daoManutencao = DAOManutencao();

  DTOBike? _bikeSelecionada;
  DTOTipoManutencao? _tipoSelecionado;
  DateTime? _dataSolicitacao;
  DateTime? _dataRealizacao;
  bool _ativo = true;

  List<DTOBike> _bikes = [];
  List<DTOTipoManutencao> _tipos = [];

  @override
  void initState() {
    super.initState();
    _carregarOpcoes();
  }

  Future<void> _carregarOpcoes() async {
    final bikes = await _daoBike.buscarTodos();
    final tipos = await _daoTipo.buscarTodos();
    if (!mounted) return;
    setState(() {
      _bikes = bikes;
      _tipos = tipos;
    });
  }

  @override
  void dispose() {
    _descricaoControlador.dispose();
    super.dispose();
  }

  DTOManutencao _criarDTO() {
    return DTOManutencao(
      bike: _bikeSelecionada!,
      tipoManutencao: _tipoSelecionado!,
      dataSolicitacao: _dataSolicitacao ?? DateTime.now(),
      dataRealizacao: _dataRealizacao ?? _dataSolicitacao ?? DateTime.now(),
      descricao: _descricaoControlador.text,
      ativo: _ativo,
    );
  }

  void _limparCampos() {
    setState(() {
      _bikeSelecionada = null;
      _tipoSelecionado = null;
      _dataSolicitacao = null;
      _dataRealizacao = null;
      _ativo = true;
      _descricaoControlador.clear();
    });
    _chaveFormulario.currentState?.reset();
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

    if (_bikeSelecionada == null || _tipoSelecionado == null || _dataSolicitacao == null) {
      _mostrarMensagem('Preencha os campos obrigatorios.', erro: true);
      return;
    }

    final dto = _criarDTO();
    await _daoManutencao.salvar(dto);
    if (!mounted) return;

    _mostrarMensagem('Manutencao registrada com sucesso!');
    _limparCampos();
    Navigator.of(context).pop(dto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Manutencao'),
        actions: [
          IconButton(
            onPressed: _salvar,
            icon: const Icon(Icons.save),
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
              CampoOpcoes<DTOBike>(
                opcoes: _bikes,
                valorSelecionado: _bikeSelecionada,
                rotulo: 'Bike',
                textoPadrao: 'Selecione uma bike',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroBike,
                aoAlterar: (value) => setState(() => _bikeSelecionada = value),
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOTipoManutencao>(
                opcoes: _tipos,
                valorSelecionado: _tipoSelecionado,
                rotulo: 'Tipo de manutencao',
                textoPadrao: 'Selecione o tipo',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroTipoManutencao,
                aoAlterar: (value) => setState(() => _tipoSelecionado = value),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de solicitacao',
                valor: _dataSolicitacao,
                eObrigatorio: true,
                aoAlterar: (data) => setState(() => _dataSolicitacao = data),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de realizacao',
                valor: _dataRealizacao,
                eObrigatorio: false,
                aoAlterar: (data) => setState(() => _dataRealizacao = data),
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descricao',
                dica: 'Descreva a manutencao',
                maxLinhas: 3,
                eObrigatorio: true,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _ativo,
                onChanged: (value) => setState(() => _ativo = value),
                title: const Text('Ativa'),
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
}

