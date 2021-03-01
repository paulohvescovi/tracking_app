
import 'package:flutter/material.dart';

class SequoiaTrack {

  int _pedidoID;
  String _destinatario;
  String _situacao;
  String _documento;
  String _nomeCliente;
  int _linha;
  int _totalCount;

  SequoiaTrack(
    this._pedidoID, 
    this._destinatario, 
    this._situacao, 
    this._documento, 
    this._nomeCliente, 
    this._linha, 
    this._totalCount
  );

  SequoiaTrack.fromJson(Map<String, dynamic> json) :
        _pedidoID = int.tryParse(json['pedidoID']),
        _destinatario = json['destinatario'],
        _situacao = json['situacao'],
        _documento = json['documento'],
        _nomeCliente = json['nomeCliente'],
        _linha = int.tryParse(json['linha']),
        _totalCount = int.tryParse(json['totalCount']);

  Map<String, dynamic> toJson() => {
    'pedidoID': _pedidoID,
    'destinatario': _destinatario,
    'situacao': _situacao,
    'documento': _documento,
    'nomeCliente': _nomeCliente,
    'linha': _linha,
    'totalCount': _totalCount
  };

  

}