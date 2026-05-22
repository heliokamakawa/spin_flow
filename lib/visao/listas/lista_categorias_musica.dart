import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_categoria_musica.dart';
import 'package:spin_flow/modelo/dto/dto_categoria_musica.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaCategoriasMusica extends StatelessWidget {
  const ListaCategoriasMusica({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorCategoriaMusica();
    return ListaPadrao<DTOCategoriaMusica>(
      titulo: 'Categorias de Música',
      icone: Icons.category,
      mensagemVazia: 'Nenhuma categoria cadastrada',
      rotaCadastro: Rotas.cadastroCategoriaMusica,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (c) => c.ativa,
      detalhes: (c) => c.ativa ? 'Ativa' : 'Inativa',
    );
  }
}


