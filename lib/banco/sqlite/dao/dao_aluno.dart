import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_aluno.dart';

class DAOAluno {
  static const String _tabela = 'aluno';

  Future<int> salvar(DTOAluno aluno) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': aluno.nome,
      'email': aluno.email,
      'data_nascimento': aluno.dataNascimento.toIso8601String(),
      'genero': aluno.genero,
      'telefone': aluno.telefone,
      'url_foto': aluno.urlFoto,
      'instagram': aluno.instagram,
      'facebook': aluno.facebook,
      'tiktok': aluno.tiktok,
      'observacoes': aluno.observacoes,
      'ativo': aluno.ativo ? 1 : 0,
    };

    if (aluno.id != null) {
      return db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [aluno.id],
      );
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOAluno>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    return maps.map(_mapParaDto).toList();
  }

  Future<List<DTOAluno>> buscarAtivos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'ativo = 1');
    return maps.map(_mapParaDto).toList();
  }

  Future<DTOAluno?> buscarPorId(int id) async {
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

  Future<DTOAluno?> buscarPorEmailAtivo(String email) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'LOWER(email) = ? AND ativo = 1',
      whereArgs: [email.toLowerCase().trim()],
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

  DTOAluno _mapParaDto(Map<String, dynamic> map) {
    return DTOAluno(
      id: map['id'] as int?,
      nome: (map['nome'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      dataNascimento: DateTime.tryParse((map['data_nascimento'] as String?) ?? '') ?? DateTime.now(),
      genero: (map['genero'] as String?) ?? '',
      telefone: (map['telefone'] as String?) ?? '',
      urlFoto: (map['url_foto'] as String?) ?? '',
      instagram: (map['instagram'] as String?) ?? '',
      facebook: (map['facebook'] as String?) ?? '',
      tiktok: (map['tiktok'] as String?) ?? '',
      observacoes: (map['observacoes'] as String?) ?? '',
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }
}

