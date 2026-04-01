import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';

class DAOTipoManutencao {
  static const String _tabela = 'tipo_manutencao';

  Future<int> salvar(DTOTipoManutencao tipo) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': tipo.nome,
      'descricao': tipo.descricao,
      'ativa': tipo.ativa ? 1 : 0,
    };

    if (tipo.id != null) {
      return db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [tipo.id],
      );
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOTipoManutencao>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps.map(_mapParaDto).toList();
  }

  Future<DTOTipoManutencao?> buscarPorId(int id) async {
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

  DTOTipoManutencao _mapParaDto(Map<String, dynamic> map) {
    return DTOTipoManutencao(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      descricao: map['descricao'] as String?,
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
