import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';

class DAOCategoriaMusica {
  static const String _tabela = 'categoria_musica';

  Future<int> salvar(DTOCategoriaMusica categoria) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': categoria.nome,
      'descricao': categoria.descricao,
      'ativa': categoria.ativa ? 1 : 0,
    };

    if (categoria.id != null) {
      return db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [categoria.id],
      );
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOCategoriaMusica>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps.map(_mapParaDto).toList();
  }

  Future<DTOCategoriaMusica?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _mapParaDto(maps.first);
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

  DTOCategoriaMusica _mapParaDto(Map<String, dynamic> map) {
    return DTOCategoriaMusica(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      descricao: (map['descricao'] as String?) ?? '',
      ativa: _toInt(map['ativa']) == 1,
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
