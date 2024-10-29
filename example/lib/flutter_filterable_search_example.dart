import 'package:flutter/material.dart';
import 'package:flutter_filterable_search/flutter_filterable_search.dart';

import '../models/user.dart';

class FlutterFilterableSearchExample extends StatelessWidget {
  FlutterFilterableSearchExample({super.key});

  // Filter for users whose name starts with a specific prefix
  final nameStartsWithAbFilter = FlutterFilterableSearchFilter<User>(
    label: 'Name starts with Ab,  older than 30',
    customFilters: [
      (items) => items.name.startsWith('Ab'),
      (items) => items.age > 30
    ],
  );

// Filter for users older than 30
  final ageGreaterThan30Filter = FlutterFilterableSearchFilter<User>(
    label: 'Age > 30',
    customFilters: [(items) => items.age > 30],
  );

// Filter for users living in "New York"
  final locationNewYorkFilter = FlutterFilterableSearchFilter<User>(
    label: 'Location: New York',
    customFilters: [(items) => items.location == 'New York'],
  );

  final List<User> users = [
    User(name: 'Abigail', age: 25, location: 'New York'),
    User(name: 'Abraham', age: 40, location: 'Los Angeles'),
    User(name: 'Alice', age: 22, location: 'New York'),
    User(name: 'Bob', age: 34, location: 'Chicago'),
    User(name: 'Charlie', age: 45, location: 'New York'),
    User(name: 'Amanda', age: 28, location: 'San Francisco'),
    User(name: 'Ann', age: 50, location: 'Los Angeles'),
    User(name: 'Albert', age: 60, location: 'New York'),
    User(name: 'Zara', age: 30, location: 'Chicago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlutterFilterableSearchView<User>(
                  overlayColor: Colors.transparent,
                  overlayMaxHeight: MediaQuery.of(context).size.height * .5,
                  theme: FlutterFilterableSearchTheme.byDefault(context,
                      backgroundColor: Colors.black12, backgroundFilled: true),
                  chipTheme: FlutterFilterChipTheme.byDefault(context,
                      backgroundColor: Colors.black26,
                      labelStyle: const TextStyle(color: Colors.black)),
                  chipPadding: const EdgeInsets.only(top: 16),
                  overlayPadding: const EdgeInsets.only(left: 16, right: 16),
                  items: users,
                  itemBuilder: (user, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.5), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                              child: Text(
                                user.name[0]
                                    .toUpperCase(), // Initial of the name
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Age: ${user.age}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Text(
                                    'Location: ${user.location}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemSubmitted: (user) {
                    debugPrint(user.location);
                    return user.name;
                  },
                  filters: [
                    nameStartsWithAbFilter,
                    ageGreaterThan30Filter,
                    locationNewYorkFilter
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
