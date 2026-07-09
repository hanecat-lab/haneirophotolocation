import 'dart:typed_data';

import 'storage_service_stub.dart'
    if (dart.library.io) 'storage_service_io.dart'
    if (dart.library.js_interop) 'storage_service_web.dart';

/// Platform-agnostic file persistence.
///
/// Callers never touch file paths directly; they hold an opaque `fileKey`
/// (stored on [WorkspaceItem.fileKey]) and resolve bytes through this
/// service. This keeps the data model identical on mobile (application
/// documents directory) and web (IndexedDB), where no file system exists.
abstract class StorageService {
  /// Persists bytes (images, PDFs, etc.) and returns a unique fileKey.
  Future<String> saveFile(Uint8List bytes, String fileName);

  /// Retrieves bytes associated with the fileKey.
  Future<Uint8List?> getFile(String fileKey);

  /// Deletes the file associated with the fileKey.
  Future<bool> deleteFile(String fileKey);
}

/// Returns the platform-appropriate implementation
/// (documents directory on mobile/desktop, IndexedDB on web).
StorageService createStorageService() => createPlatformStorageService();
