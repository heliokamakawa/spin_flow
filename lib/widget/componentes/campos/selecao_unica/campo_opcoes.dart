import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class CampoOpcoes<T extends DTO> extends StatefulWidget {
  final List<T> opcoes;
  final T? valorSelecionado;
  final String rotulo;
  final String textoPadrao;
  final String mensagemErro;
  final bool eObrigatorio;
  final String? Function(T?)? validador;
  final void Function(T?)? aoAlterar;
  final String rotaCadastro;

  const CampoOpcoes({
    super.key,
    required this.opcoes,
    this.valorSelecionado,
    required this.rotulo,
    this.textoPadrao = 'Escolha uma opção',
    this.mensagemErro = 'Selecione uma opção',
    this.eObrigatorio = true,
    this.validador,
    this.aoAlterar,
    required this.rotaCadastro,
  });

  @override
  State<CampoOpcoes<T>> createState() => _CampoOpcoesState<T>();
}

class _CampoOpcoesState<T extends DTO> extends State<CampoOpcoes<T>> {
  late List<T> _opcoesCampo;
  T? _valorSelecionado;

  @override
  void initState() {
    super.initState();
    _opcoesCampo = List.from(widget.opcoes);
    _valorSelecionado = widget.valorSelecionado;
  }

  @override
  void didUpdateWidget(covariant CampoOpcoes<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.opcoes, widget.opcoes)) {
      _opcoesCampo = List.from(widget.opcoes);
    }
    if (oldWidget.valorSelecionado != widget.valorSelecionado) {
      _valorSelecionado = widget.valorSelecionado;
    }
  }

  String? _validar(T? valor) {
    if (widget.validador != null) {
      return widget.validador!(valor);
    }
    if (widget.eObrigatorio && valor == null) {
      return widget.mensagemErro;
    }
    return null;
  }

  Future<void> _navegarParaCadastro() async {
    final novoItem = await Navigator.pushNamed(context, widget.rotaCadastro);
    setState(() {
      _opcoesCampo = List.from(widget.opcoes);
      if (novoItem != null) {
        _valorSelecionado = novoItem as T;
        widget.aoAlterar?.call(_valorSelecionado); // Notifica o pai
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(labelText: widget.rotulo),
            isExpanded: true,
            value: _valorSelecionado,
            validator: (value) => _validar(value),
            onChanged: (T? novoValor) {
              setState(() {
                _valorSelecionado = novoValor;
              });
              widget.aoAlterar?.call(novoValor);
            },
            items: [
              DropdownMenuItem<T>(
                value: null,
                child: Text(widget.textoPadrao),
              ),
              ..._opcoesCampo.map((op) => DropdownMenuItem<T>(
                    value: op,
                    child: Text(op.nome),
                  )),
            ],
          ),
        ),
        IconButton(
          onPressed: _navegarParaCadastro,
          icon: const Icon(Icons.add),
          tooltip: 'Adicionar novo',
        ),
      ],
    );
  }
}


