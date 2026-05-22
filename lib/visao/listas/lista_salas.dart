import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_sala.dart';
import 'package:spin_flow/modelo/dto/dto_sala.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaSalas extends StatelessWidget {
  const ListaSalas({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorSala();
    return ListaPadrao<DTOSala>(
      titulo: 'Salas',
      icone: Icons.room,
      mensagemVazia: 'Nenhuma sala cadastrada',
      rotaCadastro: Rotas.cadastroSala,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (s) => s.ativa,
      detalhes: (s) =>
          'Filas: ${s.numeroFilas}\nColunas: ${s.numeroColunas}\nPosição da professora: ${s.posicaoProfessora + 1}\n${s.ativa ? 'Ativa' : 'Inativa'}',
    );
  }
}


