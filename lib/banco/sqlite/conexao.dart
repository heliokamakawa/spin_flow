import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'script.dart';

class ConexaoSQLite {
  static Database? _database;
  
  // MÃ©todo singleton para obter a instÃ¢ncia do banco
  static Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _inicializarBanco();
    return _database!;
  }

  static Future<Database> _inicializarBanco() async {
    // Configurar para diferentes plataformas
    if (kIsWeb) {
      // Web
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      // Desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Mobile usa o sqflite padrÃ£o

    // Caminho do banco
    String path;
    if (kIsWeb) {
      path = 'spin_flow.db';
    } else {
      String databasesPath = await databaseFactory.getDatabasesPath();
      path = join(databasesPath, 'spin_flow.db');
    }
    deleteDatabase(path);

    // Abrir ou criar banco
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _criarTabelas,
        onUpgrade: _atualizarBanco,
      ),
    );
  }

  static Future<void> _criarTabelas(Database db, int version) async {
    // Criar todas as tabelas
    for (String comando in ScriptSQLite.comandosCriarTabelas) {
      await db.execute(comando);
    }
    
    // Inserir dados iniciais
    for (List<String> insercoes in ScriptSQLite.comandosInsercoes) {
      for (String comando in insercoes) {
        await db.execute(comando);
      }
    }

    // Insercoes dinamicas para manter cenarios de teste alinhados com data/hora atual.
    for (final comando in ScriptSQLite.comandosInsercoesDinamicas(DateTime.now())) {
      await db.execute(comando);
    }
  }

  static Future<void> _atualizarBanco(Database db, int oldVersion, int newVersion) async {
    // LÃ³gica para atualizaÃ§Ãµes futuras
  }

  // MÃ©todo para fechar conexÃ£o
  static Future<void> fecharConexao() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
} 
