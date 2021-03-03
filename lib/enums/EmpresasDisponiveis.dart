enum EmpresasDisponiveis { REDESUL, CORREIOS, SEQUOIA }

extension EmpresasDisponiveisDescricao on EmpresasDisponiveis {
  String get descricao {
    switch (this) {
      case EmpresasDisponiveis.REDESUL:
        return "RedeSul Logistica";
      case EmpresasDisponiveis.CORREIOS:
        return "Correios";
      case EmpresasDisponiveis.SEQUOIA:
        return "Sequoia";
    }
  }

  bool get visibilityCodigoRastreio {
    switch (this) {
      case EmpresasDisponiveis.REDESUL:
        return false;
      case EmpresasDisponiveis.CORREIOS:
        return true;
      case EmpresasDisponiveis.SEQUOIA:
        return true;
      default:
        return false;
    }
  }

  bool get visibilityCnpjCpf {
    switch (this) {
      case EmpresasDisponiveis.REDESUL:
        return true;
      case EmpresasDisponiveis.CORREIOS:
        return false;
      case EmpresasDisponiveis.SEQUOIA:
        return false;
      default:
        return false;
    }
  }

  bool get visibilityCodigoPedido {
    switch (this) {
      case EmpresasDisponiveis.REDESUL:
        return true;
      case EmpresasDisponiveis.CORREIOS:
        return false;
      case EmpresasDisponiveis.SEQUOIA:
        return false;
      default:
        return false;
    }
  }
}
