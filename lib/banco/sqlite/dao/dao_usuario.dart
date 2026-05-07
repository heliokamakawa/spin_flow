import 'package:spin_flow/banco/sqlite/conexao.dart';

class DAOUsuario {
  static const String _tabela = 'usuario';

  Future<Map<String, dynamic>?> autenticar({
    required String email,
    required String senha,
  }) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(
      _tabela,
      where: 'LOWER(email) = ? AND senha = ? AND ativo = 1',
      whereArgs: [email.toLowerCase().trim(), senha],
      limit: 1,
    );

    if (resultado.isEmpty) return null;
    return resultado.first;
  }

  Future<Map<String, dynamic>?> buscarPorEmailAtivo(String email) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(
      _tabela,
      where: 'LOWER(email) = ? AND ativo = 1',
      whereArgs: [email.toLowerCase().trim()],
      limit: 1,
    );
    if (resultado.isEmpty) return null;
    return resultado.first;
  }

  Future<int> atualizarSenha(int id, String novaSenha) async {
    final db = await ConexaoSQLite.database;
    return db.update(
      _tabela,
      {'senha': novaSenha},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> buscarPrimeiraProfessoraAtiva() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(
      _tabela,
      where: "LOWER(perfil) = 'professora' AND ativo = 1",
      orderBy: 'id ASC',
      limit: 1,
    );
    if (resultado.isEmpty) return null;
    return resultado.first;
  }
}

