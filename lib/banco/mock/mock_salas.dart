import 'package:spin_flow/dto/dto_sala.dart';

DTOSala _sala({
  required int id,
  required String nome,
  required int numeroFilas,
  required int numeroColunas,
  bool ativa = true,
}) {
  return DTOSala(
    id: id,
    nome: nome,
    numeroFilas: numeroFilas,
    numeroColunas: numeroColunas,
    posicaoProfessora: numeroColunas ~/ 2,
    ativa: ativa,
  );
}

List<DTOSala> mockSalas = [
  _sala(id: 1, nome: 'Sala Spinning Principal', numeroFilas: 4, numeroColunas: 5),
  _sala(id: 2, nome: 'Sala Spinning Compacta', numeroFilas: 3, numeroColunas: 4),
  _sala(id: 3, nome: 'Sala Spinning Premium', numeroFilas: 5, numeroColunas: 5),
  _sala(id: 4, nome: 'Sala Spinning Express', numeroFilas: 2, numeroColunas: 4),
  _sala(id: 5, nome: 'Sala Spinning Elite', numeroFilas: 6, numeroColunas: 5),
  _sala(id: 6, nome: 'Sala Spinning Studio', numeroFilas: 3, numeroColunas: 5),
  _sala(id: 7, nome: 'Sala Spinning Power', numeroFilas: 4, numeroColunas: 5),
  _sala(id: 8, nome: 'Sala Spinning Energy', numeroFilas: 5, numeroColunas: 5),
  _sala(id: 9, nome: 'Sala Spinning Core', numeroFilas: 2, numeroColunas: 5),
  _sala(id: 10, nome: 'Sala Spinning Max', numeroFilas: 7, numeroColunas: 5),
  _sala(id: 11, nome: 'Sala Spinning Pro', numeroFilas: 4, numeroColunas: 4),
  _sala(id: 12, nome: 'Sala Spinning Fit', numeroFilas: 3, numeroColunas: 5),
  _sala(id: 13, nome: 'Sala Spinning Turbo', numeroFilas: 5, numeroColunas: 5),
  _sala(id: 14, nome: 'Sala Spinning Rush', numeroFilas: 3, numeroColunas: 4),
  _sala(id: 15, nome: 'Sala Spinning Force', numeroFilas: 4, numeroColunas: 5),
  _sala(id: 16, nome: 'Sala Spinning Pulse', numeroFilas: 4, numeroColunas: 5),
  _sala(id: 17, nome: 'Sala Spinning Drive', numeroFilas: 6, numeroColunas: 5),
  _sala(id: 18, nome: 'Sala Spinning Boost', numeroFilas: 3, numeroColunas: 5),
  _sala(id: 19, nome: 'Sala Spinning Charge', numeroFilas: 5, numeroColunas: 5),
  _sala(id: 20, nome: 'Sala Spinning Peak', numeroFilas: 6, numeroColunas: 5),
];

