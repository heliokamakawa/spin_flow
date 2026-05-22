import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaAlunos extends StatelessWidget {
  const ListaAlunos({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorAluno();
    return ListaPadrao<DTOAluno>(
      titulo: 'Alunos',
      icone: Icons.person,
      mensagemVazia: 'Nenhum aluno cadastrado',
      rotaCadastro: Rotas.cadastroAluno,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (a) => a.ativo,
      detalhes: (a) =>
          'Email: ${a.email}\nTelefone: ${a.telefone}\nNascimento: ${a.dataNascimento.toString().split(' ')[0]}',
    );
  }
}

