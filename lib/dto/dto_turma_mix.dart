import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/dto/dto_turma.dart';

class DTOTurmaMix {
  final int? id;
  final DTOTurma turma;
  final DTOMix mix;
  final DateTime dataInicio;
  final DateTime dataFim;
  final bool ativo;

  DTOTurmaMix({
    this.id,
    required this.turma,
    required this.mix,
    required this.dataInicio,
    required this.dataFim,
    this.ativo = true,
  });
}
