import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/dto/dto_aluno.dart';

class DTOGrupoAlunos implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String descricao;
  final List<DTOAluno> alunos;
  final bool ativo;

  DTOGrupoAlunos({
    this.id,
    required this.nome,
    required this.descricao,
    required this.alunos,
    this.ativo = true,
  });
}
