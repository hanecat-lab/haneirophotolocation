import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'storage_service.dart';

StorageService createPlatformStorageService() => IoStorageService();

/// Mobile/desktop implementation backed by the application documents
/// directory. The fileKey is a relative path under `media/`, never an
/// absolute path, so the database stays valid across app reinstalls and
/// container moves (iOS rotates the absolute documents path).
class IoStorageService implements StorageService {
  static const _mediaDir = 'media';
  final _uuid = const Uuid();

  Future<Directory> _baseDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_mediaDir');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _sanitize(String fileName) =>
      fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

  @override
  Future<String> saveFile(Uint8List bytes, String fileName) async {
    final dir = await _baseDir();
    final key = '${_uuid.v4()}_${_sanitize(fileName)}';
    final file = File('${dir.path}/$key');
    await file.writeAsBytes(bytes, flush: true);
    return key;
  }

  @override
  Future<Uint8List?> getFile(String fileKey) async {
    final dir = await _baseDir();
    final file = File('${dir.path}/$fileKey');
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  @override
  Future<bool> deleteFile(String fileKey) async {
    final dir = await _baseDir();
    final file = File('${dir.path}/$fileKey');
    if (!await file.exists()) return false;
    await file.delete();
    return true;
  }
}
