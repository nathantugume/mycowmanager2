import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/image_repository.dart';
import '../../models/image_model/image_model.dart';

class FileManagerViewModel extends ChangeNotifier {
  final _repo   = ImageRepository();
  final _picker = ImagePicker();

  bool   _isLoading = false;
  String? _error;
  String? _status;
  Uint8List? _previewBytes;

  /*──────── getters for UI ────────*/
  bool   get isLoading    => _isLoading;
  String?   get error     => _error;
  String?   get status    => _status;
  Uint8List? get preview  => _previewBytes;     // for Image.memory()

  /*──────── PUBLIC API ────────────*/

  /// Opens gallery → compresses → uploads → returns docId
  Future<String?> pickAndUpload() async {
    try {
      _setLoading(true);

      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        _setLoading(false);
        return null; // user cancelled
      }

      _previewBytes = await file.readAsBytes();       // show preview
      notifyListeners();

      final encoded = await _encodeAndCompress(_previewBytes!);

      final docId = 'IMG_${DateTime.now().millisecondsSinceEpoch}';
      final model = ImageModel(id: docId, base64Data: encoded);

      await _repo.add(model);

      _status = 'Upload successful';
      dev.log('✅ Uploaded $docId', name: 'FileManagerVM');
      return docId;
    } catch (e, st) {
      _setError(e, st);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Fetches & decodes image bytes from Firestore
  Future<Uint8List?> fetch(String id) async {
    try {
      _setLoading(true);
      final img = await _repo.getById(id);
      if (img == null) throw Exception('Image not found');

      final bytes = _decompressAndDecode(img.base64Data);
      _previewBytes = bytes;
      if (kDebugMode) {
        print(bytes);
      }
      notifyListeners();
      return bytes;
    } catch (e, st) {
      _setError(e, st);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes the Firestore doc; call after confirm dialog
  Future<void> delete(String id) async {
    try {
      _setLoading(true);
      await _repo.delete(id);
      _status = 'Deleted';
      dev.log('🗑️ Deleted $id', name: 'FileManagerVM');
    } catch (e, st) {
      _setError(e, st);
    } finally {
      _setLoading(false);
    }
  }

  /// Clears status & error
  void clearMessages() {
    _status = null;
    _error  = null;
    notifyListeners();
  }

  /*──────── PRIVATE HELPERS ───────*/

  Future<String> _encodeAndCompress(Uint8List bytes) async {
    // 1. Resize/compress with Flutter image package if you need; here we jpeg‑encode at 60 %
    //    (image package omitted for brevity).
    // 2. Compress with zlib
    final deflated = zlib.encode(bytes);
    return base64Encode(deflated);
  }

  Uint8List _decompressAndDecode(String base64Str) {
    final deflated = base64Decode(base64Str);
    return Uint8List.fromList(zlib.decode(deflated));
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(Object e, StackTrace st) {
    _error = e.toString();
    dev.log('❌ $e', name: 'FileManagerVM', error: e, stackTrace: st, level: 1000);
    notifyListeners();
  }
}
