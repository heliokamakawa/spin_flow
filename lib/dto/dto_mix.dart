import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/dto/dto_musica.dart';

class DTOMix implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<DTOMusica> musicas;
  final String descricao;
  final bool ativo;

  DTOMix({
    this.id,
    required this.nome,
    required this.dataInicio,
    required this.dataFim,
    required this.musicas,
    required this.descricao,
    this.ativo = true,
  });
}

