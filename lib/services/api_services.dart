import 'dart:developer';
import 'db_services.dart';
import '../model/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GithubService {
  fetchRepositories({required int page, required int days}) async {
    String baseUri = 'https://api.github.com/search/repositories?q=';
    String querycreatedAfter = 'created:>';
    String createdDate = daysBeforToday(days: days);
    String querySort = '&sort=';
    String querySortByStars = 'stars';
    String queryOrder = '&order=';
    String queryOrderDesc = 'desc';
    String queryPage = '&page=';
    String queryPageNo = page.toString();
    String uri = baseUri +
        querycreatedAfter +
        createdDate +
        querySort +
        querySortByStars +
        queryOrder +
        queryOrderDesc +
        queryPage +
        queryPageNo;
    log('uri $uri');

    // Retrieve data from GitHub API
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {

      List<Items> repositories = GitHubApi.fromJson(jsonDecode(response.body)).items!;

      await DatabaseServices.instance.insert(repositories);
    } else {
      throw Exception('Failed to load data from GitHub API');
    }
  }
}

String daysBeforToday({required int days}) {
  DateTime today = DateTime.now();
  DateTime thirtyDaysBefore = today.subtract(Duration(days: days));

  return '${thirtyDaysBefore.year}-${thirtyDaysBefore.month}-${thirtyDaysBefore.day}';
}
