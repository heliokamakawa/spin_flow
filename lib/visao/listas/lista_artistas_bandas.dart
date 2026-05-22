import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_artista_banda.dart';
import 'package:spin_flow/modelo/dto/dto_artista_banda.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaArtistasBandas extends StatelessWidget {
  const ListaArtistasBandas({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorArtistaBanda();
    return ListaPadrao<DTOArtistaBanda>(
      titulo: 'Artistas e Bandas',
      icone: Icons.music_video,
      mensagemVazia: 'Nenhum artista ou banda cadastrado',
      rotaCadastro: Rotas.cadastroArtistaBanda,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (a) => a.ativo,
      detalhes: (a) {
        final descricao = a.descricao.isNotEmpty == true ? '${a.descricao}\n' : '';
        final link = a.link.isNotEmpty == true ? 'Link: ${a.link}\n' : '';
        return '$descricao$link${a.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

