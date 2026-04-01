import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/dto/dto_checkin.dart';
import 'package:spin_flow/dto/dto_fila_espera_checkin.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/dto/dto_turma.dart';

import 'dao_aluno.dart';
import 'dao_fila_espera_checkin.dart';
import 'dao_turma.dart';

class DAOCheckin {
  static const String _tabela = 'checkin';
  final DAOAluno _daoAluno = DAOAluno();
  final DAOTurma _daoTurma = DAOTurma();
  final DAOFilaEsperaCheckin _daoFilaEspera = DAOFilaEsperaCheckin();

  Future<int> salvar(DTOCheckin item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'aluno_id': item.aluno.id,
      'turma_id': item.turma.id,
      'data': item.data.toIso8601String(),
      'fila': item.fila,
      'coluna': item.coluna,
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<int> reservarComValidacao(DTOCheckin item) async {
    final agora = DateTime.now();
    final data = DateTime(item.data.year, item.data.month, item.data.day);
    final hojeSemHora = DateTime(agora.year, agora.month, agora.day);

    if (data.isBefore(hojeSemHora)) {
      throw Exception('Nao e permitido reservar para data passada.');
    }
    if (!_respeitaJanelaMinima30Min(item.turma, item.data, agora: agora)) {
      throw Exception('Reserva disponivel apenas a partir de 30 minutos antes da aula.');
    }
    if (!item.aluno.ativo) {
      throw Exception('Aluno inativo nao pode reservar.');
    }

    final existeAluno = await existeCheckinAtivoAluno(
      alunoId: item.aluno.id ?? 0,
      turmaId: item.turma.id ?? 0,
      data: item.data,
    );
    if (existeAluno) {
      throw Exception('Aluno ja possui check-in ativo para a turma nesta data.');
    }

    final ocupada = await existeCheckinAtivoPosicao(
      turmaId: item.turma.id ?? 0,
      data: item.data,
      fila: item.fila,
      coluna: item.coluna,
    );
    if (ocupada) {
      throw Exception('Posicao ja ocupada para turma e data selecionadas.');
    }

    return salvar(item);
  }

  Future<List<DTOCheckin>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOCheckin> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<List<DTOCheckin>> buscarAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      where: 'turma_id = ? AND ativo = 1 AND substr(data, 1, 10) = ?',
      whereArgs: [turmaId, _chaveData(data)],
    );

    final List<DTOCheckin> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<List<DTOCheckin>> buscarPorAluno(int alunoId) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'aluno_id = ?', whereArgs: [alunoId]);
    final List<DTOCheckin> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<bool> existeCheckinAtivoAluno({
    required int alunoId,
    required int turmaId,
    required DateTime data,
  }) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      columns: ['id'],
      where: 'aluno_id = ? AND turma_id = ? AND ativo = 1 AND substr(data, 1, 10) = ?',
      whereArgs: [alunoId, turmaId, _chaveData(data)],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  Future<bool> existeCheckinAtivoPosicao({
    required int turmaId,
    required DateTime data,
    required int fila,
    required int coluna,
  }) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      columns: ['id'],
      where: 'turma_id = ? AND ativo = 1 AND fila = ? AND coluna = ? AND substr(data, 1, 10) = ?',
      whereArgs: [turmaId, fila, coluna, _chaveData(data)],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  Future<int> cancelar(int id) async {
    final db = await ConexaoSQLite.database;
    final checkin = await buscarPorId(id);
    if (checkin == null) return 0;

    final cancelados = await db.update(
      _tabela,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    if (cancelados <= 0) return cancelados;

    await _promoverFilaDeEspera(
      turma: checkin.turma,
      data: checkin.data,
      fila: checkin.fila,
      coluna: checkin.coluna,
    );
    return cancelados;
  }

  Future<DTOCheckin?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapParaDTO(maps.first);
  }

  Future<int> excluir(int id) async {
    return cancelar(id);
  }

  Future<DTOCheckin> _mapParaDTO(Map<String, dynamic> map) async {
    final alunoId = _toInt(map['aluno_id']);
    final turmaId = _toInt(map['turma_id']);

    final aluno = alunoId != null ? await _daoAluno.buscarPorId(alunoId) : null;
    final turma = turmaId != null ? await _daoTurma.buscarPorId(turmaId) : null;

    return DTOCheckin(
      id: _toInt(map['id']),
      aluno: aluno ?? DTOAluno(nome: '', email: '', dataNascimento: DateTime.now(), genero: '', telefone: '', urlFoto: '', instagram: '', facebook: '', tiktok: '', observacoes: ''),
      turma: turma ?? DTOTurma(nome: '', descricao: '', diasSemana: const [], horarioInicio: '', duracaoMinutos: 0, sala: DTOSala(nome: '', numeroFilas: 0, numeroColunas: 0, posicaoProfessora: 0)),
      data: DateTime.tryParse((map['data'] as String?) ?? '') ?? DateTime.now(),
      fila: _toInt(map['fila']) ?? 0,
      coluna: _toInt(map['coluna']) ?? 0,
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  Future<void> _promoverFilaDeEspera({
    required DTOTurma turma,
    required DateTime data,
    required int fila,
    required int coluna,
  }) async {
    final turmaId = turma.id;
    if (turmaId == null) return;

    while (true) {
      final DTOFilaEsperaCheckin? candidato = await _daoFilaEspera.buscarPrimeiroAtivoPorTurmaData(
        turmaId: turmaId,
        data: data,
      );
      if (candidato == null) return;

      await _daoFilaEspera.sairDaFila(candidato.id ?? 0);

      final aluno = await _daoAluno.buscarPorId(candidato.alunoId);
      if (aluno == null || !aluno.ativo) {
        continue;
      }

      final jaTem = await existeCheckinAtivoAluno(
        alunoId: aluno.id ?? 0,
        turmaId: turmaId,
        data: data,
      );
      if (jaTem) {
        continue;
      }

      final dto = DTOCheckin(
        aluno: aluno,
        turma: turma,
        data: data,
        fila: fila,
        coluna: coluna,
        ativo: true,
      );

      await salvar(dto);
      return;
    }
  }

  bool _respeitaJanelaMinima30Min(DTOTurma turma, DateTime dataAula, {DateTime? agora}) {
    final atual = agora ?? DateTime.now();
    final dataDia = DateTime(dataAula.year, dataAula.month, dataAula.day);
    final hoje = DateTime(atual.year, atual.month, atual.day);

    if (dataDia.isAfter(hoje) || dataDia.isBefore(hoje)) {
      return false;
    }

    final inicio = _inicioAula(turma, dataAula);
    final limite = inicio.subtract(const Duration(minutes: 30));
    return !atual.isBefore(limite);
  }

  DateTime _inicioAula(DTOTurma turma, DateTime dataAula) {
    final partes = turma.horarioInicio.split(':');
    final hora = partes.isNotEmpty ? int.tryParse(partes[0]) ?? 0 : 0;
    final minuto = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    return DateTime(dataAula.year, dataAula.month, dataAula.day, hora, minuto);
  }

  String _chaveData(DateTime data) {
    final d = DateTime(data.year, data.month, data.day);
    return d.toIso8601String().substring(0, 10);
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
