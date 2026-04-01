import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_grupos_alunos.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaGruposAlunos extends StatelessWidget {
  const ListaGruposAlunos({super.key});

  @override
  Widget build(BuildContext context) {
    return ListaPadrao<DTOGrupoAlunos>(
      titulo: 'Grupos de Alunos',
      icone: Icons.group_work,
      mensagemVazia: 'Nenhum grupo cadastrado',
      rotaCadastro: Rotas.cadastroGrupoAlunos,
      carregar: () async => mockGruposAlunos,
      excluir: (_) async {},
      ativo: (g) => g.ativo,
      detalhes: (g) {
        final descricao = g.descricao?.isNotEmpty == true ? 'Descrição: ${g.descricao}\n' : '';
        return '${descricao}Alunos: ${g.alunos.length}\n${g.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}
