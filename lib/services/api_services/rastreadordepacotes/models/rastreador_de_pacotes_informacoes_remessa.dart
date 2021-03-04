import 'dart:convert';

class RastreadorDePacotesInformacoesRemessa {
  int _order;
  String _property;
  String _text;
  String _value;

  RastreadorDePacotesInformacoesRemessa(
      this._order, this._property, this._text, this._value);

  RastreadorDePacotesInformacoesRemessa.fromJson(Map<String, dynamic> json)
      : _order = json['Order'],
        _property = json['Property'],
        _text = json['Text'],
        _value = json['Value'];

  Map<String, dynamic> toJson() =>
      {'Order': _order, 'Property': _property, 'Text': _text, 'Value': _value};

  int get order => _order;

  set order(int value) {
    _order = value;
  }

  String get property => _property;

  set property(String value) {
    _property = value;
  }

  String get text => _text;

  set text(String value) {
    _text = value;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }
}
