import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_turma.dart';

class DTOCheckin {
  final int? id;
  final DTOAluno aluno;
  final DTOTurma turma;
  final DateTime data;
  final int fila;
  final int coluna;
  final bool ativo;

  DTOCheckin({
    this.id,
    required this.aluno,
    required this.turma,
    required this.data,
    required this.fila,
    required this.coluna,
    this.ativo = true,
  });
}

