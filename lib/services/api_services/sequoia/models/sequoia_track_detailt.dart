import 'package:tracking_app/utils/date_utils.dart';

class SequoiaTrackDetail {
  int _pedidoID;
  String _data;
  String _situacao;
  String _localidade;

  SequoiaTrackDetail(
      this._pedidoID, this._data, this._situacao, this._localidade);

  SequoiaTrackDetail.fromJson(Map<String, dynamic> json)
      : _pedidoID = json['pedidoID'],
        _data = json['data'],
        _situacao = json['situacao'],
        _localidade = json['localidade'];

  Map<String, dynamic> toJson() => {
        'pedidoID': _pedidoID,
        'data': _data,
        'situacao': _situacao,
        'localidade': _localidade
      };

  int get pedidoID => _pedidoID;

  set pedidoID(int value) {
    _pedidoID = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get situacao => _situacao;

  set situacao(String value) {
    _situacao = value;
  }

  String get localidade => _localidade;

  set localidade(String value) {
    _localidade = value;
  }

  DateTime getDataHoraEfetiva() {
    return DateUtil.getDateTime(_data, DateUtil.PATTERN_REDESUL);
  }
}
