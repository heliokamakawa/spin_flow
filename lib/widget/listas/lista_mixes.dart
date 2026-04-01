import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_mixes.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaMixes extends StatelessWidget {
  const ListaMixes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListaPadrao<DTOMix>(
      titulo: 'Mixes',
      icone: Icons.queue_music,
      mensagemVazia: 'Nenhum mix cadastrado',
      rotaCadastro: Rotas.cadastroMix,
      carregar: () async => mockMixes,
      excluir: (_) async {},
      ativo: (m) => m.ativo,
      detalhes: (m) {
        final descricao = m.descricao?.isNotEmpty == true ? 'Descrição: ${m.descricao}\n' : '';
        final fim = m.dataFim != null ? 'Fim: ${m.dataFim!.toString().split(' ')[0]}\n' : '';
        return '${descricao}Músicas: ${m.musicas.length}\nInício: ${m.dataInicio.toString().split(' ')[0]}\n$fim${m.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}
