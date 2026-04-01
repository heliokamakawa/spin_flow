import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class DTODisplayWidget extends StatelessWidget {
  final DTO dto;
  final String titulo;
  final List<String> camposExibir;

  const DTODisplayWidget({
    super.key,
    required this.dto,
    required this.titulo,
    required this.camposExibir,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (String campo in camposExibir)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${_capitalizeFirst(campo)}:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _getFieldValue(dto, campo) ?? 'Não informado',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String? _getFieldValue(DTO dto, String fieldName) {
    // Mapeamento de campos comuns
    switch (fieldName) {
      case 'id':
        return dto.id?.toString();
      case 'nome':
        return dto.nome;
      default:
        // Para campos específicos, usar reflection ou mapeamento manual
        return _getSpecificFieldValue(dto, fieldName);
    }
  }

  String? _getSpecificFieldValue(DTO dto, String fieldName) {
    // Mapeamento específico por tipo de DTO
    if (dto.toString().contains('DTOAluno')) {
      return _getAlunoFieldValue(dto, fieldName);
    } else if (dto.toString().contains('DTOMusica')) {
      return _getMusicaFieldValue(dto, fieldName);
    } else if (dto.toString().contains('DTOFabricante')) {
      return _getFabricanteFieldValue(dto, fieldName);
    }
    // Adicionar outros tipos conforme necessário
    return null;
  }

  String? _getAlunoFieldValue(DTO dto, String fieldName) {
    // Implementar para DTOAluno
    return null;
  }

  String? _getMusicaFieldValue(DTO dto, String fieldName) {
    // Implementar para DTOMusica
    return null;
  }

  String? _getFabricanteFieldValue(DTO dto, String fieldName) {
    // Implementar para DTOFabricante
    return null;
  }
}

// Widget específico para exibir listas de DTOs
class DTOListDisplayWidget extends StatelessWidget {
  final List<DTO> dtos;
  final String titulo;
  final String campoExibir;

  const DTOListDisplayWidget({
    super.key,
    required this.dtos,
    required this.titulo,
    this.campoExibir = 'nome',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: dtos.length,
          itemBuilder: (context, index) {
            final dto = dtos[index];
            return ListTile(
              title: Text(dto.nome),
              subtitle: Text('ID: ${dto.id}'),
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
} 

