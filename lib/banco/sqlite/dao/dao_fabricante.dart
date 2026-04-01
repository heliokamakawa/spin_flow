import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';

class DAOFabricante {
  static const String _tabela = 'fabricante';

  Future<int> salvar(DTOFabricante fabricante) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': fabricante.nome,
      'descricao': fabricante.descricao,
      'nome_contato_principal': fabricante.nomeContatoPrincipal,
      'email_contato': fabricante.emailContato,
      'telefone_contato': fabricante.telefoneContato,
      'ativo': fabricante.ativo ? 1 : 0,
    };

    if (fabricante.id != null) {
      return db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [fabricante.id],
      );
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOFabricante>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps.map(_mapParaDto).toList();
  }

  Future<DTOFabricante?> buscarPorId(int id) async {
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

  DTOFabricante _mapParaDto(Map<String, dynamic> map) {
    return DTOFabricante(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      descricao: map['descricao'] as String?,
      nomeContatoPrincipal: map['nome_contato_principal'] as String?,
      emailContato: map['email_contato'] as String?,
      telefoneContato: map['telefone_contato'] as String?,
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
