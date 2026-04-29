import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String _uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  Future<Map<String, String>> uploadImage(File imageFile, String folder) async {
    try {
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$_cloudName/image/upload",
      );

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = _uploadPreset;
      request.fields['folder'] = "vibes/$folder";

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return {
          'url': jsonData['secure_url'],
          'publicID': jsonData['public_id'],
        };
      } else {
        throw "Upload failed! Try again.";
      }
    } catch (e) {
      throw "Image upload failed. Try again.";
    }
  }

  Future<void> deleteImage(String publicId) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
      );
      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = _uploadPreset;
      request.fields['public_id'] = publicId;

      await request.send();
    } catch (e) {
      throw "Failed to delete image.";
    }
  }
}
