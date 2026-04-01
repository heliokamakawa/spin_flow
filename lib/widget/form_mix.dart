import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_mix.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_busca_opcoes.dart';

class FormMix extends StatefulWidget {
  const FormMix({super.key});

  @override
  State<FormMix> createState() => _FormMixState();
}

class _FormMixState extends State<FormMix> {
  final _chaveFormulario = GlobalKey<FormState>();
  final DAOMix _daoMix = DAOMix();
  final DAOMusica _daoMusica = DAOMusica();

  String? _nomeMix;
  String _descricao = '';
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _ativo = true;
  final List<DTOMusica> _musicasSelecionadas = [];
  List<DTOMusica> _musicasDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _carregarMusicas();
  }

  Future<void> _carregarMusicas() async {
    final musicas = await _daoMusica.buscarTodos();
    if (!mounted) return;
    setState(() {
      _musicasDisponiveis = musicas;
    });
  }

  void _adicionarMusica(DTOMusica? musica) {
    if (musica != null && !_musicasSelecionadas.any((m) => m.id == musica.id)) {
      setState(() => _musicasSelecionadas.add(musica));
    }
  }

  void _removerMusica(DTOMusica musica) {
    setState(() => _musicasSelecionadas.removeWhere((m) => m.id == musica.id));
  }

  void _limparCampos() {
    setState(() {
      _nomeMix = null;
      _descricao = '';
      _dataInicio = null;
      _dataFim = null;
      _ativo = true;
      _musicasSelecionadas.clear();
    });
    _chaveFormulario.currentState?.reset();
  }

  DTOMix _criarDTO() {
    return DTOMix(
      nome: _nomeMix ?? '',
      descricao: _descricao,
      dataInicio: _dataInicio!,
      dataFim: _dataFim ?? _dataInicio!,
      musicas: _musicasSelecionadas,
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

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate() && _musicasSelecionadas.isNotEmpty) {
      final dto = _criarDTO();
      await _daoMix.salvar(dto);
      if (!mounted) return;
      _mostrarMensagem('Mix salvo com sucesso! ${dto.nome}');
      _limparCampos();
    } else {
      _mostrarMensagem('Preencha todos os campos obrigatorios.', erro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Mix')),
      body: Form(
        key: _chaveFormulario,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CampoTexto(
              rotulo: 'Nome do Mix',
              dica: 'Ex: Mix Power Marco 2025',
              eObrigatorio: true,
              aoAlterar: (value) => _nomeMix = value,
            ),
            const SizedBox(height: 16),
            CampoData(
              rotulo: 'Data de inicio de uso',
              eObrigatorio: true,
              valor: _dataInicio,
              aoAlterar: (data) => setState(() => _dataInicio = data),
            ),
            const SizedBox(height: 16),
            CampoData(
              rotulo: 'Data de encerramento (opcional)',
              eObrigatorio: false,
              valor: _dataFim,
              aoAlterar: (data) => setState(() => _dataFim = data),
            ),
            const SizedBox(height: 16),
            CampoBuscaOpcoes<DTOMusica>(
              opcoes: _musicasDisponiveis,
              rotulo: 'Musica',
              eObrigatorio: false,
              textoPadrao: 'Selecione as musicas do mix',
              rotaCadastro: Rotas.cadastroMusica,
              aoAlterar: _adicionarMusica,
            ),
            const SizedBox(height: 8),
            const Text('Musicas no mix:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._musicasSelecionadas.map(
              (musica) => ListTile(
                title: Text('${musica.nome} - ${musica.artista.nome}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removerMusica(musica),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CampoTexto(
              rotulo: 'Descricao / Observacoes',
              dica: 'Ex: Mix voltado para treinos intensos...',
              maxLinhas: 4,
              eObrigatorio: false,
              aoAlterar: (value) => _descricao = value,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _ativo,
              onChanged: (valor) => setState(() => _ativo = valor),
              title: const Text('Ativo'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar Mix'),
            ),
          ],
        ),
      ),
    );
  }
}

