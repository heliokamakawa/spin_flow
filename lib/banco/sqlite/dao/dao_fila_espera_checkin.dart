import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_fila_espera_checkin.dart';

class DAOFilaEsperaCheckin {
  static const String _tabela = 'fila_espera_checkin';

  Future<int> entrarNaFila({
    required int alunoId,
    required int turmaId,
    required DateTime data,
  }) async {
    final db = await ConexaoSQLite.database;
    final existente = await db.query(
      _tabela,
      columns: ['id'],
      where: 'aluno_id = ? AND turma_id = ? AND ativo = 1 AND substr(data, 1, 10) = ?',
      whereArgs: [alunoId, turmaId, _chaveData(data)],
      limit: 1,
    );
    if (existente.isNotEmpty) {
      throw Exception('Aluno ja esta na fila de espera para esta turma/data.');
    }

    return db.insert(_tabela, {
      'aluno_id': alunoId,
      'turma_id': turmaId,
      'data': data.toIso8601String(),
      'criado_em': DateTime.now().toIso8601String(),
      'ativo': 1,
    });
  }

  Future<List<DTOFilaEsperaCheckin>> buscarAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'turma_id = ? AND ativo = 1 AND substr(data, 1, 10) = ?',
      whereArgs: [turmaId, _chaveData(data)],
      orderBy: 'criado_em ASC',
    );
    return maps.map(_mapParaDTO).toList();
  }

  Future<DTOFilaEsperaCheckin?> buscarPrimeiroAtivoPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'turma_id = ? AND ativo = 1 AND substr(data, 1, 10) = ?',
      whereArgs: [turmaId, _chaveData(data)],
      orderBy: 'criado_em ASC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapParaDTO(maps.first);
  }

  Future<int> sairDaFila(int id) async {
    final db = await ConexaoSQLite.database;
    return db.update(
      _tabela,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  DTOFilaEsperaCheckin _mapParaDTO(Map<String, dynamic> map) {
    return DTOFilaEsperaCheckin(
      id: map['id'] as int?,
      alunoId: (map['aluno_id'] as int?) ?? 0,
      turmaId: (map['turma_id'] as int?) ?? 0,
      data: DateTime.tryParse((map['data'] as String?) ?? '') ?? DateTime.now(),
      criadoEm: DateTime.tryParse((map['criado_em'] as String?) ?? '') ?? DateTime.now(),
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  String _chaveData(DateTime data) {
    final d = DateTime(data.year, data.month, data.day);
    return d.toIso8601String().substring(0, 10);
  }
}
