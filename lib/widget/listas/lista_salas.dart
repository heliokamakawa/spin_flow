import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_sala.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaSalas extends StatelessWidget {
  const ListaSalas({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOSala();
    return ListaPadrao<DTOSala>(
      titulo: 'Salas',
      icone: Icons.room,
      mensagemVazia: 'Nenhuma sala cadastrada',
      rotaCadastro: Rotas.cadastroSala,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (s) => s.ativa,
      detalhes: (s) =>
          'Bikes: ${s.numeroBikes}\nFilas: ${s.numeroFilas}\nLimite por fila: ${s.limiteBikesPorFila}\n${s.ativa ? 'Ativa' : 'Inativa'}',
    );
  }
}
