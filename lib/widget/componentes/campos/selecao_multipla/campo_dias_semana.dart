import 'package:flutter/material.dart';

class CampoDiasSemana extends StatefulWidget {
  final List<String> diasSelecionados;
  final String rotulo;
  final bool eObrigatorio;
  final String? Function(List<String>)? validador;
  final void Function(List<String>) aoAlterar;

  const CampoDiasSemana({
    super.key,
    this.diasSelecionados = const [],
    this.rotulo = 'Dias da Semana',
    this.eObrigatorio = true,
    this.validador,
    required this.aoAlterar,
  });

  @override
  State<CampoDiasSemana> createState() => _CampoDiasSemanaState();
}

class _CampoDiasSemanaState extends State<CampoDiasSemana> {
  static const List<String> _todosDias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  late List<String> _selecionados;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _selecionados = List.from(widget.diasSelecionados);
  }

  void _alternarDia(String dia) {
    setState(() {
      if (_selecionados.contains(dia)) {
        _selecionados.remove(dia);
      } else {
        _selecionados.add(dia);
      }
      _erro = null;
    });
    widget.aoAlterar(_selecionados);
  }

  @override
  Widget build(BuildContext context) {
    _erro = widget.validador?.call(_selecionados) ?? (widget.eObrigatorio && _selecionados.isEmpty ? 'Selecione pelo menos um dia da semana' : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.rotulo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.rotulo, style: Theme.of(context).textTheme.titleMedium),
          ),
        Wrap(
          spacing: 8,
          children: _todosDias.map((dia) {
            final estaSelecionado = _selecionados.contains(dia);
            return ChoiceChip(
              label: Text(dia),
              selected: estaSelecionado,
              onSelected: (_) => _alternarDia(dia),
            );
          }).toList(),
        ),
        if (_erro != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _erro!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}


