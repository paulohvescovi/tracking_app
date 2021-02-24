
import 'package:tracking_app/utils/date_utils.dart';

class EncomendaDetail {

  String _data_hora;
  String _cidade;
  String _ocorrencia;
  String _descricao;
  String _tipo;

  EncomendaDetail();

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

  String get data_hora => _data_hora;

  set data_hora(String value) {
    _data_hora = value;
  }

  DateTime getDataHoraDatetime(){
    return DateUtil.getDateTime(data_hora, DateUtil.PATTERN_DATETIME);
  }
}