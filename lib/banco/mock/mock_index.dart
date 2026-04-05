// Arquivo de índice para exportar todos os dados mock
// Facilita o import de todos os mocks em um único lugar

// DTOs base (sem dependências)
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

// DTOs existentes (não criados como mock)
// DTOVideoAula e DTOSalaPosicionamento não foram incluídos
// pois não foram identificados formulários específicos para eles 
