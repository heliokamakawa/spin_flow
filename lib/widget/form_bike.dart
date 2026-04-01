import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fabricante.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';

class FormBike extends StatefulWidget {
  const FormBike({super.key});

  @override
  State<FormBike> createState() => _FormBikeState();
}

class _FormBikeState extends State<FormBike> {
  final _formKey = GlobalKey<FormState>();
  final DAOBike _daoBike = DAOBike();
  final DAOFabricante _daoFabricante = DAOFabricante();

  String? _nome;
  String _numeroSerie = '';
  DTOFabricante? _fabricanteSelecionado;
  DateTime? _dataCadastro;
  bool _ativa = true;

  List<DTOFabricante> _fabricantes = [];

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _numeroSerieControlador = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarFabricantes();
  }

  Future<void> _carregarFabricantes() async {
    final fabricantes = await _daoFabricante.buscarTodos();
    if (!mounted) return;
    setState(() {
      _fabricantes = fabricantes;
    });
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _numeroSerie = '';
      _fabricanteSelecionado = null;
      _dataCadastro = null;
      _ativa = true;
      _nomeControlador.clear();
      _numeroSerieControlador.clear();
    });
    _formKey.currentState?.reset();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fabricanteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um fabricante')),
      );
      return;
    }

    if (_dataCadastro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a data de cadastro')),
      );
      return;
    }

    final dto = DTOBike(
      nome: _nome ?? '',
      numeroSerie: _numeroSerie,
      fabricante: _fabricanteSelecionado!,
      dataCadastro: _dataCadastro!,
      ativa: _ativa,
    );

    await _daoBike.salvar(dto);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bike salva com sucesso! ${dto.nome}')),
    );

    _limparFormulario();
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _numeroSerieControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Bike')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome da Bike',
                dica: 'Nome identificador da bike',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _numeroSerieControlador,
                rotulo: 'Numero de Serie',
                dica: 'Numero de serie da bike',
                eObrigatorio: false,
                aoAlterar: (value) => _numeroSerie = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOFabricante>(
                opcoes: _fabricantes,
                valorSelecionado: _fabricanteSelecionado,
                rotulo: 'Fabricante',
                textoPadrao: 'Selecione um fabricante',
                rotaCadastro: Rotas.cadastroFabricante,
                aoAlterar: (fabricante) => setState(() => _fabricanteSelecionado = fabricante),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de Cadastro',
                valor: _dataCadastro,
                eObrigatorio: true,
                aoAlterar: (data) => setState(() => _dataCadastro = data),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativa'),
                value: _ativa,
                onChanged: (valor) => setState(() => _ativa = valor),
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

