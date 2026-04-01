import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fabricante.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaFabricantes extends StatelessWidget {
  const ListaFabricantes({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOFabricante();
    return ListaPadrao<DTOFabricante>(
      titulo: 'Fabricantes',
      icone: Icons.factory,
      mensagemVazia: 'Nenhum fabricante cadastrado',
      rotaCadastro: Rotas.cadastroFabricante,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (f) => f.ativo,
      detalhes: (f) {
        final descricao = f.descricao?.isNotEmpty == true ? '${f.descricao}\n' : '';
        return '$descricao${f.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

