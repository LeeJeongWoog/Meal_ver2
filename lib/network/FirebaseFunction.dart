import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'; // 파일 업로드를 위해 필요
import 'dart:convert'; // UTF8 디코딩을 위해 필요
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class FireBaseFunction{
  static Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } catch (e) {
      print("Failed to sign in anonymously: $e");
    }
  }

  static Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  static Future<void> uploadFile(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      // 파일 경로 지정
      String filePath = 'uploads/${DateTime.now().millisecondsSinceEpoch}.png';

      // Firebase Storage에 파일 업로드
      await storage.ref(filePath).putFile(file);
      print('File uploaded successfully.');
    } catch (e) {
      print('Failed to upload file: $e');
    }
  }

  static Future<String> downloadFile() async {
    try {
      // Firebase Storage에서 파일 URL 가져오기
      String downloadURL = await FirebaseStorage.instance
          .ref('db_fallback.json') // 업로드된 파일 경로
          .getDownloadURL();

      print('Download URL: $downloadURL');
      return downloadURL;
      // 다운로드 URL을 사용하여 파일을 읽거나 보여줄 수 있습니다.
      // 예: Image.network(downloadURL);
    } catch (e) {
      print('Error downloading file: $e');
      return 'Error downloading file: $e';
    }
  }

  // Firebase Storage에서 파일 내용을 직접 가져오기 (크로스 플랫폼 지원)
  static Future<String> downloadFileContent() async {
    try {
      // getData()는 모바일에서만 작동하므로, URL을 통해 다운로드하는 방식 사용
      // 하지만 http 패키지 대신 dio나 다른 방법 시도
      final ref = FirebaseStorage.instance.ref('db_fallback.json');

      // 먼저 getData() 시도 (모바일)
      try {
        final data = await ref.getData(10 * 1024 * 1024); // 10MB 제한
        if (data != null) {
          String content = const Utf8Decoder().convert(data);
          print('File downloaded successfully via getData: ${content.length} bytes');
          return content;
        }
      } catch (e) {
        print('getData failed (probably web platform): $e');
        // Web 플랫폼에서는 getData가 작동하지 않으므로 URL 방식으로 대체
      }

      // getData 실패 시 URL 다운로드 방식 사용 (web 플랫폼용)
      String downloadURL = await ref.getDownloadURL();
      print('Fetching from URL: $downloadURL');

      // http 패키지가 문제를 일으키므로, 간단한 fetch 사용
      throw Exception('URL download not implemented - getData failed');

    } catch (e) {
      print('Error downloading file content: $e');
      rethrow;
    }
  }

}