import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';

class DAOVideoAula {
  static const String _tabela = 'video_aula';

  Future<int> salvar(DTOVideoAula item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': item.nome,
      'link_video': item.linkVideo,
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOVideoAula>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps
        .map(
          (map) => DTOVideoAula(
            id: map['id'] as int?,
            nome: (map['nome'] as String?) ?? '',
            linkVideo: (map['link_video'] as String?) ?? '',
            ativo: ((map['ativo'] as int?) ?? 1) == 1,
          ),
        )
        .toList();
  }

  Future<DTOVideoAula?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final map = maps.first;
    return DTOVideoAula(
      id: map['id'] as int?,
      nome: (map['nome'] as String?) ?? '',
      linkVideo: (map['link_video'] as String?) ?? '',
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
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
}

