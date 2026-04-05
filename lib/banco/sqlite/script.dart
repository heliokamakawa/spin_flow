class ScriptSQLite {
  static const String _criarTabelaFabricante = '''
    CREATE TABLE fabricante (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      nome_contato_principal TEXT,
      email_contato TEXT,
      telefone_contato TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaCategoriaMusica = '''
    CREATE TABLE categoria_musica (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaTipoManutencao = '''
    CREATE TABLE tipo_manutencao (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaArtistaBanda = '''
    CREATE TABLE artista_banda (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      link TEXT,
      foto TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaAluno = '''
    CREATE TABLE aluno (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT NOT NULL,
      data_nascimento TEXT NOT NULL,
      genero TEXT NOT NULL,
      telefone TEXT NOT NULL,
      url_foto TEXT,
      instagram TEXT,
      facebook TEXT,
      tiktok TEXT,
      observacoes TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaSala = '''
    CREATE TABLE sala (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      numero_filas INTEGER NOT NULL,
      numero_colunas INTEGER NOT NULL,
      posicao_professora INTEGER NOT NULL,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaBike = '''
    CREATE TABLE bike (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      numero_serie TEXT NOT NULL,
      fabricante_id INTEGER,
      data_cadastro TEXT NOT NULL,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaVideoAula = '''
    CREATE TABLE video_aula (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      link_video TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaUsuario = '''
    CREATE TABLE usuario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      senha TEXT NOT NULL,
      perfil TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaMusica = '''
    CREATE TABLE musica (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      artista_id INTEGER,
      categoria_ids TEXT,
      video_aula_ids TEXT,
      descricao TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaMix = '''
    CREATE TABLE mix (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      data_inicio TEXT NOT NULL,
      data_fim TEXT NOT NULL,
      musica_ids TEXT,
      descricao TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaTurma = '''
    CREATE TABLE turma (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT NOT NULL,
      dias_semana TEXT NOT NULL,
      horario_inicio TEXT NOT NULL,
      duracao_minutos INTEGER NOT NULL,
      sala_id INTEGER,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaGrupoAlunos = '''
    CREATE TABLE grupo_alunos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT NOT NULL,
      aluno_ids TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaManutencao = '''
    CREATE TABLE manutencao (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bike_id INTEGER,
      tipo_manutencao_id INTEGER,
      data_solicitacao TEXT NOT NULL,
      data_realizacao TEXT NOT NULL,
      descricao TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaCheckin = '''
    CREATE TABLE checkin (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      aluno_id INTEGER,
      turma_id INTEGER,
      data TEXT NOT NULL,
      fila INTEGER NOT NULL,
      coluna INTEGER NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaFilaEsperaCheckin = '''
    CREATE TABLE fila_espera_checkin (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      aluno_id INTEGER NOT NULL,
      turma_id INTEGER NOT NULL,
      data TEXT NOT NULL,
      criado_em TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaTurmaMix = '''
    CREATE TABLE turma_mix (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      turma_id INTEGER,
      mix_id INTEGER,
      data_inicio TEXT NOT NULL,
      data_fim TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaPosicaoBike = '''
    CREATE TABLE posicao_bike (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fila INTEGER NOT NULL,
      coluna INTEGER NOT NULL,
      bike_id INTEGER
    )
  ''';

  static const List<String> comandosCriarTabelas = [
    _criarTabelaFabricante,
    _criarTabelaCategoriaMusica,
    _criarTabelaTipoManutencao,
    _criarTabelaArtistaBanda,
    _criarTabelaAluno,
    _criarTabelaUsuario,
    _criarTabelaSala,
    _criarTabelaBike,
    _criarTabelaVideoAula,
    _criarTabelaMusica,
    _criarTabelaMix,
    _criarTabelaTurma,
    _criarTabelaGrupoAlunos,
    _criarTabelaManutencao,
    _criarTabelaCheckin,
    _criarTabelaFilaEsperaCheckin,
    _criarTabelaTurmaMix,
    _criarTabelaPosicaoBike,
  ];

  static const List<String> _insercoesFabricante = [
    "INSERT INTO fabricante (nome, ativo) VALUES ('Technogym', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Movement', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Schwinn Fitness', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Keiser', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Stages Cycling', 1)",
  ];

  static const List<String> _insercoesCategoriaMusica = [
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Cadencia', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Ritmo', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Forca', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Relaxamento', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Aquecimento', 1)",
  ];

  static const List<String> _insercoesTipoManutencao = [
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Pedal quebrado', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Regulagem de altura', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Banco com problema', 1)",
  ];

  static const List<String> _insercoesArtistaBanda = [
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('The Weeknd', 'R&B', 'https://theweeknd.com', 'https://example.com/theweeknd.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Dua Lipa', 'Pop', 'https://dualipa.com', 'https://example.com/dualipa.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Imagine Dragons', 'Rock', 'https://imaginedragonsmusic.com', 'https://example.com/imaginedragons.jpg', 1)",
  ];

  static const List<String> _insercoesAluno = [
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Ana Ribeiro', 'aluno@gmail.com', '1990-05-15', 'feminino', '(11) 99999-1111', 'https://example.com/aluno.jpg', 'https://instagram.com/ana.ribeiro', 'https://facebook.com/ana.ribeiro', 'https://tiktok.com/@ana.ribeiro', 'Aluna ativa para simulacao de uso real', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Joao Santos', 'joao.santos@email.com', '1985-08-22', 'masculino', '(11) 99999-2222', 'https://example.com/joao.jpg', 'https://instagram.com/joao.santos', 'https://facebook.com/joao.santos', 'https://tiktok.com/@joao.santos', 'Aluno iniciante', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Maria Costa', 'maria.costa@email.com', '1992-12-10', 'feminino', '(11) 99999-3333', 'https://example.com/maria.jpg', 'https://instagram.com/maria.costa', 'https://facebook.com/maria.costa', 'https://tiktok.com/@maria.costa', 'Aluna avancada', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Carlos Pereira', 'carlos.pereira@email.com', '1988-03-20', 'masculino', '(11) 99999-4444', '', '', '', '', 'Aluno intermediario', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Fernanda Lima', 'fernanda.lima@email.com', '1995-07-08', 'feminino', '(11) 99999-5555', '', '', '', '', 'Alta frequencia', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Lucas Oliveira', 'lucas.oliveira@email.com', '1993-11-30', 'masculino', '(11) 99999-6666', '', '', '', '', 'Preferencia turma manha', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Patricia Souza', 'patricia.souza@email.com', '1987-01-25', 'feminino', '(11) 99999-7777', '', '', '', '', 'Aluna desde 2024', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Roberto Gomes', 'roberto.gomes@email.com', '1991-09-14', 'masculino', '(11) 99999-8888', '', '', '', '', 'Treina 3x por semana', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Juliana Martins', 'juliana.martins@email.com', '1994-06-03', 'feminino', '(11) 99999-9999', '', '', '', '', 'Aluna nova', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Bruno Almeida', 'bruno.almeida@email.com', '1989-04-18', 'masculino', '(11) 98888-1111', '', '', '', '', 'Aluno inativo de exemplo', 0)",
  ];

  static const List<String> _insercoesUsuario = [
    "INSERT INTO usuario (nome, email, senha, perfil, ativo) VALUES ('Professora', 'professora@gmail.com', '123', 'professora', 1)",
    "INSERT INTO usuario (nome, email, senha, perfil, ativo) VALUES ('Aluno', 'aluno@gmail.com', '123', 'aluno', 1)",
  ];

  static const List<String> _insercoesSala = [
    "INSERT INTO sala (nome, numero_filas, numero_colunas, posicao_professora, ativa) VALUES ('Sala Principal', 4, 5, 2, 1)",
    "INSERT INTO sala (nome, numero_filas, numero_colunas, posicao_professora, ativa) VALUES ('Sala VIP', 3, 4, 1, 1)",
  ];

  static const List<String> _insercoesBike = [
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 01', 'BK-0001', 1, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 02', 'BK-0002', 2, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 03', 'BK-0003', 3, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 04', 'BK-0004', 4, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 05', 'BK-0005', 5, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 06', 'BK-0006', 1, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 07', 'BK-0007', 2, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 08', 'BK-0008', 3, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 09', 'BK-0009', 4, '2026-01-05T10:00:00', 1)",
    "INSERT INTO bike (nome, numero_serie, fabricante_id, data_cadastro, ativa) VALUES ('Bike 10', 'BK-0010', 5, '2026-01-05T10:00:00', 1)",
  ];

  static const List<String> _insercoesVideoAula = [
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Aquecimento Base', 'https://www.youtube.com/watch?v=4NRXx6U8ABQ', 1)",
    "INSERT INTO video_aula (nome, link_video, ativo) VALUES ('Sprint em Pe', 'https://www.youtube.com/watch?v=TUVcZfQe-Kw', 1)",
  ];

  static const List<String> _insercoesMusica = [
    "INSERT INTO musica (nome, artista_id, categoria_ids, video_aula_ids, descricao, ativo) VALUES ('Blinding Lights', 1, '[1,2]', '[1]', 'Aquecimento e ritmo inicial', 1)",
    "INSERT INTO musica (nome, artista_id, categoria_ids, video_aula_ids, descricao, ativo) VALUES ('Levitating', 2, '[1,2]', '[1,2]', 'Cadencia com foco em ritmo', 1)",
    "INSERT INTO musica (nome, artista_id, categoria_ids, video_aula_ids, descricao, ativo) VALUES ('Believer', 3, '[3]', '[2]', 'Bloco de forca e resistencia', 1)",
  ];

  static const List<String> _insercoesMix = [
    "INSERT INTO mix (nome, data_inicio, data_fim, musica_ids, descricao, ativo) VALUES ('Mix Endurance Morning', '2026-01-01T00:00:00', '2026-12-31T23:59:59', '[1,2,3]', 'Mix principal da turma matinal', 1)",
    "INSERT INTO mix (nome, data_inicio, data_fim, musica_ids, descricao, ativo) VALUES ('Mix Power Sunset', '2026-01-01T00:00:00', '2026-12-31T23:59:59', '[2,3]', 'Mix foco em performance no fim do dia', 1)",
  ];

  static const List<String> _insercoesTurma = [
    "INSERT INTO turma (nome, descricao, dias_semana, horario_inicio, duracao_minutos, sala_id, ativo) VALUES ('Power Ride 07h', 'Treino intenso de manha', '[\"Seg\",\"Qua\",\"Sex\"]', '07:00', 50, 1, 1)",
    "INSERT INTO turma (nome, descricao, dias_semana, horario_inicio, duracao_minutos, sala_id, ativo) VALUES ('Endurance 18h30', 'Treino de fim de tarde', '[\"Ter\",\"Qui\"]', '18:30', 50, 2, 1)",
  ];

  static const List<String> _insercoesGrupoAlunos = [
    "INSERT INTO grupo_alunos (nome, descricao, aluno_ids, ativo) VALUES ('Grupo Frequencia Alta', 'Alunos com alta presenca semanal', '[1,2,3]', 1)",
  ];

  static const List<String> _insercoesTurmaMix = [
    "INSERT INTO turma_mix (turma_id, mix_id, data_inicio, data_fim, ativo) VALUES (1, 1, '2026-01-01T00:00:00', '2026-12-31T23:59:59', 1)",
    "INSERT INTO turma_mix (turma_id, mix_id, data_inicio, data_fim, ativo) VALUES (2, 2, '2026-01-01T00:00:00', '2026-12-31T23:59:59', 1)",
  ];

  static const List<String> _insercoesPosicaoBike = [
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (0, 0, 1)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (0, 1, 2)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (0, 3, 3)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (0, 4, 4)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (1, 0, 5)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (1, 1, 6)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (1, 2, 7)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (1, 3, 8)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (1, 4, 9)",
    "INSERT INTO posicao_bike (fila, coluna, bike_id) VALUES (2, 2, 10)",
  ];

  static const List<String> _insercoesManutencao = [
    "INSERT INTO manutencao (bike_id, tipo_manutencao_id, data_solicitacao, data_realizacao, descricao, ativo) VALUES (3, 1, '2026-03-25T08:00:00', '2026-04-05T08:00:00', 'Pedal com folga', 1)",
    "INSERT INTO manutencao (bike_id, tipo_manutencao_id, data_solicitacao, data_realizacao, descricao, ativo) VALUES (7, 2, '2026-03-28T09:00:00', '2026-03-30T14:00:00', 'Altura do banco desregulada', 0)",
    "INSERT INTO manutencao (bike_id, tipo_manutencao_id, data_solicitacao, data_realizacao, descricao, ativo) VALUES (5, 3, '2026-04-01T10:00:00', '2026-04-01T10:00:00', 'Banco com rachadura, necessita troca', 1)",
    "INSERT INTO manutencao (bike_id, tipo_manutencao_id, data_solicitacao, data_realizacao, descricao, ativo) VALUES (9, 1, '2026-04-03T07:30:00', '2026-04-03T07:30:00', 'Pedal esquerdo travando', 1)",
  ];

  static const List<String> _insercoesCheckin = [
    // Check-ins historicos (concluidos - datas passadas)
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-03-03T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-03-05T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-03-10T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 2, '2026-03-11T18:30:00', 0, 0, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-03-17T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-03-24T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-03-31T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-04-01T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (2, 1, '2026-03-03T07:00:00', 1, 3, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (2, 1, '2026-03-10T07:00:00', 1, 3, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (2, 1, '2026-04-01T07:00:00', 1, 3, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (3, 2, '2026-03-04T18:30:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (3, 2, '2026-03-11T18:30:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (4, 1, '2026-03-05T07:00:00', 0, 0, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (4, 1, '2026-03-10T07:00:00', 0, 0, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (4, 2, '2026-03-11T18:30:00', 0, 3, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (5, 1, '2026-03-03T07:00:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (5, 1, '2026-03-05T07:00:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (5, 1, '2026-03-10T07:00:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (5, 1, '2026-03-17T07:00:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (5, 2, '2026-03-18T18:30:00', 0, 0, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (6, 1, '2026-03-05T07:00:00', 0, 3, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (6, 1, '2026-03-17T07:00:00', 0, 3, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (7, 2, '2026-03-04T18:30:00', 0, 0, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (7, 2, '2026-03-18T18:30:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (8, 1, '2026-03-10T07:00:00', 0, 4, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (8, 1, '2026-03-24T07:00:00', 0, 4, 1)",
    // Check-in cancelado (historico preservado)
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 2, '2026-03-18T18:30:00', 0, 0, 0)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (3, 1, '2026-03-17T07:00:00', 1, 4, 0)",
    // Check-in futuro (agendado)
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (1, 1, '2026-04-14T07:00:00', 1, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (5, 1, '2026-04-14T07:00:00', 0, 1, 1)",
    "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES (2, 2, '2026-04-15T18:30:00', 0, 1, 1)",
  ];

  static const List<String> _insercoesFilaEspera = [
    "INSERT INTO fila_espera_checkin (aluno_id, turma_id, data, criado_em, ativo) VALUES (3, 1, '2026-04-01T07:00:00', '2026-04-01T06:50:00', 1)",
  ];

  static const List<List<String>> comandosInsercoes = [
    _insercoesFabricante,
    _insercoesCategoriaMusica,
    _insercoesTipoManutencao,
    _insercoesArtistaBanda,
    _insercoesAluno,
    _insercoesUsuario,
    _insercoesSala,
    _insercoesBike,
    _insercoesVideoAula,
    _insercoesMusica,
    _insercoesMix,
    _insercoesTurma,
    _insercoesGrupoAlunos,
    _insercoesTurmaMix,
    _insercoesPosicaoBike,
    _insercoesManutencao,
    _insercoesCheckin,
    _insercoesFilaEspera,
  ];

  static List<String> comandosInsercoesDinamicas(DateTime agora) {
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final ontem = hoje.subtract(const Duration(days: 1));
    final amanha = hoje.add(const Duration(days: 1));

    // Turma 1: abre reserva em ~1 minuto (aula em +31 min, regra de 30 min).
    final horaAula1 = agora.add(const Duration(minutes: 31));
    // Turma 2: já está em janela de reserva (aula começou há 1 min).
    final horaAula2 = agora.subtract(const Duration(minutes: 1));

    final horario1 = _formatarHora(horaAula1);
    final horario2 = _formatarHora(horaAula2);

    final hojeIso = hoje.toIso8601String();
    final ontemIso = ontem.toIso8601String();
    final amanhaIso = amanha.toIso8601String();
    final criadoFila = agora.subtract(const Duration(minutes: 5)).toIso8601String();

    final diaHoje = _siglaDiaSemana(hoje.weekday);
    final diaAmanha = _siglaDiaSemana(amanha.weekday);
    final nomeSalaJanela = 'Sala Check-in Janela';
    final nomeSalaLotada = 'Sala Check-in Lotada';
    final nomeTurmaDinamica1 = 'Power Ride Janela';
    final nomeTurmaDinamica2 = 'Endurance Lotada';

    return [
      "INSERT INTO sala (nome, numero_filas, numero_colunas, posicao_professora, ativa) VALUES ('$nomeSalaJanela', 1, 2, 0, 1)",
      "INSERT INTO sala (nome, numero_filas, numero_colunas, posicao_professora, ativa) VALUES ('$nomeSalaLotada', 1, 2, 0, 1)",
      "INSERT INTO turma (nome, descricao, dias_semana, horario_inicio, duracao_minutos, sala_id, ativo) VALUES ('$nomeTurmaDinamica1', 'Turma dinamica para validar bloqueio por janela e liberacao da reserva logo em seguida', '[\"$diaHoje\"]', '$horario1', 50, (SELECT id FROM sala WHERE nome = '$nomeSalaJanela' ORDER BY id DESC LIMIT 1), 1)",
      "INSERT INTO turma (nome, descricao, dias_semana, horario_inicio, duracao_minutos, sala_id, ativo) VALUES ('$nomeTurmaDinamica2', 'Turma dinamica propositalmente lotada para validar fila de espera no check-in', '[\"$diaHoje\",\"$diaAmanha\"]', '$horario2', 45, (SELECT id FROM sala WHERE nome = '$nomeSalaLotada' ORDER BY id DESC LIMIT 1), 1)",
      "INSERT INTO turma_mix (turma_id, mix_id, data_inicio, data_fim, ativo) VALUES ((SELECT id FROM turma WHERE nome = '$nomeTurmaDinamica1' ORDER BY id DESC LIMIT 1), 1, '$hojeIso', '$amanhaIso', 1)",
      "INSERT INTO turma_mix (turma_id, mix_id, data_inicio, data_fim, ativo) VALUES ((SELECT id FROM turma WHERE nome = '$nomeTurmaDinamica2' ORDER BY id DESC LIMIT 1), 2, '$hojeIso', '$amanhaIso', 1)",
      "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES ((SELECT id FROM aluno WHERE LOWER(email) = 'aluno@gmail.com' LIMIT 1), (SELECT id FROM turma WHERE nome = '$nomeTurmaDinamica1' ORDER BY id DESC LIMIT 1), '$amanhaIso', 1, 2, 1)",
      "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES ((SELECT id FROM aluno WHERE LOWER(email) = 'aluno@gmail.com' LIMIT 1), (SELECT id FROM turma WHERE nome = '$nomeTurmaDinamica1' ORDER BY id DESC LIMIT 1), '$ontemIso', 1, 0, 1)",
      "INSERT INTO checkin (aluno_id, turma_id, data, fila, coluna, ativo) VALUES ((SELECT id FROM aluno WHERE LOWER(email) = 'joao.santos@email.com' LIMIT 1), (SELECT id FROM turma WHERE nome = '$nomeTurmaDinamica2' ORDER BY id DESC LIMIT 1), '$hojeIso', 0, 1, 1)",
      "INSERT INTO fila_espera_checkin (aluno_id, turma_id, data, criado_em, ativo) VALUES ((SELECT id FROM aluno WHERE LOWER(email) = 'maria.costa@email.com' LIMIT 1), (SELECT id FROM turma WHERE nome = '$nomeTurmaDinamica2' ORDER BY id DESC LIMIT 1), '$hojeIso', '$criadoFila', 1)",
    ];
  }

  static String _formatarHora(DateTime data) {
    final h = data.hour.toString().padLeft(2, '0');
    final m = data.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _siglaDiaSemana(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Seg';
      case DateTime.tuesday:
        return 'Ter';
      case DateTime.wednesday:
        return 'Qua';
      case DateTime.thursday:
        return 'Qui';
      case DateTime.friday:
        return 'Sex';
      case DateTime.saturday:
        return 'Sab';
      default:
        return 'Dom';
    }
  }
}
