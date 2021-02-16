enum EmpresasDisponiveis {

  REDESUL,
  CORREIOS

}


extension EmpresasDisponiveisDescricao  on EmpresasDisponiveis {

  String get descricao {
    switch(this) {
      case EmpresasDisponiveis.REDESUL:
        return "RedeSul Logistica";
      case EmpresasDisponiveis.CORREIOS:
        return "Correios";
    }
  }

}