import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class FormArtistaBanda extends StatefulWidget {
  const FormArtistaBanda({super.key});

  @override
  State<FormArtistaBanda> createState() => _FormArtistaBandaState();
}

class _FormArtistaBandaState extends State<FormArtistaBanda> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOArtistaBanda _daoArtista = DAOArtistaBanda();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;
  
  // Controllers para os campos
  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _descricaoControlador = TextEditingController();
  final TextEditingController _linkControlador = TextEditingController();
  final TextEditingController _fotoControlador = TextEditingController();
  
  // Campos do formulário
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
    _linkControlador.dispose();
    _fotoControlador.dispose();
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
        appBar: AppBar(title: const Text('Erro ao carregar artista/banda')),
        body: const Center(child: Text('Não foi possível carregar os dados do artista/banda.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Artista/Banda' : 'Novo Artista/Banda'),
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
                dica: 'Artista ou Banda',
                eObrigatorio: true,
              ),
              const SizedBox(height: 12),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descrição',
                dica: 'Informações adicionais sobre o artista ou banda',
                maxLinhas: 4,
                eObrigatorio: false,
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'Link relacionado',
                dica: 'Página oficial, bibliografia, playlist etc.',
                eObrigatorio: false,
                valorInicial: _linkControlador.text,
                aoAlterar: (value) => _linkControlador.text = value,
                prefixoIcone: const Icon(Icons.link),
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'URL da foto',
                dica: 'Imagem representativa da banda ou artista',
                eObrigatorio: false,
                valorInicial: _fotoControlador.text,
                aoAlterar: (value) => _fotoControlador.text = value,
                prefixoIcone: const Icon(Icons.image),
              ),
              SwitchListTile(
                value: _ativo,
                onChanged: (valor) => setState(() => _ativo = valor),
                title: const Text('Ativo'),
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
    if (argumentos != null && argumentos is DTOArtistaBanda) {
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

  void _preencherCampos(DTOArtistaBanda artista) {
    _id = artista.id;
    _nomeControlador.text = artista.nome;
    _descricaoControlador.text = artista.descricao;
    _linkControlador.text = artista.link;
    _fotoControlador.text = artista.foto;
    _ativo = artista.ativo;
  }

  void _limparCampos() {
    _id = null;
    _nomeControlador.clear();
    _descricaoControlador.clear();
    _linkControlador.clear();
    _fotoControlador.clear();
    _ativo = true;
    setState(() {});
  }

  DTOArtistaBanda _criarDTO() {
    return DTOArtistaBanda(
      id: _id,
      nome: _nomeControlador.text,
      descricao: _descricaoControlador.text,
      link: _linkControlador.text,
      foto: _fotoControlador.text,
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
      Navigator.of(context).pushReplacementNamed(Rotas.listaArtistasBandas);
    }
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      try {
        await _daoArtista.salvar(_criarDTO());
        if (!mounted) return;
        _mostrarMensagem(_id != null ? 'Artista/Banda atualizado(a) com sucesso!' : 'Artista/Banda criado(a) com sucesso!');
        if (_id == null) {
          _limparCampos();
        }
        _redirecionarAposSalvar();
      } catch (e) {
        if (!mounted) return;
        _mostrarMensagem('Erro ao salvar artista/banda: $e', erro: true);
      }
    }
  }
}


