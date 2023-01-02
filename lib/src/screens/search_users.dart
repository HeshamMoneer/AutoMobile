import 'dart:math';

import 'package:AutoMobile/src/models/user.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:flutter/material.dart';

class SearchUsers extends SearchDelegate {
  int MAX_RESULTS = 6;
  List<User> allUsers;
  List<User> suggestions = [];
  SearchUsers(this.allUsers);

  @override
  String get searchFieldLabel => 'Search for a user to chat with';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.length > 0
        ? [
            IconButton(
                onPressed: () {
                  query = '';
                },
                icon: const Icon(Icons.clear))
          ]
        : [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  Widget userChatCard(User user, BuildContext context) {
    var userImage = Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(user.profilePicPath),
        radius: 40,
        backgroundColor: Colors.transparent,
      ),
    );

    return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/inbox/chat', arguments: user);
        },
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Row(children: [
            userImage,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Tab here to chat with user",
                  textAlign: TextAlign.left,
                ),
              ],
            )
          ]),
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        return userChatCard(suggestions[idx], context);
      },
      itemCount: suggestions.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim() == '')
      suggestions = [];
    else
      suggestions = allUsers.where((user) {
        String name = "${user.firstName} ${user.lastName}";
        return name.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

    Widget seeAll = ListTile(
        title: Text('See all results', style: AppTheme.titleStyle),
        trailing: Icon(Icons.read_more),
        onTap: () {
          buildResults(context);
          showResults(context);
        });

    Widget noResults = ListTile(
        title: Text(
      query.trim() == '' ? '' : 'No results found :(',
    ));

    return ListView.builder(
        itemCount: min(MAX_RESULTS, suggestions.length) + 1,
        itemBuilder: (context, idx) {
          if (idx == 0)
            return suggestions.length == 0 ? noResults : seeAll;
          else {
            User cur = suggestions[idx - 1];
            return userChatCard(cur, context);
          }
        });
  }
}
