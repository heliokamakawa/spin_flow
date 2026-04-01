import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class FormCategoriaMusica extends StatefulWidget {
  const FormCategoriaMusica({super.key});

  @override
  State<FormCategoriaMusica> createState() => _FormCategoriaMusicaState();
}

class _FormCategoriaMusicaState extends State<FormCategoriaMusica> {
  final _chaveFormulario = GlobalKey<FormState>();
  //final dao = DAOCategoriaMusica(); 
  final DAOCategoriaMusica _daoCategoria = DAOCategoriaMusica();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;

  final TextEditingController _nomeControlador = TextEditingController();
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
        appBar: AppBar(title: const Text('Erro ao carregar categoria')),
        body: const Center(child: Text('Não foi possível carregar os dados da categoria.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Categoria' : 'Nova Categoria'),
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
                rotulo: 'Nome',
                dica: 'cadência, ritmo, coreografia, força, relaxamento, aquecimento',
                eObrigatorio: true,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descrição',
                dica: 'Descrição da coreografia\nExemplo para "Coreografia" -> músicas que exigem coordenação motora e passos específicos',
                maxLinhas: 3,
                eObrigatorio: false,
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
    if (argumentos != null && argumentos is DTOCategoriaMusica) {
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

  void _preencherCampos(DTOCategoriaMusica categoria) {
    _id = categoria.id;
    _nomeControlador.text = categoria.nome;
    _descricaoControlador.text = categoria.descricao;
    _ativa = categoria.ativa;
  }

  void _limparCampos() {
    _id = null;
    _nomeControlador.clear();
    _descricaoControlador.clear();
    _ativa = true;
    setState(() {});
  }

  DTOCategoriaMusica _criarDTO() {
    return DTOCategoriaMusica(
      id: _id,
      nome: _nomeControlador.text,
      descricao: _descricaoControlador.text,
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
      Navigator.of(context).pushReplacementNamed(Rotas.listaCategoriasMusica);
    }
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      try {
        final dto = _criarDTO();
        debugPrint(dto.toString());
        //await _daoCategoria.salvar(dto); 
        await _daoCategoria.salvar(dto);
        if (!mounted) return;
        _mostrarMensagem(_id != null ? 'Categoria atualizada com sucesso!' : 'Categoria criada com sucesso!');
        if (_id == null) {
          _limparCampos();
        }
        _redirecionarAposSalvar();
      } catch (e) {
        if (!mounted) return;
        _mostrarMensagem('Erro ao salvar categoria: $e', erro: true);
      }
    }
  }
}

/*
Categorias para músicas (nomes sugestivos):
Cadência - músicas que definem ritmo e velocidade do treino
Coreografia - músicas que exigem coordenação motora e passos específicos
Força - músicas para exercícios que trabalham força e resistência
Perna - músicas focadas em exercícios para membros inferiores
Braço - músicas para exercícios focados em membros superiores
Ritmo - músicas com batidas envolventes para manter a energia
Relaxamento - músicas suaves para alongamento, descanso e desaceleração
Animação - músicas alegres e motivadoras para divertir e estimular
Intervalo - músicas para momentos de pausa ativa, recuperação rápida
Aquecimento - músicas para preparar o corpo no início da aula
Desaquecimento - músicas para finalização, relaxar e diminuir o esforço
Explosão - músicas com batidas fortes para picos de esforço e sprint
Core - músicas para exercícios focados na região do abdômen e tronco
*/


