import 'package:spin_flow/configuracoes/erro.dart';

class ValidadorUrl {
  static String? validarUrl(String? valor) {
    if (valor == null || valor.isEmpty) return null; // campo opcional

    // RegExp simples para URL bÃ¡sica (http, https)
    final regexUrl = RegExp(
      r'^(https?:\/\/)?' // http:// ou https:// (opcional)
      r'([\w\-]+\.)+[\w\-]+' // domÃ­nio (ex: www.exemplo.com)
      r'(\:[0-9]+)?' // porta (opcional)
      r"(\/[\w\-._~:/?#[\]@!$&'()*+,;=]*)?$", // caminho e query (opcional)
      caseSensitive: false,
    );

    if (!regexUrl.hasMatch(valor)) {
      return Erro.urlInvalido;
    }
    return null;
  }
}

