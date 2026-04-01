import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';

class DTOManutencao {
  final int? id;
  final DTOBike bike;
  final DTOTipoManutencao tipoManutencao;
  final DateTime dataSolicitacao;
  final DateTime dataRealizacao;
  final String descricao;
  final bool ativo;

  DTOManutencao({
    this.id,
    required this.bike,
    required this.tipoManutencao,
    required this.dataSolicitacao,
    required this.dataRealizacao,
    required this.descricao,
    this.ativo = true,
  });
}
