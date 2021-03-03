import 'package:flutter/material.dart';

class SequoiaTrack {
  int _pedidoID;
  String _data;
  String _situacao;
  String _documento;
  String _nomeCliente;
  int _linha;
  int _totalCount;

  SequoiaTrack(this._pedidoID, this._data, this._situacao, this._documento,
      this._nomeCliente, this._linha, this._totalCount);

  SequoiaTrack.fromJson(Map<String, dynamic> json)
      : _pedidoID = json['pedidoID'],
        _data = json['data'],
        _situacao = json['situacao'],
        _documento = json['documento'],
        _nomeCliente = json['nomeCliente'],
        _linha = json['linha'],
        _totalCount = json['totalCount'];

  Map<String, dynamic> toJson() => {
        'pedidoID': _pedidoID,
        'data': _data,
        'situacao': _situacao,
        'documento': _documento,
        'nomeCliente': _nomeCliente,
        'linha': _linha,
        'totalCount': _totalCount
      };

  int get pedidoID => _pedidoID;

  set pedidoID(int value) {
    _pedidoID = value;
  }

  int get linha => _linha;

  set linha(int value) {
    _linha = value;
  }

  int get totalCount => _totalCount;

  set totalCount(int value) {
    _totalCount = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get situacao => _situacao;

  set situacao(String value) {
    _situacao = value;
  }

  String get documento => _documento;

  set documento(String value) {
    _documento = value;
  }

  String get nomeCliente => _nomeCliente;

  set nomeCliente(String value) {
    _nomeCliente = value;
  }
}
