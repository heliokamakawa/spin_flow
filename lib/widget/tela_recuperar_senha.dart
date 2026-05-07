import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_usuario.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

/// Fluxo de recuperação de senha (RF-AP-4.1.1.2 / Mockup B.1 Seq 2).
/// Etapas: 1) Informar e-mail → 2) Verificar identidade → 3) Nova senha → 4) Confirmação.
/// Como o app usa SQLite local, a "recuperação" redefine a senha diretamente.
class TelaRecuperarSenha extends StatefulWidget {
  const TelaRecuperarSenha({super.key});

  @override
  State<TelaRecuperarSenha> createState() => _TelaRecuperarSenhaState();
}

class _TelaRecuperarSenhaState extends State<TelaRecuperarSenha> {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOUsuario _daoUsuario = DAOUsuario();
  final _formKey = GlobalKey<FormState>();

  int _etapa = 0; // 0=email, 1=verificação, 2=nova senha, 3=confirmação
  bool _processando = false;
  String? _erro;

  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  int? _alunoId;
  int? _usuarioId;

  @override
  void dispose() {
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _verificarEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _processando = true; _erro = null; });

    final email = _emailController.text.trim();
    final usuario = await _daoUsuario.buscarPorEmailAtivo(email);
    final aluno = await _daoAluno.buscarPorEmailAtivo(email);
    if (!mounted) return;

    if (usuario == null) {
      setState(() { _processando = false; _erro = 'E-mail nao encontrado.'; });
      return;
    }

    _usuarioId = usuario['id'] as int?;
    _alunoId = aluno?.id;
    setState(() { _processando = false; _etapa = 1; });
  }

  Future<void> _verificarIdentidade() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _processando = true; _erro = null; });

    if (_alunoId != null) {
      final aluno = await _daoAluno.buscarPorId(_alunoId!);
      if (!mounted) return;

      if (aluno == null) {
        setState(() { _processando = false; _erro = 'Aluno nao encontrado.'; });
        return;
      }

      final dataNasc = aluno.dataNascimento;
      final informada = _dataNascimentoController.text.trim();
      final esperada = '${dataNasc.day.toString().padLeft(2, '0')}/${dataNasc.month.toString().padLeft(2, '0')}/${dataNasc.year}';

      if (informada != esperada) {
        setState(() { _processando = false; _erro = 'Data de nascimento nao confere.'; });
        return;
      }
    }

    setState(() { _processando = false; _etapa = 2; });
  }

  Future<void> _redefinirSenha() async {
    if (!_formKey.currentState!.validate()) return;
    if (_novaSenhaController.text != _confirmarSenhaController.text) {
      setState(() => _erro = 'As senhas nao conferem.');
      return;
    }
    setState(() { _processando = true; _erro = null; });

    await _daoUsuario.atualizarSenha(_usuarioId!, _novaSenhaController.text);
    if (!mounted) return;

    setState(() { _processando = false; _etapa = 3; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: _etapa == 3 ? _etapaConfirmacao() : _etapaFormulario(),
        ),
      ),
    );
  }

  Widget _etapaFormulario() {
    return ListView(
      children: [
        // Stepper visual
        Row(
          children: List.generate(3, (i) {
            final ativa = i <= _etapa;
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: ativa ? Colors.purple : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        if (_etapa == 0) ...[
          const Icon(Icons.email_outlined, size: 48, color: Colors.purple),
          const SizedBox(height: 12),
          const Text('Informe seu e-mail', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Digite o e-mail cadastrado para iniciar a recuperacao.', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || v.trim().isEmpty ? 'Informe o e-mail.' : null,
          ),
        ],

        if (_etapa == 1) ...[
          const Icon(Icons.verified_user_outlined, size: 48, color: Colors.purple),
          const SizedBox(height: 12),
          const Text('Verificacao de identidade', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Confirme sua data de nascimento para prosseguir.', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          TextFormField(
            controller: _dataNascimentoController,
            decoration: const InputDecoration(labelText: 'Data de nascimento (dd/mm/aaaa)', border: OutlineInputBorder()),
            keyboardType: TextInputType.datetime,
            validator: (v) => v == null || v.trim().isEmpty ? 'Informe a data de nascimento.' : null,
          ),
        ],

        if (_etapa == 2) ...[
          const Icon(Icons.lock_reset, size: 48, color: Colors.purple),
          const SizedBox(height: 12),
          const Text('Nova senha', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Defina sua nova senha de acesso.', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          TextFormField(
            controller: _novaSenhaController,
            decoration: const InputDecoration(labelText: 'Nova senha', border: OutlineInputBorder()),
            obscureText: true,
            validator: (v) => v == null || v.length < 4 ? 'A senha deve ter pelo menos 4 caracteres.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmarSenhaController,
            decoration: const InputDecoration(labelText: 'Confirmar senha', border: OutlineInputBorder()),
            obscureText: true,
            validator: (v) => v == null || v.isEmpty ? 'Confirme a senha.' : null,
          ),
        ],

        if (_erro != null) ...[
          const SizedBox(height: 12),
          Text(_erro!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
        ],

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _processando ? null : _acaoPrincipal,
            child: _processando
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_textoBotao()),
          ),
        ),
      ],
    );
  }

  Widget _etapaConfirmacao() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 72, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Senha redefinida com sucesso!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Voce ja pode fazer login com a nova senha.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, Rotas.login),
            icon: const Icon(Icons.login),
            label: const Text('Ir para o login'),
          ),
        ],
      ),
    );
  }

  VoidCallback get _acaoPrincipal {
    switch (_etapa) {
      case 0: return _verificarEmail;
      case 1: return _verificarIdentidade;
      case 2: return _redefinirSenha;
      default: return () {};
    }
  }

  String _textoBotao() {
    switch (_etapa) {
      case 0: return 'Verificar e-mail';
      case 1: return 'Confirmar identidade';
      case 2: return 'Redefinir senha';
      default: return '';
    }
  }
}
