import 'package:tracking_app/utils/date_utils.dart';

class RedeSulTrackDetail {

  String _data_hora;
  String _dominio;
  String _filial;
  String _cidade;
  String _ocorrencia;
  String _descricao;
  String _tipo;
  String _data_hora_efetiva;
  String _nome_recebedor;
  String _nro_doc_recebedor;

  RedeSulTrackDetail(
      this._data_hora,
      this._dominio,
      this._filial,
      this._cidade,
      this._ocorrencia,
      this._descricao,
      this._tipo,
      this._data_hora_efetiva,
      this._nome_recebedor,
      this._nro_doc_recebedor);


  RedeSulTrackDetail.fromJson(Map<String, dynamic> json) :
        _data_hora = json['data_hora'],
        _dominio = json['dominio'],
        _filial = json['filial'],
        _cidade = json['cidade'],
        _ocorrencia = json['ocorrencia'],
        _descricao = json['descricao'],
        _tipo = json['tipo'],
        _data_hora_efetiva = json['data_hora_efetiva'],
        _nome_recebedor = json['nome_recebedor'],
        _nro_doc_recebedor = json['nro_doc_recebedor'];

  Map<String, dynamic> toJson() =>
      {
        'data_hora': _data_hora,
        'dominio': _dominio,
        'filial': _filial,
        'cidade': _cidade,
        'ocorrencia': _ocorrencia,
        'descricao': _descricao,
        'tipo': _tipo,
        'data_hora_efetiva': _data_hora_efetiva,
        'nome_recebedor': _nome_recebedor,
        'nro_doc_recebedor': _nro_doc_recebedor
      };

  DateTime getDataHoraEfetiva(){
    return DateUtil.getDateTime(_data_hora_efetiva, DateUtil.PATTERN_REDESUL);
  }

  String get nro_doc_recebedor => _nro_doc_recebedor;

  set nro_doc_recebedor(String value) {
    _nro_doc_recebedor = value;
  }

  String get nome_recebedor => _nome_recebedor;

  set nome_recebedor(String value) {
    _nome_recebedor = value;
  }

  String get data_hora_efetiva => _data_hora_efetiva;

  set data_hora_efetiva(String value) {
    _data_hora_efetiva = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get ocorrencia => _ocorrencia;

  set ocorrencia(String value) {
    _ocorrencia = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get filial => _filial;

  set filial(String value) {
    _filial = value;
  }

  String get dominio => _dominio;

  set dominio(String value) {
    _dominio = value;
  }

  String get data_hora => _data_hora;

  set data_hora(String value) {
    _data_hora = value;
  }


}