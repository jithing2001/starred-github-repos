import 'package:flutter/material.dart';
import 'package:machine2/services/api_services.dart';

import '../services/db_services.dart';
import '../model/model.dart';

class FetchProvider extends ChangeNotifier {
  int page = 1;
  List<Items> paginatedRepoList = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  bool scrollLoading = false;
  int days = 60;

  Future<void> fetchData() async {
    // Fetch data from database
    List<Items> repositories = await DatabaseServices.instance.getRepositories(page);

    if (repositories.isEmpty) {
      // Fetch data from API only if the database is empty
      await GithubService().fetchRepositories(page: page, days: days);
      repositories = await DatabaseServices.instance.getRepositories(page);
    }
    paginatedRepoList.addAll(repositories);

    isLoading = false;
    notifyListeners();
  }

  void initializeScrollListener() {
    scrollController.addListener(scrollListener);
  }

  scrollListener() async {
    if (isLoading || scrollLoading) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      scrollLoading = true;
      notifyListeners();
      Future.delayed(const Duration(seconds: 1), () async {
        page++;
        await fetchData();
        scrollLoading = false;
        notifyListeners();
      });
    }
  }

  sortByDays({required filterDays}) async {
    await clearDb();
    paginatedRepoList = [];
    isLoading = true;
    notifyListeners();
    page = 1;
    days = filterDays;
    await fetchData();
  }

  clearDb() async {
    await DatabaseServices.instance.cleardb();
  }
}
