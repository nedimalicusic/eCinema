import 'dart:convert';
import '../helpers/constants.dart';
import '../models/photo.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class PhotoProvider extends BaseProvider<Photo> {
  PhotoProvider() : super('Photos/GetPaged');

  Future<List<String>> uploadImages(List<http.MultipartFile> images) async {
    var uri = Uri.parse('$apiUrl/Photos/Add');

    try {
      var request = http.MultipartRequest('POST', uri)..files.addAll(images);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        List<dynamic> imageIds = jsonDecode(responseBody);
        return imageIds.map((id) => id.toString()).toList();
      } else {
        throw Exception('Failed to upload images');
      }
    } catch (e) {
      throw Exception('Error during image upload: $e');
    }
  }

  Future<String> getPhoto(String guidId) async {
    var uri = Uri.parse('$apiUrl/Photo/GetById');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {
      'id': guidId,
      'original': 'true',
    };
    uri = uri.replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return '$apiUrl/Photo/GetById?id=$guidId&original=true';
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Photo fromJson(data) {
    return Photo.fromJson(data);
  }
}
