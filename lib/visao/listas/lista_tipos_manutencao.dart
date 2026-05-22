import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_tipo_manutencao.dart';
import 'package:spin_flow/modelo/dto/dto_tipo_manutencao.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaTiposManutencao extends StatelessWidget {
  const ListaTiposManutencao({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorTipoManutencao();
    return ListaPadrao<DTOTipoManutencao>(
      titulo: 'Tipos de Manutenção',
      icone: Icons.build,
      mensagemVazia: 'Nenhum tipo de manutenção cadastrado',
      rotaCadastro: Rotas.cadastroTipoManutencao,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (t) => t.ativa,
      detalhes: (t) {
        final descricao = t.descricao?.isNotEmpty == true ? '${t.descricao}\n' : '';
        return '$descricao${t.ativa ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}


