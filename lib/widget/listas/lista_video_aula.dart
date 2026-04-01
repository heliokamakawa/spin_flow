import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaVideoAula extends StatelessWidget {
  const ListaVideoAula({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOVideoAula();
    return ListaPadrao<DTOVideoAula>(
      titulo: 'Video-aulas',
      icone: Icons.ondemand_video,
      mensagemVazia: 'Nenhuma video-aula cadastrada',
      rotaCadastro: Rotas.cadastroVideoAula,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (v) => v.ativo,
      detalhes: (v) => 'Link: ${v.linkVideo}\n${v.ativo ? 'Ativa' : 'Inativa'}',
    );
  }
}

