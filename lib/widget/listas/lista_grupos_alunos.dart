import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_grupo_alunos.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaGruposAlunos extends StatelessWidget {
  const ListaGruposAlunos({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = DAOGrupoAlunos();
    return ListaPadrao<DTOGrupoAlunos>(
      titulo: 'Grupos de Alunos',
      icone: Icons.group_work,
      mensagemVazia: 'Nenhum grupo cadastrado',
      rotaCadastro: Rotas.cadastroGrupoAlunos,
      carregar: dao.buscarTodos,
      excluir: dao.excluir,
      ativo: (g) => g.ativo,
      detalhes: (g) {
        final descricao = g.descricao.isNotEmpty ? 'Descricao: ${g.descricao}\n' : '';
        return '${descricao}Alunos: ${g.alunos.length}\n${g.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

