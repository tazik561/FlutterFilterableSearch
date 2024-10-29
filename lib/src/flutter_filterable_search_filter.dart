import 'flutter_filterable_search_option.dart';

class FlutterFilterableSearchFilter<T> {
  FlutterFilterableSearchFilter({
    required this.label,
    required this.customFilters,
  });

  final String label;
  final List<bool Function(T)> customFilters;

  // Automatically generates filter options and selection state
  List<FlutterFilterableSearchOption<T>> _generateFilterOptions() {
    return List.generate(customFilters.length, (index) {
      return FlutterFilterableSearchOption<T>(
        label: 'Custom Filter ${index + 1}',
        filter: customFilters[index], // Use the custom filter
      );
    });
  }

  // Filter items based on selected options
  List<T> filterItems(List<T> items) {
    final selectedOptions = _generateFilterOptions();
    if (selectedOptions.isEmpty) {
      return items; // Return all items if no option is selected
    }
    return items.where((item) {
      // Check if every filter returns true
      return selectedOptions.every((option) => option.filter(item));
    }).toList();
  }
}
