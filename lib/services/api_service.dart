import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  // Latihan 5: timeout default 10 detik, dapat diubah per pemanggilan
  static const Duration _defaultTimeout = Duration(seconds: 10);

  // Mengubah Duration menjadi teks untuk pesan error
  String _describeDuration(Duration d) => d.inSeconds >= 1
      ? '${d.inSeconds} detik'
      : '${d.inMilliseconds} milidetik';

  // GET /users
  Future<List<User>> getUsers({Duration timeout = _defaultTimeout}) async {
    try {
      print('Request GET: $_baseUrl/users');

      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);

      // Logging aman: hanya status code
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception(
        'Request timeout setelah ${_describeDuration(timeout)}. '
        'Periksa koneksi internet Anda.',
      );
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // GET /users/{id}
  Future<User> getUserById(int id) async {
    try {
      print('Request GET: $_baseUrl/users/$id');

      final response = await http
          .get(Uri.parse('$_baseUrl/users/$id'))
          .timeout(_defaultTimeout);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Latihan 3: GET /posts
  Future<List<Post>> getPosts() async {
    try {
      print('Request GET: $_baseUrl/posts');

      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(_defaultTimeout);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Simulasi login untuk mendapatkan token
  Future<String> login(String email, String password) async {
    try {
      // Simulasi request login
      await Future.delayed(const Duration(seconds: 1));

      if (email.isNotEmpty && password.isNotEmpty) {
        // Token dummy (dalam aplikasi nyata, ini dari server)
        final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';

        // Logging aman: tidak mencetak token maupun email
        print('Login berhasil');
        return token;
      } else {
        throw Exception('Email dan password tidak boleh kosong');
      }
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}
