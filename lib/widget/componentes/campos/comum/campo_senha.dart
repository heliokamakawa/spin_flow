import 'package:flutter/material.dart';

class CampoSenha extends StatelessWidget {
  // 1. Atributos pÃºblicos
  final TextEditingController? controle;
  final String? valorInicial;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final bool eObrigatorio;
  final String? Function(String?)? validador;
  final void Function(String)? aoAlterar;

  // 2. Construtor
  const CampoSenha({
    super.key,
    this.controle,
    this.valorInicial,
    required this.rotulo,
    required this.dica,
    required this.mensagemErro,
    this.eObrigatorio = true,
    this.validador,
    this.aoAlterar,
  });

  // 3. MÃ©todos override
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _definirController(),
      initialValue: valorInicial,
      obscureText: true,
      decoration: InputDecoration(
        labelText: rotulo,
        //border: const OutlineInputBorder(),
        hintText: dica,
      ),
      validator: (valor) => _validarCampo(valor),
      onChanged: aoAlterar,
    );
  }

  // 5. MÃ©todos privados importantes
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
    return null;
  }
}

