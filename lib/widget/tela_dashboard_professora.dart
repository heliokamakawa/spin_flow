import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_checkin.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_mix.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_turma.dart';

import '../configuracoes/rotas.dart';
import '../configuracoes/sessao_usuario.dart';

class TelaDashboardProfessora extends StatefulWidget {
  const TelaDashboardProfessora({super.key});

  @override
  State<TelaDashboardProfessora> createState() => _TelaDashboardProfessoraState();
}

class _TelaDashboardProfessoraState extends State<TelaDashboardProfessora> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _abas = const [
    Tab(icon: Icon(Icons.dashboard), text: 'Visão Geral'),
    Tab(icon: Icon(Icons.folder_copy), text: 'Cadastros'),
    Tab(icon: Icon(Icons.list), text: 'Listas'),
    Tab(icon: Icon(Icons.event), text: 'Aulas'),
    Tab(icon: Icon(Icons.build), text: 'Manutenção'),
  ];

  // Métricas carregadas do banco
  int _alunosAtivos = 0;
  int _turmasAtivas = 0;
  int _mixesAtivos = 0;
  int _bikesAtivas = 0;
  int _bikesManutencao = 0;
  int _checkinsHoje = 0;
  bool _carregandoMetricas = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _abas.length, vsync: this);
    _carregarMetricas();
  }

  Future<void> _carregarMetricas() async {
    setState(() => _carregandoMetricas = true);
    try {
      final alunos = await DAOAluno().buscarTodos();
      final turmas = await DAOTurma().buscarTodos();
      final mixes = await DAOMix().buscarTodos();
      final bikes = await DAOBike().buscarTodos();
      final bikesManut = await DAOManutencao().buscarBikeIdsEmManutencaoAtiva();
      final checkins = await DAOCheckin().buscarTodos();

      final agora = DateTime.now();
      final hojeSemHora = DateTime(agora.year, agora.month, agora.day);
      final checkinsHoje = checkins.where((c) {
        final d = DateTime(c.data.year, c.data.month, c.data.day);
        return c.ativo && d.isAtSameMomentAs(hojeSemHora);
      }).length;

      if (!mounted) return;
      setState(() {
        _alunosAtivos = alunos.where((a) => a.ativo).length;
        _turmasAtivas = turmas.where((t) => t.ativo).length;
        _mixesAtivos = mixes.where((m) => m.ativo).length;
        _bikesAtivas = bikes.where((b) => b.ativa).length;
        _bikesManutencao = bikesManut.length;
        _checkinsHoje = checkinsHoje;
        _carregandoMetricas = false;
      });
    } catch (_) {
      if (mounted) setState(() => _carregandoMetricas = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard da Professora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              SessaoUsuario.encerrar();
              Navigator.pushReplacementNamed(context, Rotas.login);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _abas,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _visaoGeral(),
          _cadastros(),
          _listas(),
          _aulas(),
          _manutencao(),
        ],
      ),
    );
  }

  Widget _visaoGeral() {
    if (_carregandoMetricas) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _carregarMetricas,
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _InfoCard(
            titulo: 'Alunos Ativos',
            valor: '$_alunosAtivos',
            icone: Icons.person,
            cor: Colors.blue,
            onTap: () => Navigator.pushNamed(context, Rotas.listaAlunos),
          ),
          _InfoCard(
            titulo: 'Turmas Ativas',
            valor: '$_turmasAtivas',
            icone: Icons.event,
            cor: Colors.purple,
            onTap: () => Navigator.pushNamed(context, Rotas.listaTurmas),
          ),
          _InfoCard(
            titulo: 'Mixes Ativos',
            valor: '$_mixesAtivos',
            icone: Icons.queue_music,
            cor: Colors.teal,
            onTap: () => Navigator.pushNamed(context, Rotas.listaMixes),
          ),
          _InfoCard(
            titulo: 'Bikes OK',
            valor: '$_bikesAtivas',
            icone: Icons.directions_bike,
            cor: Colors.green,
            onTap: () => Navigator.pushNamed(context, Rotas.listaBikes),
          ),
          _InfoCard(
            titulo: 'Em Manutenção',
            valor: '$_bikesManutencao',
            icone: Icons.build,
            cor: Colors.orange,
            onTap: () => Navigator.pushNamed(context, Rotas.listaManutencoes),
          ),
          _InfoCard(
            titulo: 'Check-ins Hoje',
            valor: '$_checkinsHoje',
            icone: Icons.pin_drop,
            cor: Colors.deepPurple,
            onTap: () => Navigator.pushNamed(context, Rotas.listaCheckins),
          ),
          _InfoCard(
            titulo: 'Relatórios',
            valor: 'Gerenciais',
            icone: Icons.bar_chart,
            cor: Colors.indigo,
            onTap: () => Navigator.pushNamed(context, Rotas.relatoriosProfessora),
          ),
        ],
      ),
    );
  }

  Widget _cadastros() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Cadastros Simples', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _CadastroTile('Fabricante', Icons.factory, () => Navigator.pushNamed(context, Rotas.cadastroFabricante)),
        _CadastroTile('Sala', Icons.meeting_room, () => Navigator.pushNamed(context, Rotas.cadastroSala)),
        _CadastroTile('Tipo de Manutenção', Icons.build, () => Navigator.pushNamed(context, Rotas.cadastroTipoManutencao)),
        _CadastroTile('Categorias de Musica', Icons.category, () => Navigator.pushNamed(context, Rotas.cadastroCategoriaMusica)),
        _CadastroTile('Video-aula', Icons.ondemand_video, () => Navigator.pushNamed(context, Rotas.cadastroVideoAula)),
        _CadastroTile('Artistas/Bandas', Icons.music_video, () => Navigator.pushNamed(context, Rotas.cadastroArtistaBanda)),
        _CadastroTile('Alunos', Icons.person, () => Navigator.pushNamed(context, Rotas.cadastroAluno)),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Cadastros com Associações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _CadastroTile('Bikes', Icons.directions_bike, () => Navigator.pushNamed(context, Rotas.cadastroBike)),
        _CadastroTile('Musicas', Icons.library_music, () => Navigator.pushNamed(context, Rotas.cadastroMusica)),
        _CadastroTile('Mix', Icons.queue_music, () => Navigator.pushNamed(context, Rotas.cadastroMix)),
        _CadastroTile('Turmas', Icons.group, () => Navigator.pushNamed(context, Rotas.cadastroTurma)),
        _CadastroTile('Turma x Mix', Icons.sync_alt, () => Navigator.pushNamed(context, Rotas.cadastroTurmaMix)),
        _CadastroTile('Grupos de Alunos', Icons.groups, () => Navigator.pushNamed(context, Rotas.cadastroGrupoAlunos)),
      ],
    );
  }

  Widget _listas() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Listas Simples', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _CadastroTile('Fabricantes', Icons.factory, () => Navigator.pushNamed(context, Rotas.listaFabricantes)),
        _CadastroTile('Categorias de Musica', Icons.category, () => Navigator.pushNamed(context, Rotas.listaCategoriasMusica)),
        _CadastroTile('Tipos de Manutenção', Icons.build, () => Navigator.pushNamed(context, Rotas.listaTiposManutencao)),
        _CadastroTile('Artistas/Bandas', Icons.music_video, () => Navigator.pushNamed(context, Rotas.listaArtistasBandas)),
        _CadastroTile('Alunos', Icons.person, () => Navigator.pushNamed(context, Rotas.listaAlunos)),
        _CadastroTile('Salas', Icons.room, () => Navigator.pushNamed(context, Rotas.listaSalas)),
        _CadastroTile('Video-aula', Icons.ondemand_video, () => Navigator.pushNamed(context, Rotas.listaVideoAula)),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Listas com Associações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _CadastroTile('Bikes', Icons.directions_bike, () => Navigator.pushNamed(context, Rotas.listaBikes)),
        _CadastroTile('Musicas', Icons.library_music, () => Navigator.pushNamed(context, Rotas.listaMusicas)),
        _CadastroTile('Mixes', Icons.queue_music, () => Navigator.pushNamed(context, Rotas.listaMixes)),
        _CadastroTile('Turmas', Icons.group, () => Navigator.pushNamed(context, Rotas.listaTurmas)),
        _CadastroTile('Grupos de Alunos', Icons.groups, () => Navigator.pushNamed(context, Rotas.listaGruposAlunos)),
        _CadastroTile('Manutenções', Icons.build_circle, () => Navigator.pushNamed(context, Rotas.listaManutencoes)),
        _CadastroTile('Check-ins', Icons.event_available, () => Navigator.pushNamed(context, Rotas.listaCheckins)),
      ],
    );
  }

  Widget _aulas() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CadastroTile('Turmas', Icons.calendar_today, () => Navigator.pushNamed(context, Rotas.listaTurmas)),
        _CadastroTile('Registrar Check-in', Icons.pin_drop, () => Navigator.pushNamed(context, Rotas.cadastroCheckin)),
        _CadastroTile('Associar Turma x Mix', Icons.library_music, () => Navigator.pushNamed(context, Rotas.cadastroTurmaMix)),
        _CadastroTile('Posicionamento de Bikes', Icons.grid_on, () => Navigator.pushNamed(context, Rotas.posicionamentoBikes)),
        _CadastroTile(
          'Mapa operacional (cancelar check-ins)',
          Icons.grid_view,
          () => Navigator.pushNamed(context, Rotas.mapaOperacionalProfessora),
        ),
        _CadastroTile('Consultar Check-ins', Icons.event_available, () => Navigator.pushNamed(context, Rotas.listaCheckins)),
        _CadastroTile('Relatórios Gerenciais', Icons.bar_chart, () => Navigator.pushNamed(context, Rotas.relatoriosProfessora)),
      ],
    );
  }

  Widget _manutencao() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CadastroTile('Bikes', Icons.directions_bike, () => Navigator.pushNamed(context, Rotas.listaBikes)),
        _CadastroTile('Tipos de Manutenção', Icons.handyman, () => Navigator.pushNamed(context, Rotas.listaTiposManutencao)),
        _CadastroTile('Registrar Manutenção', Icons.build, () => Navigator.pushNamed(context, Rotas.cadastroManutencao)),
        _CadastroTile('Consultar Manutenções', Icons.build_circle, () => Navigator.pushNamed(context, Rotas.listaManutencoes)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color cor;
  final VoidCallback? onTap;

  const _InfoCard({required this.titulo, required this.valor, required this.icone, this.cor = Colors.blue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 40, color: cor),
              const SizedBox(height: 16),
              Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cor)),
              const SizedBox(height: 8),
              Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CadastroTile extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onTap;

  const _CadastroTile(this.titulo, this.icone, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icone),
      title: Text(titulo),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
