import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_musica.dart';
import 'package:spin_flow/modelo/dto/dto_musica.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaMusicas extends StatelessWidget {
  const ListaMusicas({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorMusica();
    return ListaPadrao<DTOMusica>(
      titulo: 'Musicas',
      icone: Icons.music_note,
      mensagemVazia: 'Nenhuma musica cadastrada',
      rotaCadastro: Rotas.cadastroMusica,
      carregar: controlador.listar,
      excluir: controlador.excluir,
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

