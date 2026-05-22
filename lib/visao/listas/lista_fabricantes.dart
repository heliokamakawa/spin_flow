import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_fabricante.dart';
import 'package:spin_flow/modelo/dto/dto_fabricante.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaFabricantes extends StatelessWidget {
  const ListaFabricantes({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorFabricante();
    return ListaPadrao<DTOFabricante>(
      titulo: 'Fabricantes',
      icone: Icons.factory,
      mensagemVazia: 'Nenhum fabricante cadastrado',
      rotaCadastro: Rotas.cadastroFabricante,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (f) => f.ativo,
      detalhes: (f) {
        final descricao = f.descricao?.isNotEmpty == true ? '${f.descricao}\n' : '';
        return '$descricao${f.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

