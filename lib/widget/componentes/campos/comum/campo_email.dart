import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoEmail extends StatelessWidget {
  // 1. Atributos públicos
  final TextEditingController? controle;
  final String? valorInicial;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final bool eObrigatorio;
  final String? Function(String?)? validador;
  final void Function(String)? aoAlterar;

  // 2. Construtor
  const CampoEmail({
    super.key,
    this.controle,
    this.valorInicial,
    this.rotulo = 'E-mail',
    this.dica = 'nome@provedora.com',
    this.mensagemErro = Erro.emailInvalido,
    this.eObrigatorio = true,
    this.validador,
    this.aoAlterar,
  });

  // 3. Métodos override
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _definirController(),
      initialValue: valorInicial,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (valor) => _validarCampo(valor),
      onChanged: aoAlterar,
      autofillHints: const [AutofillHints.email],
    );
  }

  // 5. Métodos privados importantes
  TextEditingController? _definirController() {
    // Se valorInicial for fornecido, não usar controller para evitar conflito
    return valorInicial != null ? null : controle;
  }

  String? _validarCampo(String? valor) {
    if (validador != null) {
      return validador!(valor);
    }
    if (eObrigatorio && (valor == null || valor.isEmpty)) {
      return mensagemErro;
    }
    if (valor != null && valor.isNotEmpty) {
      final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!regex.hasMatch(valor)) return Erro.emailInvalido;
    }
    return null;
  }
}

