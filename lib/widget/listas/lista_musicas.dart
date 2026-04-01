import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_musicas.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaMusicas extends StatelessWidget {
  const ListaMusicas({super.key});

  @override
  Widget build(BuildContext context) {
    return ListaPadrao<DTOMusica>(
      titulo: 'Músicas',
      icone: Icons.music_note,
      mensagemVazia: 'Nenhuma música cadastrada',
      rotaCadastro: Rotas.cadastroMusica,
      carregar: () async => mockMusicas,
      excluir: (_) async {},
      ativo: (m) => m.ativo,
      detalhes: (m) {
        final categorias = m.categorias.map((c) => c.nome).join(', ');
        final descricao = m.descricao?.isNotEmpty == true ? 'Descrição: ${m.descricao}\n' : '';
        final videos = m.linksVideoAula.isNotEmpty ? 'Vídeos: ${m.linksVideoAula.length}\n' : '';
        return 'Artista: ${m.artista.nome}\nCategorias: $categorias\n$descricao$videos${m.ativo ? 'Ativa' : 'Inativa'}';
      },
    );
  }
}
