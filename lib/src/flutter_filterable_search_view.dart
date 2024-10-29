import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_filterable_search/src/utils/get_position.dart';
import '../flutter_filterable_search.dart';

class FlutterFilterableSearchView<T> extends StatefulWidget {
  const FlutterFilterableSearchView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemSubmitted,
    this.searchController,
    this.labelText,
    this.filters,
    this.isClearButtonVisible = true,
    this.hintText = "Search...",
    this.shadowColor = const Color(0xFF000000),
    this.overlayColor = Colors.black12,
    this.chipPadding = EdgeInsets.zero,
    this.overlayPadding = EdgeInsets.zero,
    this.searchFiledPadding = EdgeInsets.zero,
    this.theme,
    this.chipTheme,
    this.textStyle,
    this.keyboardType,
    this.overlayMaxHeight = 250,
    this.overLayBorderRadius = 0,
    this.minLines,
    this.maxLines,
    this.textInputAction,
    this.inputFormatters = const <TextInputFormatter>[],
    this.isReadOnly = false,
    this.focusNode,
    this.overlayCloseButton,
    this.overlayCloseButtonAlignment,
  });

  final List<T> items;
  final Widget Function(T, int index) itemBuilder;
  final List<FlutterFilterableSearchFilter<T>>? filters;
  final FlutterFilterableSearchTheme? theme;
  final FlutterFilterChipTheme? chipTheme;
  final bool isClearButtonVisible;
  final String hintText;
  final Color shadowColor;
  final Color overlayColor;
  final EdgeInsetsGeometry chipPadding;
  final EdgeInsetsGeometry searchFiledPadding;
  final EdgeInsetsGeometry overlayPadding;
  final double overlayMaxHeight;
  final String? labelText;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool isReadOnly;
  final String Function(T)? itemSubmitted;
  final TextEditingController? searchController;
  final double? overLayBorderRadius;
  final Widget? overlayCloseButton;
  final Alignment? overlayCloseButtonAlignment;

  @override
  State<FlutterFilterableSearchView<T>> createState() =>
      _FlutterFilterableSearchViewState<T>();
}

