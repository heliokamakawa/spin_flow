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

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final usuario = await _daoUsuario.autenticar(
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Erro.erroLogin)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login SpimFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CampoEmail(controle: _emailController),
              CampoSenha(
                controle: _senhaController,
                rotulo: 'Senha',
                dica: 'Informe a senha',
                mensagemErro: Erro.obrigatorio,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _fazerLogin,
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

