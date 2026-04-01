import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _abas.length, vsync: this);
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
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _InfoCard(
          titulo: 'Cadastros',
          valor: 'Operacional',
          icone: Icons.folder_copy,
          onTap: () => _tabController.animateTo(1),
        ),
        _InfoCard(
          titulo: 'Listas',
          valor: 'Consulta',
          icone: Icons.list,
          onTap: () => _tabController.animateTo(2),
        ),
        _InfoCard(
          titulo: 'Aulas',
          valor: 'Check-in',
          icone: Icons.event,
          onTap: () => _tabController.animateTo(3),
        ),
        _InfoCard(
          titulo: 'Manutenção',
          valor: 'Bikes',
          icone: Icons.build,
          onTap: () => _tabController.animateTo(4),
        ),
      ],
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
        _CadastroTile('Fabricantes', Icons.factory, () => Navigator.pushNamed(context, Rotas.listaFabricantes)),
        _CadastroTile('Categorias de Musica', Icons.category, () => Navigator.pushNamed(context, Rotas.listaCategoriasMusica)),
        _CadastroTile('Tipos de Manutenção', Icons.build, () => Navigator.pushNamed(context, Rotas.listaTiposManutencao)),
        _CadastroTile('Artistas/Bandas', Icons.music_video, () => Navigator.pushNamed(context, Rotas.listaArtistasBandas)),
        _CadastroTile('Alunos', Icons.person, () => Navigator.pushNamed(context, Rotas.listaAlunos)),
        _CadastroTile('Salas', Icons.room, () => Navigator.pushNamed(context, Rotas.listaSalas)),
        _CadastroTile('Video-aula', Icons.ondemand_video, () => Navigator.pushNamed(context, Rotas.listaVideoAula)),
        _CadastroTile('Bikes', Icons.directions_bike, () => Navigator.pushNamed(context, Rotas.listaBikes)),
        _CadastroTile('Musicas', Icons.library_music, () => Navigator.pushNamed(context, Rotas.listaMusicas)),
        _CadastroTile('Mixes', Icons.queue_music, () => Navigator.pushNamed(context, Rotas.listaMixes)),
        _CadastroTile('Turmas', Icons.group, () => Navigator.pushNamed(context, Rotas.listaTurmas)),
        _CadastroTile('Grupos de Alunos', Icons.groups, () => Navigator.pushNamed(context, Rotas.listaGruposAlunos)),
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
      ],
    );
  }

  Widget _manutencao() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _CadastroTile('Bikes', Icons.directions_bike, () => Navigator.pushNamed(context, Rotas.listaBikes)),
        _CadastroTile('Tipos de Manutenção', Icons.handyman, () => Navigator.pushNamed(context, Rotas.listaTiposManutencao)),
        _CadastroTile('Manutenção de Bikes', Icons.build, () => Navigator.pushNamed(context, Rotas.cadastroManutencao)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final VoidCallback? onTap;

  const _InfoCard({required this.titulo, required this.valor, required this.icone, this.onTap});

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
              Icon(icone, size: 40, color: Colors.blue),
              const SizedBox(height: 16),
              Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

