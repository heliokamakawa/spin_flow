import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoTexto extends StatelessWidget {
  // 1. Atributos públicos
  final TextEditingController? controle;
  final String? valorInicial;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final int maxLinhas;
  final bool eObrigatorio;
  final String? Function(String?)? validador;
  final void Function(String)? aoAlterar;

  // 2. Construtor
  const CampoTexto({
    super.key,
    this.controle,
    this.valorInicial,
    required this.rotulo,
    required this.dica,
    this.mensagemErro = Erro.obrigatorio,
    this.maxLinhas = 1,
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
      maxLines: maxLinhas,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
      ),
      validator: (valor) => _validarCampo(valor),
      onChanged: aoAlterar,
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
    return null;
  }
}

