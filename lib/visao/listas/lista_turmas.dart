import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_turma.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaTurmas extends StatelessWidget {
  const ListaTurmas({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorTurma();
    return ListaPadrao<DTOTurma>(
      titulo: 'Turmas',
      icone: Icons.groups,
      mensagemVazia: 'Nenhuma turma cadastrada',
      rotaCadastro: Rotas.cadastroTurma,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (t) => t.ativo,
      detalhes: (t) {
        final descricao = t.descricao.isNotEmpty ? 'Descricao: ${t.descricao}\n' : '';
        final dias = t.diasSemana.isNotEmpty ? 'Dias: ${t.diasSemana.join(', ')}\n' : '';
        return '${descricao}Sala: ${t.sala.nome}\nHorario: ${t.horarioInicio} (${t.duracaoMinutos} min)\n$dias${t.ativo ? 'Ativa' : 'Inativa'}';
      },
    );
  }
}

