import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_sala.dart';

class DAOSala {
  static const String _tabela = 'sala';

  Future<int> salvar(DTOSala sala) async {
    final db = await ConexaoSQLite.database;
    final colunas = await _obterColunas(db);
    final dados = _dadosParaPersistencia(sala, colunas);

    if (sala.id != null) {
      return db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [sala.id],
      );
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOSala>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps.map(_mapParaSala).toList();
  }

  Future<DTOSala?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapParaSala(maps.first);
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return db.update(
      _tabela,
      {'ativa': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Set<String>> _obterColunas(dynamic db) async {
    final resultado = await db.rawQuery('PRAGMA table_info($_tabela)');
    return resultado
        .map((coluna) => (coluna['name'] as String?) ?? '')
        .where((nome) => nome.isNotEmpty)
        .toSet();
  }

  Map<String, Object?> _dadosParaPersistencia(DTOSala sala, Set<String> colunas) {
    final Map<String, Object?> dados = {
      'nome': sala.nome,
      'ativa': sala.ativa ? 1 : 0,
    };

    if (colunas.contains('numero_filas')) {
      dados['numero_filas'] = sala.numeroFilas;
    }
    if (colunas.contains('numero_colunas')) {
      dados['numero_colunas'] = sala.numeroColunas;
    }
    if (colunas.contains('posicao_professora')) {
      dados['posicao_professora'] = sala.posicaoProfessora;
    }

    // Compatibilidade com schema antigo.
    if (colunas.contains('numero_bikes')) {
      dados['numero_bikes'] = sala.numeroFilas * sala.numeroColunas;
    }
    if (colunas.contains('limite_bikes_por_fila')) {
      dados['limite_bikes_por_fila'] = sala.numeroColunas;
    }
    if (colunas.contains('grade_bikes')) {
      dados['grade_bikes'] = '';
    }

    return dados;
  }

  DTOSala _mapParaSala(Map<String, dynamic> map) {
    final numeroFilas = _toInt(map['numero_filas'], fallback: 0);
    final numeroColunas = _toInt(
      map['numero_colunas'],
      fallback: _toInt(map['limite_bikes_por_fila'], fallback: 0),
    );

    final posicaoProfessora = _toInt(
      map['posicao_professora'],
      fallback: numeroColunas > 0 ? numeroColunas ~/ 2 : 0,
    );

    return DTOSala(
      id: _toIntOrNull(map['id']),
      nome: (map['nome'] as String?) ?? '',
      numeroFilas: numeroFilas,
      numeroColunas: numeroColunas,
      posicaoProfessora: posicaoProfessora,
      ativa: _toInt(map['ativa'], fallback: 1) == 1,
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

