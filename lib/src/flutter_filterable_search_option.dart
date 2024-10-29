class FlutterFilterableSearchOption<T> {
  FlutterFilterableSearchOption({
    required this.label,
    required this.filter,
  });

  final String label;
  final bool Function(T) filter;
}
