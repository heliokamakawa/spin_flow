import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/dto/dto_sala.dart';

class DTOTurma implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String descricao;
  final List<String> diasSemana;
  final String horarioInicio;
  final int duracaoMinutos;
  final DTOSala sala;
  final bool ativo;

  DTOTurma({
    this.id,
    required this.nome,
    required this.descricao,
    required this.diasSemana,
    required this.horarioInicio,
    required this.duracaoMinutos,
    required this.sala,
    this.ativo = true,
  });
}
