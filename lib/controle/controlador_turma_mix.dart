import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_mix.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dao/dao_turma_mix.dart';
import 'package:spin_flow/modelo/dto/dto_mix.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';
import 'package:spin_flow/modelo/dto/dto_turma_mix.dart';

/// Controlador da feature TurmaMix.
///
/// Faz a mediacao entre a camada de visao (`form_turma_mix`) e a camada de
/// modelo. Encapsula o `DAOTurmaMix` e tambem os DAOs auxiliares (`DAOTurma`,
/// `DAOMix`) usados para carregar as opcoes de dropdown do formulario.
class ControladorTurmaMix extends ControladorBase {
  final DAOTurmaMix _dao = DAOTurmaMix();
  final DAOTurma _daoTurma = DAOTurma();
  final DAOMix _daoMix = DAOMix();

  /// Busca um vinculo turma-mix pelo seu identificador.
  Future<DTOTurmaMix?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) um vinculo turma-mix.
  Future<int> salvar(DTOTurmaMix turmaMix) {
    return _dao.salvar(turmaMix);
  }

  /// Exclui (logicamente) um vinculo turma-mix pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Lista as turmas para preencher o dropdown do formulario.
  Future<List<DTOTurma>> listarTurmas() {
    return _daoTurma.buscarTodos();
  }

  /// Lista os mixes para preencher o dropdown do formulario.
  Future<List<DTOMix>> listarMixes() {
    return _daoMix.buscarTodos();
  }
}
