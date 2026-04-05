import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoHora extends StatefulWidget {
  // 1. Atributos públicos
  final dynamic valor;
  final String rotulo;
  final String mensagemErro;
  final bool eObrigatorio;
  final String? Function(TimeOfDay?)? validador;
  final void Function(TimeOfDay)? aoAlterar;
  final void Function(String)? aoAlterarString;

  // 2. Construtor
  const CampoHora({
    super.key,
    this.valor,
    required this.rotulo,
    this.mensagemErro = Erro.obrigatorio,
    this.eObrigatorio = true,
    this.validador,
    this.aoAlterar,
    this.aoAlterarString,
  });

  // 3. Métodos override
  @override
  State<CampoHora> createState() => _CampoHoraState();
}

class _CampoHoraState extends State<CampoHora> {
  TimeOfDay? _horaSelecionada;

  @override
  void initState() {
    super.initState();
    _horaSelecionada = _parseValor(widget.valor);
  }

  TimeOfDay? _parseValor(dynamic valor) {
    if (valor == null) return null;
    if (valor is TimeOfDay) return valor;
    if (valor is String) {
      if (valor.isEmpty) return null;
      final partes = valor.split(":");
      if (partes.length != 2) return null;
      final hora = int.tryParse(partes[0]);
      final minuto = int.tryParse(partes[1]);
      if (hora == null || minuto == null) return null;
      return TimeOfDay(hour: hora, minute: minuto);
    }
    return null;
  }

  String _formatarHoraParaBanco(TimeOfDay hora) =>
      '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}' ;

  void _onHoraAlterada(TimeOfDay novaHora) {
    setState(() => _horaSelecionada = novaHora);
    widget.aoAlterar?.call(novaHora);
    widget.aoAlterarString?.call(_formatarHoraParaBanco(novaHora));
  }

  String? _validar(TimeOfDay? value) {
    if (widget.validador != null) {
      return widget.validador!(value);
    }
    if (widget.eObrigatorio && value == null) {
      return widget.mensagemErro;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String textoHora = _horaSelecionada != null
        ? _horaSelecionada!.format(context)
        : 'Selecione o horário';

    return FormField<TimeOfDay>(
      initialValue: _horaSelecionada,
      validator: _validar,
      builder: (FormFieldState<TimeOfDay> state) {
        return InkWell(
          onTap: () async {
            TimeOfDay? novaHora = await showTimePicker(
              context: context,
              initialTime: _horaSelecionada ?? TimeOfDay.now(),
            );
            if (novaHora != null) {
              state.didChange(novaHora);
              _onHoraAlterada(novaHora);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.rotulo,
              errorText: state.errorText,
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              suffixIcon: const Icon(Icons.access_time),
            ),
            child: Text(
              textoHora,
              style: TextStyle(
                fontSize: 16,
                color: _horaSelecionada != null
                    ? Colors.black87
                    : Colors.grey[600],
              ),
            ),
          ),
        );
      },
    );
  }
}


