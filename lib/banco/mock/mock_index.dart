// Arquivo de Ã­ndice para exportar todos os dados mock
// Facilita o import de todos os mocks em um Ãºnico lugar

// DTOs base (sem dependÃªncias)
export 'mock_fabricantes.dart';
export 'mock_categorias_musica.dart';
export 'mock_artistas_bandas.dart';
export 'mock_tipos_manutencao.dart';

// DTOs que dependem dos base
export 'mock_musicas.dart';
export 'mock_alunos.dart';
export 'mock_bikes.dart';
export 'mock_salas.dart';

// DTOs que dependem dos anteriores
export 'mock_turmas.dart';
export 'mock_grupos_alunos.dart';
export 'mock_mixes.dart';

// DTOs existentes (nÃ£o criados como mock)
// DTOVideoAula e DTOSalaPosicionamento nÃ£o foram incluÃ­dos
// pois nÃ£o foram identificados formulÃ¡rios especÃ­ficos para eles 
