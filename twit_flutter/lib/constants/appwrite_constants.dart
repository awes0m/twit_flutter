// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

const host = kIsWeb ? 'http://localhost:80/v1' : 'http://10.0.2.2:80/v1';

class AppwriteConstants {
  static String databaseId = dotenv.env['DATADB_ID']!;
  static String projectId = dotenv.env['PROJECT_ID']!;
  static String userCollection = dotenv.env['USERCOLLECTION_ID']!;
  static String tweetsCollection = dotenv.env['TWEETSCOLLECTION_ID']!;
  static String imagesBucket = dotenv.env['IMAGES_BUCKET']!;

  static const String endPoint = host;

  static String imageUrl(String imageId) =>
      '$host/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
