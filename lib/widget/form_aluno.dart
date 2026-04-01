import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_telefone.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class FormAluno extends StatefulWidget {
  const FormAluno({super.key});

  @override
  State<FormAluno> createState() => _FormAlunoState();
}

class _FormAlunoState extends State<FormAluno> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _daoAluno = DAOAluno();
  int? _id;
  bool _dadosCarregados = false;
  bool _erroCarregamento = false;

  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _emailControlador = TextEditingController();
  final TextEditingController _telefoneControlador = TextEditingController();
  final TextEditingController _urlFotoControlador = TextEditingController();
  final TextEditingController _instagramControlador = TextEditingController();
  final TextEditingController _facebookControlador = TextEditingController();
  final TextEditingController _tiktokControlador = TextEditingController();
  final TextEditingController _observacoesControlador = TextEditingController();

  DateTime? _dataNascimento;
  String? _genero;
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
    _emailControlador.dispose();
    _telefoneControlador.dispose();
    _urlFotoControlador.dispose();
    _instagramControlador.dispose();
    _facebookControlador.dispose();
    _tiktokControlador.dispose();
    _observacoesControlador.dispose();
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
        appBar: AppBar(title: const Text('Erro ao carregar aluno')),
        body: const Center(child: Text('Não foi possível carregar os dados do aluno.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Aluno' : 'Novo Aluno'),
        actions: [
          IconButton(
            onPressed: _salvar,
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _chaveFormulario,
          child: Column(
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome',
                dica: 'Nome completo',
                eObrigatorio: true,
              ),
              const SizedBox(height: 12),
              CampoEmail(
                controle: _emailControlador,
                rotulo: 'E-mail',
                eObrigatorio: true,
                aoAlterar: (value) => _emailControlador.text = value,
              ),
              const SizedBox(height: 12),
              CampoData(
                rotulo: 'Data de nascimento',
                valor: _dataNascimento,
                eObrigatorio: true,
                aoAlterar: (data) => setState(() => _dataNascimento = data),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                value: _genero,
                items: const [
                  DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'feminino', child: Text('Feminino')),
                  DropdownMenuItem(value: 'outros', child: Text('Outros')),
                ],
                onChanged: (val) => setState(() => _genero = val),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Selecione o gênero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CampoTelefone(
                controle: _telefoneControlador,
                rotulo: 'Telefone',
                eObrigatorio: true,
                aoAlterar: (value) => _telefoneControlador.text = value,
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'URL da foto',
                dica: 'Link da foto do perfil',
                eObrigatorio: false,
                valorInicial: _urlFotoControlador.text,
                aoAlterar: (value) => _urlFotoControlador.text = value,
              ),
              const SizedBox(height: 24),
              const Text(
                'Redes Sociais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'Instagram',
                dica: 'Link do perfil do Instagram',
                eObrigatorio: false,
                valorInicial: _instagramControlador.text,
                aoAlterar: (value) => _instagramControlador.text = value,
                prefixoIcone: const Icon(Icons.camera_alt_outlined, color: Colors.purple),
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'Facebook',
                dica: 'Link do perfil do Facebook',
                eObrigatorio: false,
                valorInicial: _facebookControlador.text,
                aoAlterar: (value) => _facebookControlador.text = value,
                prefixoIcone: const Icon(Icons.facebook, color: Colors.blue),
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'TikTok',
                dica: 'Link do perfil do TikTok',
                eObrigatorio: false,
                valorInicial: _tiktokControlador.text,
                aoAlterar: (value) => _tiktokControlador.text = value,
                prefixoIcone: const Icon(Icons.music_note, color: Colors.black),
              ),
              const SizedBox(height: 24),
              CampoTexto(
                controle: _observacoesControlador,
                rotulo: 'Observações',
                dica: 'Observações adicionais sobre o aluno',
                maxLinhas: 3,
                eObrigatorio: false,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativo'),
                value: _ativo,
                onChanged: (valor) {
                  setState(() => _ativo = valor);
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
    if (argumentos != null && argumentos is DTOAluno) {
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

  void _preencherCampos(DTOAluno aluno) {
    _id = aluno.id;
    _nomeControlador.text = aluno.nome;
    _emailControlador.text = aluno.email;
    _dataNascimento = aluno.dataNascimento;
    _genero = aluno.genero;
    _telefoneControlador.text = aluno.telefone;
    _urlFotoControlador.text = aluno.urlFoto;
    _instagramControlador.text = aluno.instagram;
    _facebookControlador.text = aluno.facebook;
    _tiktokControlador.text = aluno.tiktok;
    _observacoesControlador.text = aluno.observacoes;
    _ativo = aluno.ativo;
  }

  void _limparCampos() {
    _id = null;
    _nomeControlador.clear();
    _emailControlador.clear();
    _dataNascimento = null;
    _genero = null;
    _telefoneControlador.clear();
    _urlFotoControlador.clear();
    _instagramControlador.clear();
    _facebookControlador.clear();
    _tiktokControlador.clear();
    _observacoesControlador.clear();
    _ativo = true;
    setState(() {});
  }

  DTOAluno _criarDTO() {
    return DTOAluno(
      id: _id,
      nome: _nomeControlador.text,
      email: _emailControlador.text,
      dataNascimento: _dataNascimento ?? DateTime.now(),
      genero: _genero ?? '',
      telefone: _telefoneControlador.text,
      urlFoto: _urlFotoControlador.text,
      instagram: _instagramControlador.text,
      facebook: _facebookControlador.text,
      tiktok: _tiktokControlador.text,
      observacoes: _observacoesControlador.text,
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
      Navigator.of(context).pushReplacementNamed(Rotas.listaAlunos);
    }
  }

  Future<void> _salvar() async {
    if (_chaveFormulario.currentState!.validate()) {
      if (_nomeControlador.text.isEmpty || _emailControlador.text.isEmpty || (_genero ?? '').isEmpty || _telefoneControlador.text.isEmpty) {
        _mostrarMensagem('Preencha todos os campos obrigatórios.', erro: true);
        return;
      }
      try {
        final dto = _criarDTO();
        debugPrint(dto.toString());
        //await _daoAluno.salvar(dto); 
        await _daoAluno.salvar(dto);
        if (!mounted) return;
        _mostrarMensagem(_id != null ? 'Aluno atualizado com sucesso!' : 'Aluno criado com sucesso!');
        if (_id == null) {
          _limparCampos();
        }
        _redirecionarAposSalvar();
      } catch (e) {
        if (!mounted) return;
        _mostrarMensagem('Erro ao salvar aluno: $e', erro: true);
      }
    }
  }
}


