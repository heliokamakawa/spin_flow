import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoTelefone extends StatelessWidget {
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
  const CampoTelefone({
    super.key,
    this.controle,
    this.valorInicial,
    this.rotulo = 'Telefone',
    this.dica = '(00) 00000-0000',
    this.mensagemErro = Erro.telefoneInvalido,
    this.eObrigatorio = true,
    this.validador,
    this.aoAlterar,
  });

  // 3. MÃ©todos override
  @override
  Widget build(BuildContext context) {
    final mascara = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return TextFormField(
      controller: _definirController(),
      initialValue: valorInicial,
      keyboardType: TextInputType.phone,
      inputFormatters: [mascara],
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: const Icon(Icons.phone),
      ),
      validator: (valor) => _validarCampo(valor),
      onChanged: aoAlterar,
      autofillHints: const [AutofillHints.telephoneNumber],
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
    if (eObrigatorio && (valor == null || valor.trim().isEmpty)) {
      return mensagemErro;
    }
    if (valor != null && valor.isNotEmpty) {
      // Remove caracteres não numÃ©ricos para validaÃ§Ã£o
      final numeros = valor.replaceAll(RegExp(r'[^\d]'), '');
      if (numeros.length < 10 || numeros.length > 11) return Erro.telefoneInvalido;
    }
    return null;
  }
}


