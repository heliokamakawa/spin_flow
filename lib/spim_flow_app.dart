import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/form_aluno.dart';
import 'package:spin_flow/widget/form_grupo_alunos.dart';
import 'package:spin_flow/widget/form_mix.dart';
import 'package:spin_flow/widget/form_artista_banda.dart';
import 'package:spin_flow/widget/form_bike.dart';
import 'package:spin_flow/widget/form_categoria_musica.dart';
import 'package:spin_flow/widget/form_fabricante.dart';
import 'package:spin_flow/widget/form_musica.dart';
import 'package:spin_flow/widget/form_sala.dart';
import 'package:spin_flow/widget/form_tipo_manutencao.dart';
import 'package:spin_flow/widget/form_manutencao.dart';
import 'package:spin_flow/widget/form_turma.dart';
import 'package:spin_flow/widget/form_checkin.dart';
import 'package:spin_flow/widget/form_turma_mix.dart';
import 'package:spin_flow/widget/tela_dashboard_aluno.dart';
import 'package:spin_flow/widget/tela_dashboard_professora.dart';
import 'package:spin_flow/widget/tela_login.dart';
import 'package:spin_flow/widget/listas/lista_fabricantes.dart';
import 'package:spin_flow/widget/listas/lista_categorias_musica.dart';
import 'package:spin_flow/widget/listas/lista_tipos_manutencao.dart';
import 'package:spin_flow/widget/listas/lista_artistas_bandas.dart';
import 'package:spin_flow/widget/listas/lista_alunos.dart';
import 'package:spin_flow/widget/listas/lista_musicas.dart';
import 'package:spin_flow/widget/listas/lista_turmas.dart';
import 'package:spin_flow/widget/listas/lista_bikes.dart';
import 'package:spin_flow/widget/listas/lista_mixes.dart';
import 'package:spin_flow/widget/listas/lista_grupos_alunos.dart';
import 'package:spin_flow/widget/listas/lista_salas.dart';
import 'package:spin_flow/widget/form_video_aula.dart';
import 'package:spin_flow/widget/listas/lista_video_aula.dart';
import 'package:spin_flow/widget/aluno/tela_agenda_aluno.dart';
import 'package:spin_flow/widget/aluno/tela_checkin_aluno.dart';
import 'package:spin_flow/widget/aluno/tela_historico_aluno.dart';
import 'package:spin_flow/widget/aluno/tela_mix_turma_aluno.dart';
import 'package:spin_flow/widget/aluno/tela_mapa_checkin.dart';
import 'package:spin_flow/widget/professora/tela_mapa_operacional_professora.dart';
import 'package:spin_flow/widget/professora/tela_posicionamento_bikes.dart';

class SpinFlowApp extends StatelessWidget {
  const SpinFlowApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pinFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: Rotas.login,
      routes: {
        Rotas.login: (context) => const TelaLogin(),
        Rotas.dashboardAluno: (context) => const TelaDashboardAluno(),
        Rotas.dashboardProfessora: (context) => const TelaDashboardProfessora(),
        Rotas.cadastroCategoriaMusica: (context) => const FormCategoriaMusica(),
        Rotas.cadastroTipoManutencao: (context) => const FormTipoManutencaoTela(),
        Rotas.cadastroFabricante: (context) => const FormFabricante(),
        Rotas.cadastroBike: (context) => const FormBike(),
        Rotas.cadastroArtistaBanda: (context) => const FormArtistaBanda(),
        Rotas.cadastroMusica: (context) => const FormMusica(),
        Rotas.cadastroMix: (context) => const FormMix(),
        Rotas.cadastroSala: (context) => FormSala(),
        Rotas.cadastroTurma: (context) => const FormTurma(),
        Rotas.cadastroAluno: (context) => const FormAluno(),
        Rotas.cadastroGrupoAlunos: (context) => const FormGrupoAlunos(),
        Rotas.cadastroVideoAula: (context) => const FormVideoAula(),
        Rotas.cadastroManutencao: (context) => const FormManutencao(),
        Rotas.manutencao: (context) => const FormManutencao(),
        Rotas.cadastroCheckin: (context) => const FormCheckin(),
        Rotas.cadastroTurmaMix: (context) => const FormTurmaMix(),
        Rotas.agendaAluno: (context) => const TelaAgendaAluno(),
        Rotas.checkinAluno: (context) => const TelaCheckinAluno(),
        Rotas.mapaCheckin: (context) => const TelaMapaCheckin(),
        Rotas.historicoAluno: (context) => const TelaHistoricoAluno(),
        Rotas.mixTurmaAluno: (context) => const TelaMixTurmaAluno(),
        Rotas.mapaOperacionalProfessora: (context) => const TelaMapaOperacionalProfessora(),
        Rotas.posicionamentoBikes: (context) => const TelaPosicionamentoBikes(),
        Rotas.marcacaoBike: (context) => const TelaAgendaAluno(),
        Rotas.evolucaoPessoal: (context) => const TelaHistoricoAluno(),
        Rotas.desafios: (context) => const TelaDashboardAluno(),
        Rotas.aulasParticulares: (context) => const TelaDashboardAluno(),
        Rotas.missoes: (context) => const TelaDashboardAluno(),
        Rotas.destaques: (context) => const TelaDashboardAluno(),
        Rotas.recomendacoes: (context) => const TelaDashboardAluno(),
        Rotas.perfil: (context) => const TelaDashboardAluno(),
        Rotas.home: (context) => const TelaDashboardAluno(),
        
        // Rotas das listas
        Rotas.listaFabricantes: (context) => const ListaFabricantes(),
        Rotas.listaCategoriasMusica: (context) => const ListaCategoriasMusica(),
        Rotas.listaTiposManutencao: (context) => const ListaTiposManutencao(),
        Rotas.listaArtistasBandas: (context) => const ListaArtistasBandas(),
        Rotas.listaAlunos: (context) => const ListaAlunos(),
        Rotas.listaMusicas: (context) => const ListaMusicas(),
        Rotas.listaTurmas: (context) => const ListaTurmas(),
        Rotas.listaBikes: (context) => const ListaBikes(),
        Rotas.listaMixes: (context) => const ListaMixes(),
        Rotas.listaGruposAlunos: (context) => const ListaGruposAlunos(),
        Rotas.listaSalas: (context) => const ListaSalas(),
        Rotas.listaVideoAula: (context) => const ListaVideoAula(),
      },
    );
  }
}

