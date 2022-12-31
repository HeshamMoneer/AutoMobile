import 'dart:math';

import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/widgets/listing_card.dart';
import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  int MAX_RESULTS = 6;
  List<Listing> allListings;
  List<Listing> suggestions = [];
  MySearchDelegate(this.allListings);

  @override
  String get searchFieldLabel => 'Search on AutoMobile';

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

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        return ListingCard(suggestions[idx]);
      },
      itemCount: suggestions.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim() == '')
      suggestions = [];
    else
      suggestions = allListings.where((listing) {
        return listing.title.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

    Widget seeAll = ListTile(
        title: Text('See All Results', style: AppTheme.titleStyle),
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
            Listing cur = suggestions[idx - 1];
            return ListTile(
              leading: Image.network(
                cur.imagesOrDefault[0],
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              title: Text(cur.title),
              onTap: () => goToListingDetailsPage(context, cur),
            );
          }
        });
  }
}
