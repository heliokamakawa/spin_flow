import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/dto/dto_turma_mix.dart';

import 'dao_mix.dart';
import 'dao_turma.dart';

class DAOTurmaMix {
  static const String _tabela = 'turma_mix';
  final DAOTurma _daoTurma = DAOTurma();
  final DAOMix _daoMix = DAOMix();

  Future<int> salvar(DTOTurmaMix item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'turma_id': item.turma.id,
      'mix_id': item.mix.id,
      'data_inicio': item.dataInicio.toIso8601String(),
      'data_fim': item.dataFim.toIso8601String(),
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOTurmaMix>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOTurmaMix> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<List<DTOTurmaMix>> buscarPorTurma(int turmaId) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'turma_id = ?', whereArgs: [turmaId]);
    final List<DTOTurmaMix> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<DTOTurmaMix?> buscarAtivoPorTurma(int turmaId, {DateTime? data}) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'turma_id = ? AND ativo = 1',
      whereArgs: [turmaId],
      orderBy: 'data_inicio DESC',
    );
    if (maps.isEmpty) return null;

    final base = data ?? DateTime.now();
    final referencia = DateTime(base.year, base.month, base.day);

    // Regra prioritária: vínculo sem dataFim (aberto) representa o mix atual da turma.
    for (final map in maps) {
      final dataFimRaw = map['data_fim'];
      if (dataFimRaw == null) {
        return _mapParaDTO(map);
      }
      if (dataFimRaw is String && dataFimRaw.trim().isEmpty) {
        return _mapParaDTO(map);
      }
    }

    // Fallback por vigência de período (compatível com schema atual com data_fim preenchida).
    for (final map in maps) {
      final item = await _mapParaDTO(map);
      final inicio = DateTime(item.dataInicio.year, item.dataInicio.month, item.dataInicio.day);
      final fim = DateTime(item.dataFim.year, item.dataFim.month, item.dataFim.day);
      final vigente = !referencia.isBefore(inicio) && !referencia.isAfter(fim);
      if (vigente) return item;
    }

    return null;
  }

  Future<DTOTurmaMix?> buscarPorId(int id) async {
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

  Future<DTOTurmaMix> _mapParaDTO(Map<String, dynamic> map) async {
    final turmaId = _toInt(map['turma_id']);
    final mixId = _toInt(map['mix_id']);

    final turma = turmaId != null ? await _daoTurma.buscarPorId(turmaId) : null;
    final mix = mixId != null ? await _daoMix.buscarPorId(mixId) : null;

    return DTOTurmaMix(
      id: _toInt(map['id']),
      turma: turma ?? (throw StateError('Turma nao encontrada para TurmaMix.')),
      mix: mix ?? (throw StateError('Mix nao encontrado para TurmaMix.')),
      dataInicio: DateTime.tryParse((map['data_inicio'] as String?) ?? '') ?? DateTime.now(),
      dataFim: DateTime.tryParse((map['data_fim'] as String?) ?? '') ?? DateTime.now(),
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

