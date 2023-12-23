import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int popupvalue = 1;
    final fetchProvider = Provider.of<FetchProvider>(context, listen: false);
    fetchProvider.initializeScrollListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProvider.fetchData();
    });

    return Consumer<FetchProvider>(
      builder: (context, value, child) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('GitHub Repos'),
              actions: [
                PopupMenuButton(
                    initialValue: popupvalue,
                    onSelected: (value) async {
                      if (value == 1) {
                        popupvalue = 1;
                        await fetchProvider.sortByDays(filterDays: 60);
                      }
                      if (value == 2) {
                        popupvalue = 2;
                        await fetchProvider.sortByDays(filterDays: 30);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Sort by last 60 days'),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Text('Sort by last 30 days'),
                        )
                      ];
                    })
              ],
            ),
            body: value.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    controller: value.scrollController,
                    itemCount: value.scrollLoading
                        ? value.paginatedRepoList.length + 1
                        : value.paginatedRepoList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      if (index < value.paginatedRepoList.length) {
                        final repo = value.paginatedRepoList[index];
                        return ListTile(
                          title: Text(repo.name!),
                          subtitle: Text(
                            repo.description ?? 'No description available',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text('${repo.stargazersCount} stars'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(repo.avatarUrl!),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ));
      },
    );
  }
}
