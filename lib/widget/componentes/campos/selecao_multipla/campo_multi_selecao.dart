import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class CampoMultiSelecao<T extends DTO> extends StatelessWidget {
  final List<T> opcoes;
  final List<T> valoresSelecionados;
  final String rotulo;
  final bool eObrigatorio;
  final String textoPadrao;
  final String rotaCadastro;
  final String? Function(List<T>)? validador;
  final void Function(List<T>)? onChanged;

  const CampoMultiSelecao({
    super.key,
    required this.opcoes,
    required this.valoresSelecionados,
    required this.rotulo,
    this.eObrigatorio = true,
    this.textoPadrao = 'Selecione opções',
    required this.rotaCadastro,
    this.validador,
    this.onChanged,
  });

  String? _validarCampo(List<T> selecionados) {
    if (validador != null) {
      return validador!(selecionados);
    }
    if (eObrigatorio && selecionados.isEmpty) {
      return 'Selecione pelo menos uma opção';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final erro = _validarCampo(valoresSelecionados);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(rotulo, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final novoItem = await Navigator.pushNamed(context, rotaCadastro);
                if (novoItem != null && novoItem is T && onChanged != null) {
                  final novaLista = List<T>.from(valoresSelecionados);
                  if (!novaLista.contains(novoItem)) {
                    novaLista.add(novoItem);
                    onChanged!(novaLista);
                  }
                }
              },
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar novo',
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: erro == null ? Colors.grey : Colors.red,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ExpansionTile(
            title: Text(
              valoresSelecionados.isEmpty
                  ? textoPadrao
                  : valoresSelecionados.map((e) => e.nome).join(', '),
            ),
            children: opcoes.map((item) {
              final estaSelecionado = valoresSelecionados.contains(item);
              return CheckboxListTile(
                title: Text(item.nome),
                value: estaSelecionado,
                onChanged: (bool? novoValor) {
                  if (onChanged == null) return;
                  final novaLista = List<T>.from(valoresSelecionados);
                  if (novoValor == true) {
                    if (!novaLista.contains(item)) {
                      novaLista.add(item);
                    }
                  } else {
                    novaLista.remove(item);
                  }
                  onChanged!(novaLista);
                },
              );
            }).toList(),
          ),
        ),
        if (erro != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12),
            child: Text(
              erro,
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
      ],
    );
  }
}


