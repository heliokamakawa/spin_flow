import 'package:spin_flow/dto/dto.dart';

class DTOSala implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final int numeroFilas;
  final int numeroColunas;
  final int posicaoProfessora;
  final bool ativa;

  DTOSala({
    this.id,
    required this.nome,
    required this.numeroFilas,
    required this.numeroColunas,
    required this.posicaoProfessora,
    this.ativa = true,
  });
}
