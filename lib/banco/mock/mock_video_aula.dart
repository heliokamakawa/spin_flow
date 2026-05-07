import 'package:spin_flow/dto/dto_video_aula.dart';

final List<DTOVideoAula> mockVideoAulas = [
  DTOVideoAula(
    id: 1,
    nome: 'Aula de Introdução ao Spinning',
    linkVideo: 'https://youtu.be/intro-spinning',
    ativo: true,
  ),
  DTOVideoAula(
    id: 2,
    nome: 'Aula Avançada de Resistência',
    linkVideo: 'https://youtu.be/avancada-resistencia',
    ativo: true,
  ),
  DTOVideoAula(
    id: 3,
    nome: 'Aula de Recuperação',
    linkVideo: 'https://youtu.be/recuperacao',
    ativo: false,
  ),
]; 