class _FlutterFilterableSearchViewState<T>
    extends State<FlutterFilterableSearchView<T>>
    with SingleTickerProviderStateMixin {
  Timer? _debounce;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final ValueNotifier<List<T>> _listItemsValueNotifier =
      ValueNotifier<List<T>>([]);
  final ValueNotifier<List<String>> _activeFiltersNotifier = ValueNotifier([]);

  GetPosition? position;
  late final AnimationController _animationController;

  late TextEditingController _searchController;
  late List<T> filteredItems;
  late List<T> keepFilteredItems;

  _toggleOverlay() => _overlayEntry == null ? _addOverlay() : _removeOverlay();

  _addOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {});
    }
  }

  OverlayEntry _createOverlayEntry() {
    var overlay = OverlayEntry(builder: (context) {
      return LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              width: position!.getWidth(),
              top: 0,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, position!.getHeight()),
                child: Container(
                  padding: widget.overlayPadding,
                  decoration: BoxDecoration(
                    color: widget.overlayColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(widget.overLayBorderRadius!)),
                  ),
                  child: SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutBack,
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(maxHeight: widget.overlayMaxHeight),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: widget.overlayCloseButtonAlignment ??
                                Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _activeFiltersNotifier.value.clear();
                                  _toggleOverlay();
                                },
                                icon: widget.overlayCloseButton ??
                                    const Icon(Icons.close)),
                          ),
                          Expanded(
                            child: Material(
                              child: ValueListenableBuilder(
                                  valueListenable: _listItemsValueNotifier,
                                  builder: (context, List<T> items, child) {
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: items.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        debugPrint("${items.length}");
                                        return InkWell(
                                          onTap: () {
                                            if (widget.itemSubmitted != null) {
                                              _searchController.text = widget
                                                  .itemSubmitted!(items[index]);
                                            }
                                            _toggleOverlay();
                                          },
                                          child: widget.itemBuilder(
                                              items[index], index),
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });
    });

    return overlay;
  }

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
    filteredItems = widget.items;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  // Apply selected filters
  void _applyFilters() {
    List<T> option = filteredItems;
    // If no active filters, display all items
    if (_activeFiltersNotifier.value.isEmpty) {
      if (_searchController.text.isEmpty) {
        _listItemsValueNotifier.value = filteredItems;
        if (_activeFiltersNotifier.value.isEmpty) {
          _toggleOverlay();
          return;
        }
      }
    }

    // Check if there are any active filters that match widget.filters
    bool hasActiveFilters = widget.filters?.any((filter) {
          return _activeFiltersNotifier.value.contains(filter.label);
        }) ??
        false;
    if (!hasActiveFilters) {
      // No active filters, reset the list once
      _listItemsValueNotifier.value = keepFilteredItems;
      filteredItems = keepFilteredItems;
      return;
    }
    // Apply active filters
    for (var filter in widget.filters ?? []) {
      if (_activeFiltersNotifier.value.contains(filter.label)) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            if (_activeFiltersNotifier.value.length > 1) {
              option = filter.filterItems(option);
              _listItemsValueNotifier.value = option;
            } else {
              option = filter.filterItems(option);
              _listItemsValueNotifier.value = option;
            }
          },
        );
      }
    }

    if (_overlayEntry == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          _addOverlay();
        },
      );
    }
  }

  _onTextChanged(String? str) {
    // Cancel the previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_searchController.text.isNotEmpty) {
        _listItemsValueNotifier.value = filteredItems.where((item) {
          try {
            if (item is String || item is int || item is double) {
              return item.toString().toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  );
            } else {
              var itemJson = (item as dynamic).toJson() as Map<String, dynamic>;
              return jsonEncode(itemJson).toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  );
            }
          } catch (e) {
            return false;
          }
        }).toList();

        if (_overlayEntry == null) {
          _toggleOverlay();
        }

        filteredItems = _listItemsValueNotifier.value;
        keepFilteredItems = filteredItems;
      } else {
        _toggleOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    position = GetPosition(widgetContext: context);

    List<Widget> filterChips = [];

    // Build filter chips
    for (var filter in widget.filters ?? []) {
      filterChips.add(
        ValueListenableBuilder<List<String>>(
          valueListenable: _activeFiltersNotifier,
          builder: (context, activeFilters, child) {
            return FilterChip(
              label: Text("${filter.label}"),
              selected: activeFilters.contains(filter.label),
              onSelected: (bool isSelected) {
                if (isSelected) {
                  activeFilters.add(filter.label);
                  if (_searchController.text.isEmpty) {
                    filteredItems = widget.items;
                    keepFilteredItems = widget.items;
                  } else {
                    filteredItems = keepFilteredItems;
                  }
                } else {
                  activeFilters.remove(filter.label);
                  if (_searchController.text.isEmpty) {
                    filteredItems = widget.items;
                    keepFilteredItems = filteredItems;
                  } else {
                    filteredItems = keepFilteredItems;
                  }
                }

                _activeFiltersNotifier.value =
                    List.from(activeFilters); // Trigger rebuild
                _applyFilters(); // Apply filters whenever a filter is selected/unselected
              },
              deleteIcon: const Icon(Icons.clear),
              selectedColor: widget.chipTheme?.selectedColor,
              disabledColor: widget.chipTheme?.disabledColor,
              backgroundColor: widget.chipTheme?.backgroundColor,
              checkmarkColor: widget.chipTheme?.showCheckmark == true
                  ? widget.chipTheme?.checkmarkColor
                  : null,
              shape: widget.chipTheme?.shape,
              elevation: widget.chipTheme?.elevation,
              pressElevation: widget.chipTheme?.pressElevation,
              labelPadding: widget.chipTheme?.labelPadding,
              padding: widget.chipTheme?.padding,
              labelStyle: widget.chipTheme?.labelStyle,
            );
          },
        ),
      );
    }

    return CompositedTransformTarget(
      link: this._layerLink,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            _listItemsValueNotifier.value = widget.items;
            return KeyEventResult.ignored;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: widget.searchFiledPadding,
              child: PhysicalModel(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                elevation: 12,
                shadowColor: widget.shadowColor,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    filteredItems = widget.items;
                    _onTextChanged(value);
                  },
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  focusNode: widget.focusNode,
                  textInputAction: widget.textInputAction,
                  style: widget.textStyle,
                  inputFormatters: widget.inputFormatters,
                  readOnly: widget.isReadOnly,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: widget.theme?.hintTextStyle,
                    labelStyle: widget.theme?.labelStyle,
                    labelText: widget.labelText,
                    prefixIcon: widget.theme?.prefixIcon,
                    floatingLabelStyle: widget.theme?.floatingLabelStyle,
                    contentPadding: widget.theme?.contentPadding,
                    enabledBorder: widget.theme?.enabledBorderStyle,
                    focusedBorder: widget.theme?.focusedBorderStyle,
                    errorBorder: widget.theme?.errorBorderStyle,
                    focusedErrorBorder: widget.theme?.errorBorderStyle,
                    filled: widget.theme?.backgroundFilled,
                    fillColor: widget.theme?.backgroundColor,
                    hoverColor: widget.theme?.backgroundColor,
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () {
                          _searchController.clear();
                          filteredItems = widget.items;
                          _activeFiltersNotifier.value.clear();
                          _removeOverlay();
                        },
                      ),
                      icon: widget.theme?.suffixIcon ??
                          const Icon(
                            Icons.clear,
                            color: Colors.black45,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            if (filterChips.isNotEmpty)
              Padding(
                padding: widget.chipPadding,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    runSpacing: 5.0,
                    spacing: 5.0,
                    children: filterChips,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _animationController.dispose();
    _listItemsValueNotifier.dispose();
    _searchController.dispose();
    _activeFiltersNotifier.dispose();
    _overlayEntry = null;
    super.dispose();
  }
}
