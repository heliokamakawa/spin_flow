import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_musica.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_multipla/campo_multi_selecao.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';

class FormMusica extends StatefulWidget {
  const FormMusica({super.key});

  @override
  State<FormMusica> createState() => _FormMusicaState();
}

class _FormMusicaState extends State<FormMusica> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOArtistaBanda _daoArtista = DAOArtistaBanda();
  final DAOCategoriaMusica _daoCategoria = DAOCategoriaMusica();
  final DAOMusica _daoMusica = DAOMusica();

  String? _nome;
  DTOArtistaBanda? _artistaSelecionado;
  final List<DTOCategoriaMusica> _categoriasSelecionadas = [];
  final List<Map<String, String?>> _links = [];
  String _descricao = '';

  List<DTOArtistaBanda> _artistas = [];
  List<DTOCategoriaMusica> _categorias = [];

  @override
  void initState() {
    super.initState();
    _carregarOpcoes();
  }

  Future<void> _carregarOpcoes() async {
    final artistas = await _daoArtista.buscarTodos();
    final categorias = await _daoCategoria.buscarTodos();
    if (!mounted) return;
    setState(() {
      _artistas = artistas;
      _categorias = categorias;
    });
  }

  void _adicionarLink() {
    setState(() {
      _links.add({
        'url': null,
        'descricao': null,
      });
    });
  }

  void _removerLink(int index) {
    setState(() {
      _links.removeAt(index);
    });
  }

  void _atualizarLink(int index, String campo, String? valor) {
    setState(() {
      _links[index][campo] = valor;
    });
  }

  void _limparCampos() {
    setState(() {
      _nome = null;
      _artistaSelecionado = null;
      _categoriasSelecionadas.clear();
      _links.clear();
      _descricao = '';
    });
    _chaveFormulario.currentState?.reset();
  }

  DTOMusica _criarDTO() {
    final links = _links
        .where((link) => link['url'] != null && link['url']!.isNotEmpty)
        .map((link) => DTOVideoAula(
              nome: link['descricao'] ?? '',
              linkVideo: link['url']!,
            ))
        .toList();
    return DTOMusica(
      nome: _nome ?? '',
      artista: _artistaSelecionado!,
      categorias: List.from(_categoriasSelecionadas),
      linksVideoAula: links,
      descricao: _descricao,
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

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      if (_artistaSelecionado == null) {
        _mostrarMensagem('Selecione o artista/banda', erro: true);
        return;
      }
      if (_categoriasSelecionadas.isEmpty) {
        _mostrarMensagem('Selecione pelo menos uma categoria', erro: true);
        return;
      }
      final dto = _criarDTO();
      await _daoMusica.salvar(dto);
      if (!mounted) return;
      _mostrarMensagem('Musica "${dto.nome}" salva com sucesso!');
      _limparCampos();
      Navigator.of(context).pop(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Musica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: _salvar,
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
                rotulo: 'Nome da Musica',
                dica: 'Nome da musica',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOArtistaBanda>(
                opcoes: _artistas,
                valorSelecionado: _artistaSelecionado,
                rotulo: 'Artista/Banda',
                textoPadrao: 'Selecione o artista/banda',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroArtistaBanda,
                aoAlterar: (artista) {
                  setState(() {
                    _artistaSelecionado = artista;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoMultiSelecao<DTOCategoriaMusica>(
                opcoes: _categorias,
                valoresSelecionados: _categoriasSelecionadas,
                rotaCadastro: Rotas.cadastroCategoriaMusica,
                rotulo: 'Categorias de Musica',
                textoPadrao: 'Selecione categorias',
                eObrigatorio: true,
                onChanged: (selecionados) {
                  setState(() {
                    _categoriasSelecionadas
                      ..clear()
                      ..addAll(selecionados);
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Links de Video Aula (opcional)',
              ),
              const SizedBox(height: 8),
              ..._links.asMap().entries.map((entry) {
                final index = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CampoUrl(
                          rotulo: 'Link do Video Aula ${index + 1}',
                          dica: 'https://...',
                          eObrigatorio: false,
                          aoAlterar: (value) => _atualizarLink(index, 'url', value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: CampoTexto(
                          rotulo: 'Descricao',
                          dica: 'Ex: Playlist oficial',
                          eObrigatorio: false,
                          aoAlterar: (value) => _atualizarLink(index, 'descricao', value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remover link',
                        onPressed: () => _removerLink(index),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _adicionarLink,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Link'),
              ),
              const SizedBox(height: 16),
              CampoTexto(
                rotulo: 'Descricao',
                dica: 'Descricao da musica (opcional)',
                eObrigatorio: false,
                maxLinhas: 3,
                aoAlterar: (value) => _descricao = value,
              ),
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

