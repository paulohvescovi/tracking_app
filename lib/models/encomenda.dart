import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda_detail.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track_detail.dart';

class Encomenda {

  int _id;
  String _nome;
  String _codigoRastreio;
  String _ultimoStatus;
  Finalizado _finalizado;
  EmpresasDisponiveis _empresa;
  String _ultimaAtualizacao;
  String _cpf;
  String _dataFinalizado;
  String _dataUltimoStatus;
  List<EncomendaDetail> _details = List();

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

  String get dataUltimoStatus => _dataUltimoStatus;

  set dataUltimoStatus(String value) {
    _dataUltimoStatus = value;
  }

  String get dataFinalizado => _dataFinalizado;

  set dataFinalizado(String value) {
    _dataFinalizado = value;
  }

  List<EncomendaDetail> get details => _details;

  set details(List<EncomendaDetail> value) {
    _details = value;
  }

  EmpresasDisponiveis get empresa => _empresa;

  set empresa(EmpresasDisponiveis value) {
    _empresa = value;
  }
}
