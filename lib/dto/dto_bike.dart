import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';

class DTOBike implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String numeroSerie;
  final DTOFabricante fabricante;
  final DateTime dataCadastro;
  final bool ativa;

  DTOBike({
    this.id,
    required this.nome,
    required this.numeroSerie,
    required this.fabricante,
    required this.dataCadastro,
    this.ativa = true,
  });
}

