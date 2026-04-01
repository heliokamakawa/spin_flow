import 'dart:convert';

import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';

import 'dao_aluno.dart';

class DAOGrupoAlunos {
  static const String _tabela = 'grupo_alunos';
  final DAOAluno _daoAluno = DAOAluno();

  Future<int> salvar(DTOGrupoAlunos item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': item.nome,
      'descricao': item.descricao,
      'aluno_ids': jsonEncode(item.alunos.map((a) => a.id).whereType<int>().toList()),
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOGrupoAlunos>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOGrupoAlunos> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<DTOGrupoAlunos?> buscarPorId(int id) async {
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

  Future<DTOGrupoAlunos> _mapParaDTO(Map<String, dynamic> map) async {
    final alunos = <DTOAluno>[];
    for (final id in _parseIds((map['aluno_ids'] as String?) ?? '[]')) {
      final aluno = await _daoAluno.buscarPorId(id);
      if (aluno != null) alunos.add(aluno);
    }

    return DTOGrupoAlunos(
      id: map['id'] as int?,
      nome: (map['nome'] as String?) ?? '',
      descricao: (map['descricao'] as String?) ?? '',
      alunos: alunos,
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

