import 'dart:typed_data';

import 'package:idb_shim/idb_browser.dart';
import 'package:uuid/uuid.dart';

import 'storage_service.dart';

StorageService createPlatformStorageService() => WebStorageService();

/// Web implementation backed by IndexedDB (via idb_shim).
///
/// Bytes are stored as-is in an object store keyed by fileKey, which keeps
/// the exact same `fileKey` contract as the mobile implementation without
/// requiring a file system.
class WebStorageService implements StorageService {
  static const _dbName = 'ai_workspace_files';
  static const _storeName = 'files';
  final _uuid = const Uuid();

  Database? _db;

  Future<Database> _database() async {
    final existing = _db;
    if (existing != null) return existing;
    final db = await idbFactoryBrowser.open(
      _dbName,
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;
        if (!db.objectStoreNames.contains(_storeName)) {
          db.createObjectStore(_storeName);
        }
      },
    );
    _db = db;
    return db;
  }

  @override
  Future<String> saveFile(Uint8List bytes, String fileName) async {
    final db = await _database();
    final key = '${_uuid.v4()}_$fileName';
    final txn = db.transaction(_storeName, idbModeReadWrite);
    await txn.objectStore(_storeName).put(bytes, key);
    await txn.completed;
    return key;
  }

  @override
  Future<Uint8List?> getFile(String fileKey) async {
    final db = await _database();
    final txn = db.transaction(_storeName, idbModeReadOnly);
    final value = await txn.objectStore(_storeName).getObject(fileKey);
    await txn.completed;
    if (value == null) return null;
    if (value is Uint8List) return value;
    if (value is List<int>) return Uint8List.fromList(value);
    return null;
  }

  @override
  Future<bool> deleteFile(String fileKey) async {
    final db = await _database();
    final txn = db.transaction(_storeName, idbModeReadWrite);
    final store = txn.objectStore(_storeName);
    final existing = await store.getObject(fileKey);
    if (existing == null) {
      await txn.completed;
      return false;
    }
    await store.delete(fileKey);
    await txn.completed;
    return true;
  }
}
