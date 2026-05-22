class SessaoUsuario {
  static int? usuarioId;
  static String? nome;
  static String? email;
  static String? perfil;
  static DateTime? _ultimaAtividade;

  /// Tempo de inatividade máximo em minutos.
  static const int _timeoutMinutos = 30;

  static bool get ehProfessora => (perfil ?? '').toLowerCase() == 'professora';
  static bool get ehAluno => (perfil ?? '').toLowerCase() == 'aluno';
  static bool get ativa => usuarioId != null;

  /// Verifica se a sessão expirou por inatividade.
  static bool get expirada {
    if (_ultimaAtividade == null || usuarioId == null) return false;
    return DateTime.now().difference(_ultimaAtividade!).inMinutes >= _timeoutMinutos;
  }

  /// Registra atividade do usuário (chame ao navegar ou interagir).
  static void registrarAtividade() {
    if (usuarioId != null) {
      _ultimaAtividade = DateTime.now();
    }
  }

  static void iniciar({
    required int id,
    required String nomeUsuario,
    required String emailUsuario,
    required String perfilUsuario,
  }) {
    usuarioId = id;
    nome = nomeUsuario;
    email = emailUsuario;
    perfil = perfilUsuario;
    _ultimaAtividade = DateTime.now();
  }

  static void encerrar() {
    usuarioId = null;
    nome = null;
    email = null;
    perfil = null;
    _ultimaAtividade = null;
  }
}

