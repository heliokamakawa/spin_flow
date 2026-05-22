import 'package:flutter/material.dart';
import 'package:spin_flow/controle/controlador_mix.dart';
import 'package:spin_flow/modelo/dto/dto_mix.dart';
import 'package:spin_flow/core/configuracoes/rotas.dart';
import 'package:spin_flow/visao/componentes/lista_padrao.dart';

class ListaMixes extends StatelessWidget {
  const ListaMixes({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = ControladorMix();
    return ListaPadrao<DTOMix>(
      titulo: 'Mixes',
      icone: Icons.queue_music,
      mensagemVazia: 'Nenhum mix cadastrado',
      rotaCadastro: Rotas.cadastroMix,
      carregar: controlador.listar,
      excluir: controlador.excluir,
      ativo: (m) => m.ativo,
      detalhes: (m) {
        final descricao = m.descricao.isNotEmpty ? 'Descricao: ${m.descricao}\n' : '';
        final fim = 'Fim: ${m.dataFim.toString().split(' ')[0]}\n';
        return '${descricao}Musicas: ${m.musicas.length}\nInicio: ${m.dataInicio.toString().split(' ')[0]}\n$fim${m.ativo ? 'Ativo' : 'Inativo'}';
      },
    );
  }
}

