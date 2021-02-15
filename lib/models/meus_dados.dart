class MeusDados {

  int _id;
  String _nome;
  String _email;
  String _cpf;
  bool _enviarNotificacoes;
  bool _enviarEmail;

  MeusDados(this._id, this._nome, this._email, this._cpf,
      this._enviarNotificacoes, this._enviarEmail);

  bool get enviarEmail => _enviarEmail;

  set enviarEmail(bool value) {
    _enviarEmail = value;
  }

  bool get enviarNotificacoes => _enviarNotificacoes;

  set enviarNotificacoes(bool value) {
    _enviarNotificacoes = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}