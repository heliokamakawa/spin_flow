import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoNumero extends StatelessWidget {
  // 1. Atributos públicos
  final TextEditingController? controle;
  final String? valorInicial;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final bool eObrigatorio;
  final bool aceitaNegativo;
  final int? limiteMaximo;
  final int limiteMinimo;
  final String? Function(String?)? validador;
  final void Function(String)? aoAlterar;

  // 2. Construtor
  const CampoNumero({
    super.key,
    this.controle,
    this.valorInicial,
    required this.rotulo,
    this.dica = '',
    this.mensagemErro = Erro.obrigatorio,
    this.eObrigatorio = true,
    this.aceitaNegativo = false,
    this.limiteMaximo,
    this.limiteMinimo = 0,
    this.validador,
    this.aoAlterar,
  });

  // 3. Métodos override
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _definirController(),
      initialValue: valorInicial,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        border: const OutlineInputBorder(),
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
    if (valor != null && valor.isNotEmpty) {
      final numero = int.tryParse(valor);
      if (numero == null) {
        return 'Informe um número válido';
      }
      if (!aceitaNegativo && numero < 0) {
        return 'Não pode ser número negativo';
      }
      if (numero < limiteMinimo) {
        return 'Valor deve ser â‰¥ $limiteMinimo';
      }
      if (limiteMaximo != null && numero > limiteMaximo!) {
        return 'Valor deve ser â‰¤ $limiteMaximo';
      }
    }
    return null;
  }
}


