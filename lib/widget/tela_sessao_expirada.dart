import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/configuracoes/sessao_usuario.dart';

/// Tela exibida quando a sessão do usuário expira por inatividade
/// (RF-AP-4.1.1.3 / Mockup B.1 Seq 3).
class TelaSessaoExpirada extends StatelessWidget {
  const TelaSessaoExpirada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_clock, size: 72, color: Colors.orange.shade400),
              const SizedBox(height: 20),
              const Text(
                'Sessao expirada',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Sua sessao expirou por inatividade. Por favor, faca login novamente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    SessaoUsuario.encerrar();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Rotas.login,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Ir para o login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
