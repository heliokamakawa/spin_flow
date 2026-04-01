import 'dart:convert';

import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/dto/dto_turma.dart';

import 'dao_sala.dart';

class DAOTurma {
  static const String _tabela = 'turma';
  final DAOSala _daoSala = DAOSala();

  Future<int> salvar(DTOTurma item) async {
    final db = await ConexaoSQLite.database;
    await _validarAtivacaoTurma(db, item);
    final dados = {
      'nome': item.nome,
      'descricao': item.descricao,
      'dias_semana': jsonEncode(item.diasSemana),
      'horario_inicio': item.horarioInicio,
      'duracao_minutos': item.duracaoMinutos,
      'sala_id': item.sala.id,
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOTurma>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOTurma> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<List<DTOTurma>> buscarAtivas() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'ativo = 1');
    final List<DTOTurma> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<DTOTurma?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapParaDTO(maps.first);
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

  Future<DTOTurma> _mapParaDTO(Map<String, dynamic> map) async {
    final salaId = _toInt(map['sala_id']);
    final sala = salaId != null ? await _daoSala.buscarPorId(salaId) : null;

    return DTOTurma(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      descricao: (map['descricao'] as String?) ?? '',
      diasSemana: _parseStrings((map['dias_semana'] as String?) ?? '[]'),
      horarioInicio: (map['horario_inicio'] as String?) ?? '',
      duracaoMinutos: _toInt(map['duracao_minutos']) ?? 0,
      sala: sala ?? DTOSala(nome: '', numeroFilas: 0, numeroColunas: 0, posicaoProfessora: 0),
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  List<String> _parseStrings(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<void> _validarAtivacaoTurma(dynamic db, DTOTurma item) async {
    if (!item.ativo) return;
    final salaId = item.sala.id;
    if (salaId == null) return;

    final maps = await db.query(
      _tabela,
      where: 'sala_id = ? AND ativo = 1',
      whereArgs: [salaId],
    );

    for (final map in maps) {
      final idExistente = _toInt(map['id']);
      if (item.id != null && idExistente == item.id) continue;

      final diasExistentes = _parseStrings((map['dias_semana'] as String?) ?? '[]').toSet();
      final diasNovos = item.diasSemana.toSet();
      final haDiaEmComum = diasExistentes.intersection(diasNovos).isNotEmpty;
      if (!haDiaEmComum) continue;

      final inicioExistente = (map['horario_inicio'] as String?) ?? '';
      final duracaoExistente = _toInt(map['duracao_minutos']) ?? 0;
      final conflito = _sobrepoeHorario(
        item.horarioInicio,
        item.duracaoMinutos,
        inicioExistente,
        duracaoExistente,
      );
      if (conflito) {
        throw Exception('Conflito de horario na mesma sala para turma ativa.');
      }
    }
  }

  bool _sobrepoeHorario(String h1, int d1, String h2, int d2) {
    final i1 = _minutosDoDia(h1);
    final i2 = _minutosDoDia(h2);
    final f1 = i1 + d1;
    final f2 = i2 + d2;
    return i1 < f2 && i2 < f1;
  }

  int _minutosDoDia(String horario) {
    final partes = horario.split(':');
    if (partes.length != 2) return 0;
    final h = int.tryParse(partes[0]) ?? 0;
    final m = int.tryParse(partes[1]) ?? 0;
    return h * 60 + m;
  }
}

