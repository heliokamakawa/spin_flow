import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'mock_artistas_bandas.dart';
import 'mock_categorias_musica.dart';

List<DTOMusica> mockMusicas = [
  DTOMusica(
    id: 1,
    nome: 'Eye of the Tiger',
    artista: mockArtistasBandas[0], // Survivor
    categorias: [mockCategoriasMusica[0], mockCategoriasMusica[15]], // CadÃªncia, MotivaÃ§Ã£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Tutorial Eye of the Tiger - Treino de CadÃªncia',
        linkVideo: 'https://youtube.com/watch?v=btPJPFnesV4',
      ),
    ],
    descricao: 'MÃºsica icÃ´nica para treinos de cadÃªncia e motivaÃ§Ã£o',
    ativo: true,
  ),
  DTOMusica(
    id: 2,
    nome: 'We Will Rock You',
    artista: mockArtistasBandas[1], // Queen
    categorias: [mockCategoriasMusica[5], mockCategoriasMusica[11]], // Ritmo, ExplosÃ£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'We Will Rock You - Treino de ExplosÃ£o',
        linkVideo: 'https://youtube.com/watch?v=-tJYN-eG1zk',
      ),
    ],
    descricao: 'ClÃ¡ssico do Queen para treinos explosivos',
    ativo: true,
  ),
  DTOMusica(
    id: 3,
    nome: 'Thunderstruck',
    artista: mockArtistasBandas[2], // AC/DC
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[11]], // ForÃ§a, ExplosÃ£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Thunderstruck - Treino de ForÃ§a',
        linkVideo: 'https://youtube.com/watch?v=v2AC41dglnM',
      ),
    ],
    descricao: 'Riff poderoso para treinos de forÃ§a',
    ativo: true,
  ),
  DTOMusica(
    id: 4,
    nome: 'Lose Yourself',
    artista: mockArtistasBandas[3], // Eminem
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[16]], // MotivaÃ§Ã£o, RecuperaÃ§Ã£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Lose Yourself - Treino Motivacional',
        linkVideo: 'https://youtube.com/watch?v=_Yhyp-_hX2s',
      ),
    ],
    descricao: 'MÃºsica motivacional para superar limites',
    ativo: true,
  ),
  DTOMusica(
    id: 5,
    nome: 'Believer',
    artista: mockArtistasBandas[4], // Imagine Dragons
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[19]], // ForÃ§a, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Believer - Treino de ForÃ§a e Energia',
        linkVideo: 'https://youtube.com/watch?v=7wtfhZwyrcc',
      ),
    ],
    descricao: 'MÃºsica energÃ©tica para treinos intensos',
    ativo: true,
  ),
  DTOMusica(
    id: 6,
    nome: 'Stronger',
    artista: mockArtistasBandas[5], // Kanye West
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[15]], // ForÃ§a, MotivaÃ§Ã£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Stronger - Treino de ForÃ§a',
        linkVideo: 'https://youtube.com/watch?v=PsO6ZnUZI0g',
      ),
    ],
    descricao: 'MÃºsica para treinos de forÃ§a e superaÃ§Ã£o',
    ativo: true,
  ),
  DTOMusica(
    id: 7,
    nome: 'Can\'t Hold Us',
    artista: mockArtistasBandas[8], // Macklemore
    categorias: [mockCategoriasMusica[0], mockCategoriasMusica[19]], // CadÃªncia, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Can\'t Hold Us - Treino de CadÃªncia',
        linkVideo: 'https://youtube.com/watch?v=2zNSgSzhBfM',
      ),
    ],
    descricao: 'MÃºsica energÃ©tica para manter o ritmo',
    ativo: true,
  ),
  DTOMusica(
    id: 8,
    nome: 'Remember the Name',
    artista: mockArtistasBandas[3], // Eminem (Fort Minor)
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[11]], // MotivaÃ§Ã£o, ExplosÃ£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Remember the Name - Treino Explosivo',
        linkVideo: 'https://youtube.com/watch?v=VDvr08sCPOc',
      ),
    ],
    descricao: 'MÃºsica para treinos explosivos e motivacionais',
    ativo: true,
  ),
  DTOMusica(
    id: 9,
    nome: 'Till I Collapse',
    artista: mockArtistasBandas[3], // Eminem
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[13]], // ForÃ§a, Endurance
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Till I Collapse - Treino de ResistÃªncia',
        linkVideo: 'https://youtube.com/watch?v=8CdcCD5V-d8',
      ),
    ],
    descricao: 'MÃºsica para treinos de resistÃªncia e forÃ§a',
    ativo: true,
  ),
  DTOMusica(
    id: 10,
    nome: 'Born to Run',
    artista: mockArtistasBandas[1], // Bruce Springsteen
    categorias: [mockCategoriasMusica[13], mockCategoriasMusica[17]], // Endurance, Velocidade
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Born to Run - Treino de Endurance',
        linkVideo: 'https://youtube.com/watch?v=IxuThNgl3YA',
      ),
    ],
    descricao: 'MÃºsica para treinos de resistÃªncia',
    ativo: true,
  ),
  DTOMusica(
    id: 11,
    nome: 'Jump',
    artista: mockArtistasBandas[1], // Van Halen
    categorias: [mockCategoriasMusica[11], mockCategoriasMusica[19]], // ExplosÃ£o, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Jump - Treino Explosivo',
        linkVideo: 'https://youtube.com/watch?v=SwYN7mTi6HM',
      ),
    ],
    descricao: 'MÃºsica energÃ©tica para treinos explosivos',
    ativo: true,
  ),
  DTOMusica(
    id: 12,
    nome: 'Radioactive',
    artista: mockArtistasBandas[4], // Imagine Dragons
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[19]], // ForÃ§a, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Radioactive - Treino de ForÃ§a',
        linkVideo: 'https://youtube.com/watch?v=ktvTqknDobU',
      ),
    ],
    descricao: 'MÃºsica para treinos de forÃ§a e energia',
    ativo: true,
  ),
  DTOMusica(
    id: 13,
    nome: 'Can\'t Stop',
    artista: mockArtistasBandas[13], // Red Hot Chili Peppers
    categorias: [mockCategoriasMusica[0], mockCategoriasMusica[5]], // CadÃªncia, Ritmo
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Can\'t Stop - Treino de CadÃªncia',
        linkVideo: 'https://youtube.com/watch?v=8DyziWtkfBw',
      ),
    ],
    descricao: 'MÃºsica para manter o ritmo constante',
    ativo: true,
  ),
  DTOMusica(
    id: 14,
    nome: 'The Greatest',
    artista: mockArtistasBandas[9], // Sia
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // MotivaÃ§Ã£o, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'The Greatest - Treino Motivacional',
        linkVideo: 'https://youtube.com/watch?v=GLvohMXgcBo',
      ),
    ],
    descricao: 'MÃºsica motivacional para superar desafios',
    ativo: true,
  ),
  DTOMusica(
    id: 15,
    nome: 'Born This Way',
    artista: mockArtistasBandas[14], // Lady Gaga
    categorias: [mockCategoriasMusica[7], mockCategoriasMusica[15]], // AnimaÃ§Ã£o, MotivaÃ§Ã£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Born This Way - Treino Animado',
        linkVideo: 'https://youtube.com/watch?v=wV1FrqwZyKw',
      ),
    ],
    descricao: 'MÃºsica animada e motivacional',
    ativo: true,
  ),
  DTOMusica(
    id: 16,
    nome: 'Fight Song',
    artista: mockArtistasBandas[9], // Rachel Platten
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // MotivaÃ§Ã£o, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Fight Song - Treino Motivacional',
        linkVideo: 'https://youtube.com/watch?v=xo1VInw-SKc',
      ),
    ],
    descricao: 'MÃºsica para lutar e superar obstÃ¡culos',
    ativo: true,
  ),
  DTOMusica(
    id: 17,
    nome: 'High Hopes',
    artista: mockArtistasBandas[18], // Panic! At The Disco
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // MotivaÃ§Ã£o, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'High Hopes - Treino Motivacional',
        linkVideo: 'https://youtube.com/watch?v=IPXIgEAGe4U',
      ),
    ],
    descricao: 'MÃºsica motivacional com alta energia',
    ativo: true,
  ),
  DTOMusica(
    id: 18,
    nome: 'Invincible',
    artista: mockArtistasBandas[19], // Two Steps From Hell
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[15]], // ForÃ§a, MotivaÃ§Ã£o
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Invincible - Treino de ForÃ§a',
        linkVideo: 'https://youtube.com/watch?v=2Z4m4lnvxkY',
      ),
    ],
    descricao: 'MÃºsica Ã©pica para treinos de forÃ§a',
    ativo: true,
  ),
  DTOMusica(
    id: 19,
    nome: 'Centuries',
    artista: mockArtistasBandas[6], // Fall Out Boy
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // MotivaÃ§Ã£o, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Centuries - Treino Motivacional',
        linkVideo: 'https://youtube.com/watch?v=LBr7kECsjcQ',
      ),
    ],
    descricao: 'MÃºsica motivacional para deixar legado',
    ativo: true,
  ),
  DTOMusica(
    id: 20,
    nome: 'Hall of Fame',
    artista: mockArtistasBandas[7], // The Script
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // MotivaÃ§Ã£o, Energia
    linksVideoAula: [
      DTOVideoAula(
        nome: 'Hall of Fame - Treino Motivacional',
        linkVideo: 'https://youtube.com/watch?v=mk48xRzuNvA',
      ),
    ],
    descricao: 'MÃºsica para entrar no hall da fama',
    ativo: true,
  ),
]; 
