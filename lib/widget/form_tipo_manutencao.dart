import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_tipo_manutencao.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class FormTipoManutencaoTela extends StatefulWidget {
  const FormTipoManutencaoTela({super.key});

  @override
  State<FormTipoManutencaoTela> createState() => _FormTipoManutencaoTelaState();
}

class _FormTipoManutencaoTelaState extends State<FormTipoManutencaoTela> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOTipoManutencao _daoTipo = DAOTipoManutencao();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;

  final TextEditingController _descricaoControlador = TextEditingController();
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
        appBar: AppBar(title: const Text('Erro ao carregar tipo de manutenção')),
        body: const Center(child: Text('Não foi possível carregar os dados do tipo de manutenção.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Tipo de Manutenção' : 'Novo Tipo de Manutenção'),
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
          child: Column(
            children: [
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descrição',
                dica: 'pedal esquerdo, regulagem quebrada, pé-de-vela',
                eObrigatorio: true,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void _carregarDadosEdicao() {
    final argumentos = ModalRoute.of(context)?.settings.arguments;
    if (argumentos != null && argumentos is DTOTipoManutencao) {
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

  void _preencherCampos(DTOTipoManutencao tipo) {
    _id = tipo.id;
    _descricaoControlador.text = tipo.nome;
    _ativa = tipo.ativa;
  }

  void _limparCampos() {
    _id = null;
    _descricaoControlador.clear();
    _ativa = true;
    setState(() {});
  }

  DTOTipoManutencao _criarDTO() {
    return DTOTipoManutencao(
      id: _id,
      nome: _descricaoControlador.text,
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
    if (_id != null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(Rotas.listaTiposManutencao);
    }
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      try {
        final dto = _criarDTO();
        debugPrint(dto.toString());
        await _daoTipo.salvar(dto);
        if (!mounted) return;
        _mostrarMensagem(_id != null ? 'Tipo de manutenção atualizado com sucesso!' : 'Tipo de manutenção criado com sucesso!');
        if (_id == null) {
          _limparCampos();
        }
        _redirecionarAposSalvar();
      } catch (e) {
        if (!mounted) return;
        _mostrarMensagem('Erro ao salvar tipo de manutenção: $e', erro: true);
      }
    }
  }
} 

