import 'package:spin_flow/dto/dto.dart';

class DTOFabricante implements DTO{
  @override
  final int? id;
  @override
  final String nome;
  final String? descricao;
  final String? nomeContatoPrincipal;
  final String? emailContato;
  final String? telefoneContato;
  final bool ativo;

  DTOFabricante({
    this.id,
    required this.nome,
    this.descricao,
    this.nomeContatoPrincipal,
    this.emailContato,
    this.telefoneContato,
    this.ativo = true,
  });
}
