import 'package:spin_flow/dto/dto.dart';

class DTOTipoManutencao implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String? descricao;
  final bool ativa;

  DTOTipoManutencao({
    this.id,
    required this.nome,
    this.descricao,
    this.ativa = true,
  });
} 
