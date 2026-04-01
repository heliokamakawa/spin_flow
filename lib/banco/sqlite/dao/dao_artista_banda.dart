import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';

class DAOArtistaBanda {
  static const String _tabela = 'artista_banda';

  Future<int> salvar(DTOArtistaBanda artista) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': artista.nome,
      'descricao': artista.descricao,
      'link': artista.link,
      'foto': artista.foto,
      'ativo': artista.ativo ? 1 : 0,
    };

    if (artista.id != null) {
      return db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [artista.id],
      );
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOArtistaBanda>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps.map(_mapParaDto).toList();
  }

  Future<DTOArtistaBanda?> buscarPorId(int id) async {
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
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  DTOArtistaBanda _mapParaDto(Map<String, dynamic> map) {
    return DTOArtistaBanda(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      descricao: (map['descricao'] as String?) ?? '',
      link: (map['link'] as String?) ?? '',
      foto: (map['foto'] as String?) ?? '',
      ativo: _toInt(map['ativo']) == 1,
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
