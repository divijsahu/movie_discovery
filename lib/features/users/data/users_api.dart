import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/network/dio_client.dart';
import 'package:movie_discovery/features/users/data/models/user_model.dart';

class UsersApi {
  final Dio _dio;
  UsersApi(this._dio);

  Future<UsersResponse> fetchUsers(int page) async {
    final response = await _dio.get(
      ApiConstants.users,
      queryParameters: {'page': page},
    );
    return UsersResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> createUser(String name, String job) async {
    final response = await _dio.post(
      ApiConstants.users,
      data: {'name': name, 'job': job},
    );
    return response.data as Map<String, dynamic>;
  }
}

final usersApiProvider = Provider<UsersApi>(
  (ref) => UsersApi(ref.watch(reqresDioProvider)),
);
