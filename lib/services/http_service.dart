import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Response {
  Map<String, dynamic>? data = {};
  bool success;
  String? error;

  Response({this.data, this.error, required this.success});

  factory Response.fromData({required Map<String, dynamic> data}) {
    return Response(success: true, data: data, error: null);
  }

  factory Response.fromError({required String error}) {
    return Response(success: false, data: null, error: error);
  }
}

class HttpService {
  static const storage = FlutterSecureStorage();

  static const baseUrl = 'https://gaping-instrument-production.up.railway.app/api';
  static const commonHeaders = {'content-type': 'application/json'};

  static Future<Map<String, String>> getAuthHeaders() async {
    var authToken = await storage.read(key: 'auth-token');
    return {'x-auth-token': authToken ?? ""};
  }

  static Future<Response> get(
    String url, {
    Map<String, String> headers = const {},
    bool withAuth = false,
  }) async {
    try {
      var authHeaders = withAuth ? await getAuthHeaders() : {};
      var response = await http.get(Uri.parse('$baseUrl$url'), headers: {...commonHeaders, ...authHeaders, ...headers});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response.fromData(data: jsonDecode(response.body));
      } else {
        return Response.fromError(error: response.body);
      }
    } catch (error) {
      return Response.fromError(error: error.toString());
    }
  }

  static Future<Response> post(
    String url, {
    required Map<String, dynamic> data,
    Map<String, String> headers = const {},
    bool withAuth = false,
  }) async {
    try {
      var authHeaders = withAuth ? await getAuthHeaders() : {};
      var response = await http.post(Uri.parse('$baseUrl$url'), headers: {...commonHeaders, ...authHeaders, ...headers}, body: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response.fromData(data: jsonDecode(response.body));
      } else {
        return Response.fromError(error: response.body);
      }
    } catch (error) {
      return Response.fromError(error: error.toString());
    }
  }

  static Future<Response> delete(
    String url, {
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    bool withAuth = false,
  }) async {
    try {
      var authHeaders = withAuth ? await getAuthHeaders() : {};
      var response = await http.delete(
        Uri.parse('$baseUrl$url'),
        headers: {...commonHeaders, ...authHeaders, ...headers},
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response.fromData(data: jsonDecode(response.body));
      } else {
        return Response.fromError(error: response.body);
      }
    } catch (error) {
      return Response.fromError(error: error.toString());
    }
  }

  static Future<Response> put(
    String url, {
    required Map<String, dynamic> data,
    Map<String, String> headers = const {},
    bool withAuth = false,
  }) async {
    try {
      var authHeaders = withAuth ? await getAuthHeaders() : {};
      var response = await http.put(Uri.parse('$baseUrl$url'), headers: {...commonHeaders, ...authHeaders, ...headers}, body: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response.fromData(data: jsonDecode(response.body));
      } else {
        return Response.fromError(error: response.body);
      }
    } catch (error) {
      return Response.fromError(error: error.toString());
    }
  }

  static Future<Response> postMultipart(
    String url, {
    Map<String, String> headers = const {},
    bool withAuth = false,
    Map<String, String> data = const {},
    Map<String, File> files = const {},
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // setting headers
      if (withAuth) {
        request.headers.addAll(await getAuthHeaders());
      }
      request.headers.addAll(headers);

      // preparing multipart data
      for (var entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }

      // adding data
      request.fields.addAll(data);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response.fromData(data: jsonDecode(response.body));
      } else {
        return Response.fromError(error: response.body);
      }
    } catch (error) {
      return Response.fromError(error: error.toString());
    }
  }
}
