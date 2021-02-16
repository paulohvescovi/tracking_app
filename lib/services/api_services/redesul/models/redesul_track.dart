import 'dart:collection';

import 'package:tracking_app/services/api_services/redesul/models/redesul_track_detail.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track_header.dart';

class RedeSulTrack {
  bool _success;
  String _message;
  RedeSulTrackHeader _header;
  List<RedeSulTrackDetail> _tracking;

  RedeSulTrack(
      this._success,
      this._message,
      this._header,
      this._tracking);

  RedeSulTrack.fromJson(Map<String, dynamic> json):
        _success = json['success'],
        _message = json['message'],
        _header = RedeSulTrackHeader.fromJson(json['header']),
        _tracking = getDetails(json['tracking']);

  static List<RedeSulTrackDetail> getDetails(List<dynamic> values){
    List<RedeSulTrackDetail> retorno = List();
    for (var value in values) {
      var redeSulTrackDetail = RedeSulTrackDetail.fromJson(value);
      retorno.add(redeSulTrackDetail);
    }
    return retorno;
  }

  Map<String, dynamic> toJson() => {
        'success': _success,
        'message': _message,
        'header': _header,
        'tracking': _tracking
      };

  List<RedeSulTrackDetail> get tracking => _tracking;

  set tracking(List<RedeSulTrackDetail> value) {
    _tracking = value;
  }

  RedeSulTrackHeader get header => _header;

  set header(RedeSulTrackHeader value) {
    _header = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  bool get success => _success;

  set success(bool value) {
    _success = value;
  }
}
