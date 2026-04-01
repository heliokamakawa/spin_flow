import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaArtistasBandas extends StatelessWidget {
  const ListaArtistasBandas({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOArtistaBanda();
    return ListaPadrao<DTOArtistaBanda>(
      titulo: 'Artistas e Bandas',
      icone: Icons.music_video,
      mensagemVazia: 'Nenhum artista ou banda cadastrado',
      rotaCadastro: Rotas.cadastroArtistaBanda,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (a) => a.ativo,
      detalhes: (a) {
        final descricao = a.descricao?.isNotEmpty == true ? '${a.descricao}\n' : '';
        final link = a.link?.isNotEmpty == true ? 'Link: ${a.link}\n' : '';
        return '$descricao$link${a.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}
