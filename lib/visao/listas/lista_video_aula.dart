import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_video_aula.dart';
import 'package:spin_flow/modelo/dto/dto_video_aula.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaVideoAula extends StatelessWidget {
  const ListaVideoAula({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorVideoAula();
    return ListaPadrao<DTOVideoAula>(
      titulo: 'Video-aulas',
      icone: Icons.ondemand_video,
      mensagemVazia: 'Nenhuma video-aula cadastrada',
      rotaCadastro: Rotas.cadastroVideoAula,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (v) => v.ativo,
      detalhes: (v) => 'Link: ${v.linkVideo}\n${v.ativo ? 'Ativa' : 'Inativa'}',
    );
  }
}

