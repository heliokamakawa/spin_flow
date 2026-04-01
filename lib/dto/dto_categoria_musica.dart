import 'package:spin_flow/dto/dto.dart';

class DTOCategoriaMusica implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String descricao;
  final bool ativa;

  DTOCategoriaMusica({
    this.id,
    required this.nome,
    required this.descricao,
    this.ativa = true,
  });
}

