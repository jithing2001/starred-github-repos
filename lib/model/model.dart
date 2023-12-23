import '../services/db_services.dart';

class GitHubApi {
  List<Items>? items;

  GitHubApi({this.items});

  GitHubApi.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? name;
  String? description;
  int? stargazersCount;
  String? avatarUrl;

  Items({this.name, this.avatarUrl, this.description, this.stargazersCount});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatarUrl = json['owner']?['avatar_url'];
    description = json['description'];
    stargazersCount = json['stargazers_count'];
  }

   
  Items.fromDb(Map<String, dynamic> json) {
    name = json[DatabaseServices.columnUsername];
    avatarUrl = json[DatabaseServices.columnAvatarUrl];
    description = json[DatabaseServices.columnDescription];
    stargazersCount = json[DatabaseServices.columnStars];
  }


  //to store the data to db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[DatabaseServices.columnDescription] = description ?? 'No description available';
    data[DatabaseServices.columnStars] = stargazersCount;
    data[DatabaseServices.columnUsername] = name;
    data[DatabaseServices.columnAvatarUrl] = avatarUrl;
    return data;
  }
}
