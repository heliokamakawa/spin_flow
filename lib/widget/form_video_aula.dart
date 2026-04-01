import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';

class FormVideoAula extends StatefulWidget {
  final DTOVideoAula? videoAula;
  const FormVideoAula({super.key, this.videoAula});

  @override
  State<FormVideoAula> createState() => _FormVideoAulaState();
}

class _FormVideoAulaState extends State<FormVideoAula> {
  final _formKey = GlobalKey<FormState>();
  final DAOVideoAula _daoVideoAula = DAOVideoAula();
  late TextEditingController _nomeController;
  late TextEditingController _linkController;
  bool _ativo = true;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.videoAula?.nome ?? '');
    _linkController = TextEditingController(text: widget.videoAula?.linkVideo ?? '');
    _ativo = widget.videoAula?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dto = DTOVideoAula(
        id: widget.videoAula?.id,
        nome: _nomeController.text.trim(),
        linkVideo: _linkController.text.trim(),
        ativo: _ativo,
      );
      await _daoVideoAula.salvar(dto);
      if (!mounted) return;
      Navigator.of(context).pop(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoAula == null ? 'Nova Video-aula' : 'Editar Video-aula'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Informe o nome da video-aula'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link do video',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    const urlPattern = r'^(http|https):\/\/';
                    if (!RegExp(urlPattern).hasMatch(value.trim())) {
                      return 'Informe uma URL valida (http ou https)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: _ativo,
                onChanged: (v) => setState(() => _ativo = v),
                title: const Text('Ativa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

