// Mock class for http.Client - manually created for testing
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {
  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: Future<http.Response>.value(
          http.Response('{}', 200),
        ),
      ) as Future<http.Response>);

  @override
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: Future<http.Response>.value(
          http.Response('{}', 200),
        ),
      ) as Future<http.Response>);

  @override
  void close() => super.noSuchMethod(
        Invocation.method(#close, []),
        returnValueForMissingStub: null,
      );
}