import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_musica.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaMusicas extends StatelessWidget {
  const ListaMusicas({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOMusica();
    return ListaPadrao<DTOMusica>(
      titulo: 'Musicas',
      icone: Icons.music_note,
      mensagemVazia: 'Nenhuma musica cadastrada',
      rotaCadastro: Rotas.cadastroMusica,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (m) => m.ativo,
      detalhes: (m) {
        final categorias = m.categorias.map((c) => c.nome).join(', ');
        final descricao = m.descricao.isNotEmpty ? 'Descricao: ${m.descricao}\n' : '';
        final videos = m.linksVideoAula.isNotEmpty ? 'Videos: ${m.linksVideoAula.length}\n' : '';
        return 'Artista: ${m.artista.nome}\nCategorias: $categorias\n$descricao$videos${m.ativo ? 'Ativa' : 'Inativa'}';
      },
    );
  }
}

