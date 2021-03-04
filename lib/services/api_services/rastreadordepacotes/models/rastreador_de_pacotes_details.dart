import 'package:flutter/material.dart';
import 'package:tracking_app/utils/date_utils.dart';

class RastreadorDePacotesDetails {
  String _local;
  String _acao;
  String _data;
  String _detalhes;
  String _detalhesFormatado;
  String _uf;
  String _tipo;
  String _status;
  String _cep;
  String _cepDestino;
  String _statusPosicao;

  DateTime getDataHoraEfetiva() {
    return DateUtil.getDateTime(data, DateUtil.PATTERN_RDP);
  }

  String get local => _local;

  set local(String value) {
    _local = value;
  }

  String get acao => _acao;

  set acao(String value) {
    _acao = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get detalhes => _detalhes;

  set detalhes(String value) {
    _detalhes = value;
  }

  String get detalhesFormatado => _detalhesFormatado;

  set detalhesFormatado(String value) {
    _detalhesFormatado = value;
  }

  String get uf => _uf;

  set uf(String value) {
    _uf = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get cepDestino => _cepDestino;

  set cepDestino(String value) {
    _cepDestino = value;
  }

  String get statusPosicao => _statusPosicao;

  set statusPosicao(String value) {
    _statusPosicao = value;
  }

  RastreadorDePacotesDetails.fromJson(Map<String, dynamic> json)
      : _local = json['Local'],
        _acao = json['Acao'],
        _data = json['Data'],
        _detalhes = json['Detalhes'],
        _detalhesFormatado = json['DetalhesFormatado'],
        _uf = json['UF'],
        _tipo = json['Tipo'],
        _status = json['Status'],
        _cep = json['Cep'],
        _cepDestino = json['CepDestino'],
        _statusPosicao = json['StatusPosicao'];

  Map<String, dynamic> toJson() => {
        'Local': _local,
        'Acao': _acao,
        'Data': _data,
        'Detalhes': _detalhes,
        'DetalhesFormatado': _detalhesFormatado,
        'UF': _uf,
        'Tipo': _tipo,
        'Status': _status,
        'Cep': _cep,
        'CepDestino': _cepDestino,
        'StatusPosicao': _statusPosicao
      };
}
