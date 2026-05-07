import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_usuario.dart';
import 'package:spin_flow/configuracoes/erro.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_senha.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final DAOUsuario _daoUsuario = DAOUsuario();
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final usuario = await _daoUsuario.autenticar(
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    setState(() => _carregando = false);

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(Erro.erroLogin),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final perfil = (usuario['perfil'] as String? ?? '').toLowerCase();
    SessaoUsuario.iniciar(
      id: (usuario['id'] as int?) ?? 0,
      nomeUsuario: (usuario['nome'] as String?) ?? '',
      emailUsuario: (usuario['email'] as String?) ?? '',
      perfilUsuario: perfil,
    );

    final rotaDestino = perfil == 'professora'
        ? Rotas.dashboardProfessora
        : Rotas.dashboardAluno;

    Navigator.pushReplacementNamed(context, rotaDestino);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tema.primaryColor,
              tema.primaryColor.withValues(alpha: 0.7),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / ícone
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.pedal_bike_rounded,
                        size: 45,
                        color: tema.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'SpinFlow',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bem-vindo de volta!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Card do formulário
                    Card(
                      elevation: 8,
                      shadowColor: Colors.black.withValues(alpha: 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 28.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CampoEmail(controle: _emailController),
                              const SizedBox(height: 16),
                              CampoSenha(
                                controle: _senhaController,
                                rotulo: 'Senha',
                                dica: 'Informe a senha',
                                mensagemErro: Erro.obrigatorio,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.pushNamed(context, Rotas.recuperarSenha),
                                  child: const Text('Esqueceu a senha?'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _carregando ? null : _fazerLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tema.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _carregando
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nao tem uma conta? Fale com o administrador.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

