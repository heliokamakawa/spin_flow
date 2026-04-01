import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_busca_opcoes.dart';

/// Widget reutilizÃ¡vel para seleção múltipla com busca.
/// T recebe um tipo que herda de DTO e sobrescreve toString() ou implementa nome.
class CampoBuscaMultipla<T extends DTO> extends StatelessWidget {
  final List<T> opcoes;
  final List<T> valoresSelecionados;
  final String rotulo;
  final String textoPadrao;
  final String? Function(List<T>)? validador;
  final void Function(List<T>)? onChanged;
  final String rotaCadastro;

  const CampoBuscaMultipla({
    super.key,
    required this.opcoes,
    required this.valoresSelecionados,
    required this.rotulo,
    required this.textoPadrao,
    this.validador,
    this.onChanged,
    required this.rotaCadastro,
  });

  String? _validarCampo(List<T> selecionados) {
    if (validador != null) {
      return validador!(selecionados);
    }
    if (selecionados.isEmpty) {
      return 'Selecione pelo menos um item';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final erro = _validarCampo(valoresSelecionados);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampoBuscaOpcoes<T>(
          opcoes: opcoes,
          rotulo: rotulo,
          textoPadrao: textoPadrao,
          eObrigatorio: false,
          rotaCadastro: rotaCadastro,
          aoAlterar: (item) {
            if (item != null && onChanged != null) {
              final novaLista = List<T>.from(valoresSelecionados);
              if (!novaLista.contains(item)) {
                novaLista.add(item);
                onChanged!(List<T>.from(novaLista));
              }
            }
          },
        ),
        const SizedBox(height: 8),
        Text(
          rotulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        ...valoresSelecionados.map(
          (item) => ListTile(
            title: Text(item.nome),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (onChanged == null) return;
                final novaLista = List<T>.from(valoresSelecionados);
                novaLista.remove(item);
                onChanged!(List<T>.from(novaLista));
              },
            ),
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


