import 'dart:convert';

import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/dto/dto_musica.dart';

import 'dao_musica.dart';

class DAOMix {
  static const String _tabela = 'mix';
  final DAOMusica _daoMusica = DAOMusica();

  Future<int> salvar(DTOMix item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': item.nome,
      'data_inicio': item.dataInicio.toIso8601String(),
      'data_fim': item.dataFim.toIso8601String(),
      'musica_ids': jsonEncode(item.musicas.map((m) => m.id).whereType<int>().toList()),
      'descricao': item.descricao,
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOMix>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOMix> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<DTOMix?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapParaDTO(maps.first);
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return db.update(
      _tabela,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<DTOMix> _mapParaDTO(Map<String, dynamic> map) async {
    final musicas = <DTOMusica>[];
    for (final id in _parseIds((map['musica_ids'] as String?) ?? '[]')) {
      final musica = await _daoMusica.buscarPorId(id);
      if (musica != null) musicas.add(musica);
    }

    return DTOMix(
      id: map['id'] as int?,
      nome: (map['nome'] as String?) ?? '',
      dataInicio: DateTime.tryParse((map['data_inicio'] as String?) ?? '') ?? DateTime.now(),
      dataFim: DateTime.tryParse((map['data_fim'] as String?) ?? '') ?? DateTime.now(),
      musicas: musicas,
      descricao: (map['descricao'] as String?) ?? '',
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  List<int> _parseIds(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.whereType<num>().map((e) => e.toInt()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

