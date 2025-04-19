import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveFileScope, drive.DriveApi.driveScope];
  final storage = const FlutterSecureStorage();
  final Uuid _uuid = const Uuid();

  Future<drive.DriveApi?> getDriveApi() async {
    final accessToken = await storage.read(key: 'googleAccessToken');
    if (accessToken == null) return null;

    final authHeaders = {'Authorization': 'Bearer $accessToken'};
    final authenticatedClient = GoogleAuthClient(authHeaders);
    return drive.DriveApi(authenticatedClient);
  }

  Future<String?> uploadFile(File file, {String? folderId, String? customName}) async {
    try {
      final driveApi = await getDriveApi();
      if (driveApi == null) throw Exception('Not authenticated');

      final fileStream = http.ByteStream(file.openRead());
      final length = await file.length();

      final media = drive.Media(fileStream, length);
      final driveFile = drive.File();
      driveFile.name = customName ?? path.basename(file.path);
      driveFile.mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      if (folderId != null) {
        driveFile.parents = [folderId];
      }

      final response = await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );

      return response.id;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<File?> downloadFile(String fileId, String fileName) async {
    try {
      final driveApi = await getDriveApi();
      if (driveApi == null) throw Exception('Not authenticated');

      final response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      final fileStream = file.openWrite();
      await response.stream.pipe(fileStream);
      await fileStream.close();

      return file;
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  Future<List<drive.File>> listFiles({String? folderId}) async {
    final driveApi = await getDriveApi();
    if (driveApi == null) throw Exception('Not authenticated');

    final query = folderId != null
        ? "'$folderId' in parents"
        : "'root' in parents and trashed = false";

    final response = await driveApi.files.list(
      q: query,
      $fields: 'files(id,name,mimeType,createdTime,modifiedTime,size,parents)',
    );
    return response.files ?? [];
  }

  Future<String?> createFolder(String folderName, {String? parentFolderId}) async {
    try {
      final driveApi = await getDriveApi();
      if (driveApi == null) throw Exception('Not authenticated');

      final folder = drive.File();
      folder.name = folderName;
      folder.mimeType = 'application/vnd.google-apps.folder';

      if (parentFolderId != null) {
        folder.parents = [parentFolderId];
      }

      final response = await driveApi.files.create(folder);
      return response.id;
    } catch (e) {
      debugPrint('Create folder error: $e');
      return null;
    }
  }

  Future<List<drive.File>> searchFiles(String query, {String? folderId}) async {
    final driveApi = await getDriveApi();
    if (driveApi == null) throw Exception('Not authenticated');

    final searchQuery = folderId != null
        ? "name contains '$query' and '$folderId' in parents"
        : "name contains '$query'";

    final response = await driveApi.files.list(
      q: searchQuery,
      $fields: 'files(id,name,mimeType,createdTime,modifiedTime,size,parents)',
    );
    return response.files ?? [];
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}