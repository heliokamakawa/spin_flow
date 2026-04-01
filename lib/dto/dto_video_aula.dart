import 'package:spin_flow/dto/dto.dart';

class DTOVideoAula implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String linkVideo;
  final bool ativo;

  DTOVideoAula({
    this.id,
    required this.nome,
    required this.linkVideo,
    this.ativo = true,
  });
}

