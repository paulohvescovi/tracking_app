import 'package:tracking_app/enums/Finalizado.dart';

class Encomenda {

  int _id;
  String _nome;
  String _codigoRastreio;
  String _ultimoStatus;
  Finalizado _finalizado;
  String _ultimaAtualizacao;
  String _cpf;

  Encomenda.codigoRastreio(String codigo){
    _codigoRastreio = codigo;
  }

  Encomenda(this._id, this._nome, this._codigoRastreio, this._ultimoStatus,
      this._finalizado, this._ultimaAtualizacao, this._cpf);

  Finalizado get finalizado => _finalizado;

  set finalizado(Finalizado value) {
    _finalizado = value;
  }

  String get ultimoStatus => _ultimoStatus;

  set ultimoStatus(String value) {
    _ultimoStatus = value;
  }

  String get codigoRastreio => _codigoRastreio;

  set codigoRastreio(String value) {
    _codigoRastreio = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get ultimaAtualizacao => _ultimaAtualizacao;

  set ultimaAtualizacao(String value) {
    _ultimaAtualizacao = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }
}
