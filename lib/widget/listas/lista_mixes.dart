import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_mix.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaMixes extends StatelessWidget {
  const ListaMixes({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOMix();
    return ListaPadrao<DTOMix>(
      titulo: 'Mixes',
      icone: Icons.queue_music,
      mensagemVazia: 'Nenhum mix cadastrado',
      rotaCadastro: Rotas.cadastroMix,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (m) => m.ativo,
      detalhes: (m) {
        final descricao = m.descricao.isNotEmpty ? 'Descricao: ${m.descricao}\n' : '';
        final fim = 'Fim: ${m.dataFim.toString().split(' ')[0]}\n';
        return '${descricao}Musicas: ${m.musicas.length}\nInicio: ${m.dataInicio.toString().split(' ')[0]}\n$fim${m.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

