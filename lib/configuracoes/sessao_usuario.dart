class SessaoUsuario {
  static int? usuarioId;
  static String? nome;
  static String? email;
  static String? perfil;

  static bool get ehProfessora => (perfil ?? '').toLowerCase() == 'professora';
  static bool get ehAluno => (perfil ?? '').toLowerCase() == 'aluno';

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
  }

  static void encerrar() {
    usuarioId = null;
    nome = null;
    email = null;
    perfil = null;
  }
}

