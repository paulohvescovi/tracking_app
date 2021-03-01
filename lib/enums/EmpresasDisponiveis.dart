enum EmpresasDisponiveis {

  REDESUL,
  CORREIOS,
  SEQUOIA

}


extension EmpresasDisponiveisDescricao  on EmpresasDisponiveis {

  String get descricao {
    switch(this) {
      case EmpresasDisponiveis.REDESUL:
        return "RedeSul Logistica";
      case EmpresasDisponiveis.CORREIOS:
        return "Correios";
      case EmpresasDisponiveis.SEQUOIA:
        return "Sequoia";
    }
  }

}