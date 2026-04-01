import 'package:flutter/material.dart';

class BordaComTitulo extends StatelessWidget {
  final String titulo;
  final List<Widget> filhos;

  const BordaComTitulo({
    super.key,
    required this.titulo,
    required this.filhos,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filhos,
          ),
        ),
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

