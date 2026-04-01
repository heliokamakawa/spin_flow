import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_turmas.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaTurmas extends StatelessWidget {
  const ListaTurmas({super.key});

  @override
  Widget build(BuildContext context) {
    return ListaPadrao<DTOTurma>(
      titulo: 'Turmas',
      icone: Icons.groups,
      mensagemVazia: 'Nenhuma turma cadastrada',
      rotaCadastro: Rotas.cadastroTurma,
      carregar: () async => mockTurmas,
      excluir: (_) async {},
      ativo: (t) => t.ativo,
      detalhes: (t) {
        final descricao = t.descricao?.isNotEmpty == true ? 'Descrição: ${t.descricao}\n' : '';
        final dias = t.diasSemana.isNotEmpty ? 'Dias: ${t.diasSemana.join(', ')}\n' : '';
        return '${descricao}Sala: ${t.sala.nome}\nHorário: ${t.horarioInicio} (${t.duracaoMinutos} min)\n$dias${t.ativo ? 'Ativa' : 'Inativa'}';
      },
    );
  }
}
