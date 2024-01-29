import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../models/posts_model.dart';

abstract class PostRemoteDatasource {
  Future<List<PostsModel>> getAllPosts();

  Future<Unit> addPost(PostsModel post);

  Future<Unit> updatePost(PostsModel post);

  Future<Unit> deletePost(int id);
}

const BASE_URL = "https://jsonplaceholder.typicode.com/";

class PostRemoteDatasourceImplWithHttp implements PostRemoteDatasource {
  final http.Client client;

  PostRemoteDatasourceImplWithHttp({required this.client});

  @override
  Future<Unit> addPost(PostsModel post) async {
    final body = {"title": post.title, "body": post.body};
    final response = await client.post(
      Uri.parse("${BASE_URL}posts"),
      body: body,
    );
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int id) async {
    final response = await client.delete(
      Uri.parse("${BASE_URL}posts/${id.toString()}"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PostsModel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse("${BASE_URL}posts"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List decodeJson = json.decode(response.body) as List;
      final postModels = decodeJson.map((e) => PostsModel.fromJson(e)).toList();
      return postModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostsModel post) async {
    final postId = post.id.toString();
    final body = {"title": post.title, "body": post.body};
    final response = await client.patch(
      Uri.parse("${BASE_URL}posts/$postId"),
      body: body,
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
