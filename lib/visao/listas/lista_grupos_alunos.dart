import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_grupo_alunos.dart';
import 'package:spin_flow/modelo/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaGruposAlunos extends StatelessWidget {
  const ListaGruposAlunos({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorGrupoAlunos();
    return ListaPadrao<DTOGrupoAlunos>(
      titulo: 'Grupos de Alunos',
      icone: Icons.group_work,
      mensagemVazia: 'Nenhum grupo cadastrado',
      rotaCadastro: Rotas.cadastroGrupoAlunos,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (g) => g.ativo,
      detalhes: (g) {
        final descricao = g.descricao.isNotEmpty ? 'Descricao: ${g.descricao}\n' : '';
        return '${descricao}Alunos: ${g.alunos.length}\n${g.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

