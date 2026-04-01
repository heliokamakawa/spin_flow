import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_bikes.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/lista_padrao.dart';

class ListaBikes extends StatelessWidget {
  const ListaBikes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListaPadrao<DTOBike>(
      titulo: 'Bikes',
      icone: Icons.directions_bike,
      mensagemVazia: 'Nenhuma bike cadastrada',
      rotaCadastro: Rotas.cadastroBike,
      carregar: () async => mockBikes,
      excluir: (_) async {},
      ativo: (b) => b.ativa,
      detalhes: (b) {
        final numeroSerie = b.numeroSerie?.isNotEmpty == true ? 'Número de Série: ${b.numeroSerie}\n' : '';
        final dataCadastro = 'Cadastrada em: ${b.dataCadastro.toString().split(' ')[0]}\n';
        return 'Fabricante: ${b.fabricante.nome}\n$numeroSerie$dataCadastro${b.ativa ? 'Ativa' : 'Inativa'}';
      },
    );
  }
}
