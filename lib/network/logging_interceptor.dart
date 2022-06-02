import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('\n');
    print(
        '--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${'' + (options.baseUrl ?? '') + (options.path ?? '')}');
    print('Headers:');
    options.headers.forEach((k, dynamic v) => print('$k: $v'));
    if (options.queryParameters != null) {
      print('queryParameters:');
      options.queryParameters.forEach((k, dynamic v) => print('$k: $v'));
    }
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    print(
        '--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}');

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) {
    print('\n');
    print(
        '<-- ${dioError.message} ${dioError.response != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL'}');
    print(
        '${dioError.response != null ? dioError.response!.data : 'Unknown Error'}');
    print('<-- End error');
    super.onError(dioError, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   super.onResponse(response, handler);
  // }
  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    print('\n\n');
    print(
        '<--- HTTP CODE : ${response.statusCode} URL : ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    print('Headers: ');
    printWrapped('Response : ${response.data}');
    print('<--- END HTTP');
    return super.onResponse(response, handler);
  }

  void printWrapped(String text) {
    final RegExp pattern = RegExp('.{1,800}');
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }
}
