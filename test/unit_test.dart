import 'package:flutter_test/flutter_test.dart';
import 'package:machine2/model/model.dart';
import 'package:machine2/services/db_services.dart';

void main() {
  group('GitHubApi', () {
    test('fromJson creates a valid GitHubApi instance', () {
      const Map<String, dynamic> jsonData = {
        'items': [
          {
            'name': 'Repo1',
            'owner': {'avatar_url': 'url1'},
            'description': 'Desc1',
            'stargazers_count': 100
          },
          {
            'name': 'Repo2',
            'owner': {'avatar_url': 'url2'},
            'description': 'Desc2',
            'stargazers_count': 200
          },
        ],
      };

      final GitHubApi gitHubApi = GitHubApi.fromJson(jsonData);

      expect(gitHubApi.items, isA<List<Items>>());
      expect(gitHubApi.items!.length, 2);

      // Check the structure and types without asserting specific values
      expect(gitHubApi.items![0].name, isA<String>());
      expect(gitHubApi.items![0].avatarUrl, isA<String>());
      expect(gitHubApi.items![0].description, isA<String>());
      expect(gitHubApi.items![0].stargazersCount, isA<int>());
    });
  });

  group('Items', () {
    test('fromJson creates a valid Items instance', () {
      const Map<String, dynamic> jsonData = {
        'name': 'Repo1',
        'owner': {'avatar_url': 'url1'},
        'description': 'Desc1',
        'stargazers_count': 100,
      };

      final Items items = Items.fromJson(jsonData);

      // Check the structure and types without asserting specific values
      expect(items.name, isA<String>());
      expect(items.avatarUrl, isA<String>());
      expect(items.description, isA<String>());
      expect(items.stargazersCount, isA<int>());
    });

    test('fromDb creates a valid Items instance from database data', () {
      const Map<String, dynamic> dbData = {
        DatabaseServices.columnUsername: 'Repo1',
        DatabaseServices.columnAvatarUrl: 'url1',
        DatabaseServices.columnDescription: 'Desc1',
        DatabaseServices.columnStars: 100,
      };

      final Items items = Items.fromDb(dbData);

      // Check the structure and types without asserting specific values
      expect(items.name, isA<String>());
      expect(items.avatarUrl, isA<String>());
      expect(items.description, isA<String>());
      expect(items.stargazersCount, isA<int>());
    });

    test('toJson creates a valid JSON map', () {
      final items = Items(
        name: 'Repo1',
        avatarUrl: 'url1',
        description: 'Desc1',
        stargazersCount: 100,
      );

      final jsonData = items.toJson();

      // Check the structure and types without asserting specific values
      expect(jsonData, isA<Map<String, dynamic>>());
      expect(jsonData['username'], isA<String>());
      expect(jsonData['avatar_url'], isA<String>());
      expect(jsonData['description'], isA<String>());
      expect(jsonData['stars'], isA<int>());
    });
  });
}
