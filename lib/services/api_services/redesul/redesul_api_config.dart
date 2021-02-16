import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client clientRedeSul = HttpClientWithInterceptor.build(
  interceptors: [],
);

const String baseUrl = 'https://ssw.inf.br/api';
const String urlTracking = 'https://ssw.inf.br/api/trackingdest';