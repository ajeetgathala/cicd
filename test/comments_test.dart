import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    mockHTTPClient = MockHTTPClient();
  });

  group('Comments list screen Tests', () {
    test('Get comments list', () async {
      var request = {
        "ePassId": 0,
      };
      var expectedResponse = [
        {
          "id": 0,
          "comment": "Test comment",
          "creator": "test teacher",
          "creationDate": "00/00/0000 00:00"
        }
      ];

      when(() => mockHTTPClient.getCommentsList(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getCommentsList(request);
      expect(response.statusCode, 200);
    });

    test('post comment test', () async {
      var request = {"ePassId": 0, "comment": "string"};
      var expectedResponse = {"id": 0};

      when(() => mockHTTPClient.postComment(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postComment(request);
      expect(response.statusCode, 200);
    });

    test('post comment without text test', () async {
      CommentsModel commentsModel = CommentsModel();
      expect(commentsModel.commentError.value, false);
      commentsModel.commentController.value.text = '';
      await commentsModel.postComment(0);
      expect(commentsModel.commentError.value, true);
    });
  });
}
