# flutter_filterable_search

`flutter_filterable_search` is a powerful and highly customizable Flutter widget designed to facilitate efficient search operations on large lists of objects. This plugin converts your objects to strings and searches through all properties inside each object, allowing for advanced filtering capabilities. It integrates real-time search functionality that empowers users to quickly and easily find the information they need. Whether you're working with contact lists, product catalogs, or any data-intensive application, `flutter_filterable_search` streamlines the search experience.

With this widget, users can implement real-time search functionality that updates results as they type. Additionally, the widget allows users to apply multiple filtering options using filter chips, enhancing the overall usability and efficiency of your application.

## Features

- **Real-Time Search**: Users can filter and search through large data sets efficiently, receiving immediate feedback with a dropdown overlay that displays real-time results as they type.
- **Object Conversion**: The plugin converts your objects to strings, enabling searches across all properties of the object, thus enhancing the search capability.
- **Custom Filters**: Create and apply multiple custom filters tailored to your specific data structure. Users can combine filters to refine search results based on their preferences.
- **Filter Chips**: Visually intuitive filter chips enable users to manage active filters easily. Users can add or remove filters with a single tap, providing a seamless interaction.
- **Theming and Styling**: Fully customizable theming options for the search interface and filter chips allow developers to match the search experience to their application's design language. You can adjust colors, shapes, and styles to ensure a cohesive look and feel.
- **Responsive Design**: The widget adapts to different screen sizes, ensuring a consistent experience across devices. You can also configure the overlay height for optimal usability on various screen resolutions.
- **Performance Optimizations**: The widget is designed for optimal performance with large datasets, minimizing lag and enhancing user experience even with extensive lists.

## Installation

To use `flutter_filterable_search` in your project, follow these steps:

1. Add the package to your `pubspec.yaml`:

    ```yaml
    dependencies:
      flutter_filterable_search: ^0.0.2
    ```

2. Fetch the package using the following command:

    ```bash
    flutter pub get
    ```

## Example

Below is an example of how to use `flutter_filterable_search` in your application:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_filterable_search/flutter_filterable_search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filterable Search Demo',
      home: SearchScreen(),
    );
  }
}

class User {
  final String name;
  final int age;
  final String location;

  User({required this.name, required this.age, required this.location});
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // List of users to be searched
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

  // Define custom filters
  final nameStartsWithAbFilter = FlutterFilterableSearchFilter<User>(
    label: 'Name starts with Ab, older than 30',
    customFilters: [
      (item) => item.name.startsWith('Ab'),
      (item) => item.age > 30,
    ],
  );

  final ageGreaterThan30Filter = FlutterFilterableSearchFilter<User>(
    label: 'Age > 30',
    customFilters: [(item) => item.age > 30],
  );

  final locationNewYorkFilter = FlutterFilterableSearchFilter<User>(
    label: 'Location: New York',
    customFilters: [(item) => item.location == 'New York'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filterable Search Demo'),
      ),
      body: Column(
        children: [
          FlutterFilterableSearchView<User>(
            overlayColor: Colors.transparent,
            overlayMaxHeight: MediaQuery.of(context).size.height * 0.5,
            theme: FlutterFilterableSearchTheme.byDefault(
              context,
              backgroundColor: Colors.red,
            ),
            chipTheme: FlutterFilterChipTheme.byDefault(
              context,
              backgroundColor: Colors.blue,
            ),
            chipPadding: const EdgeInsets.only(top: 16),
            overlayPadding: const EdgeInsets.only(left: 16, right: 16),
            items: users,
             itemSubmitted: (user) {
                debugPrint(user.location);
                return user.name;
             },
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
            filters: [
              nameStartsWithAbFilter,
              ageGreaterThan30Filter,
              locationNewYorkFilter,
            ],
          ),
        ],
      ),
    );
  }
}
```

## Explanation

The above example demonstrates a list of users with custom filters. Key components include:

- **`FlutterFilterableSearchView<User>`**: This widget enables the search functionality with filtering capabilities.
- **Custom Filters**: Filters are created using `FlutterFilterableSearchFilter`, allowing multiple conditions to be applied for filtering the results.
- **Items**: A list of objects (e.g., `User`) is defined to be searched and filtered.
- **Item Builder**: The method `itemBuilder` specifies how each filtered item is displayed in the search results.
- **item Submitted**: The method `itemSubmitted` specifies how each selected item presented on search box.

# Search view theme
```dart
FlutterFilterableSearchTheme(context,
  searchFieldStyle: TextStyle(color: Colors.blue),
  backgroundColor: Colors.grey[200],
  ...
);
```

# Search view theme
```dart
FlutterFilterChipTheme(context,
selectedColor: Colors.green,
unselectedColor: Colors.red,
...
);

```



## License

`flutter_filterable_search` is released under the MIT License. See the [LICENSE](./LICENSE) file for details.



## Contributions

Contributions to `flutter_filterable_search` are welcome! If you want to contribute, please follow these steps:

1. **Fork the repository**: Click the "Fork" button on the top right of the repository page to create your own copy of the project.

2. **Clone your fork**: Use the following command to clone your fork to your local machine:

   ```bash
   git clone https://github.com/your_username/flutter_filterable_search.git

3. **Create a new branch**: Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature-name

4. **Make changes**: Make your changes in your local repository.
5. **Commit your changes**: After making changes, commit them with a clear message:
   ```bash
   git commit -m "Add your commit message here"
 
6. **Push to your fork**: Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
7. **Create a pull request**: Go to the original repository and create a pull request from your fork.

I appreciate your contributions and will review them as soon as possible!


