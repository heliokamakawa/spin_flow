import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaCategoriasMusica extends StatelessWidget {
  const ListaCategoriasMusica({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOCategoriaMusica();
    return ListaPadrao<DTOCategoriaMusica>(
      titulo: 'Categorias de Música',
      icone: Icons.category,
      mensagemVazia: 'Nenhuma categoria cadastrada',
      rotaCadastro: Rotas.cadastroCategoriaMusica,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (c) => c.ativa,
      detalhes: (c) => c.ativa ? 'Ativa' : 'Inativa',
    );
  }
}
