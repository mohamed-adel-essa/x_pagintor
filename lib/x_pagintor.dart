library flutter_paginator;

import 'dart:async';

import 'package:flutter/material.dart' hide ErrorWidgetBuilder;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'enums.dart';
import 'type_definitions.dart';

/// Paginator has 3 constructors
/// [Paginator.listView], [Paginator.gridView], [Paginator.pageView]
/// [Paginator.listView], [Paginator.gridView] and [Paginator.pageView] are
/// descendants of [ListView], [GridView] and [PageView].
/// [Paginator.listView], [Paginator.gridView] and [Paginator.pageView] got
/// all the features of their ancestors and they are need to provide additional
/// properties that are essential in doing their task.
///
/// [PageLoadFuture]
///  * Loads the page asynchronously when the page number is given.
///  * This should return an instance of a [Future].
///  * Called when the next page is needed to be loaded.
///
/// [PageItemsGetter]
///  * This function should return list of page item data when page data is given.
///  * This is called after successful completion of [pageLoadFuture].
///  * The page items returned by this method is added to the list of all the
///     page items.
///
/// [ListItemBuilder]
///  * Builds list item when item data and item index are given.
///  * This should return an instance of a [Widget].
///
/// [LoadingWidgetBuilder]
///  * Builds loading widget.
///  * This should return an instance of a [Widget].
///
/// [ErrorWidgetBuilder]
///  * Builds error widget when page data and error callback are given.
///  * This should return an instance of a [Widget].
///
/// [EmptyListWidgetBuilder]
///  * Builds empty list widget.
///  * This is displayed when the total number of list items is zero.
///  * This should return an instance of a [Widget].
///
/// [TotalItemsGetter]
///  * This should return total number of list items when page data is given.
///
/// [PageErrorChecker]
///  * This should return true if page has error else false, when page data is given.

class XPaginator<T> extends StatefulWidget {
  final PageLoadFuture<T> pageLoadFuture;
  final PageItemsGetter<T?> pageItemsGetter;
  final ListItemBuilder listItemBuilder;
  final LoadingWidgetBuilder loadingWidgetBuilder;
  final ErrorWidgetBuilder<T?> errorWidgetBuilder;
  final EmptyListWidgetBuilder emptyListWidgetBuilder;
  final TotalItemsGetter<T> totalItemsGetter;
  final PageErrorChecker<T?> pageErrorChecker;

  /// common properties
  final Key? scrollViewKey;
  final ScrollPhysics? scrollPhysics;
  final Axis scrollDirection;
  final bool reverse;

  /// properties - list view, grid view
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollController? scrollController;
  final bool? primary;
  final int? semanticChildCount;
  final double? cacheExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// properties - list view only
  final double? itemExtent;

  /// properties - grid view only
  final SliverGridDelegate? gridDelegate;

  /// properties - page view only
  final ValueChanged<int>? onPageChanged;
  final bool pageSnapping;
  final PageController? pageController;

  final ListType listType;

  const XPaginator.listView({
    Key? key,
    required this.pageLoadFuture,
    required this.pageItemsGetter,
    required this.listItemBuilder,
    required this.loadingWidgetBuilder,
    required this.errorWidgetBuilder,
    required this.emptyListWidgetBuilder,
    required this.totalItemsGetter,
    required this.pageErrorChecker,
    this.scrollViewKey,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollPhysics,
    this.padding,
    this.shrinkWrap = false,
    this.scrollController,
    this.primary,
    this.semanticChildCount,
    this.cacheExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
  })  : listType = ListType.listView,
        onPageChanged = null,
        pageSnapping = true,
        pageController = null,
        gridDelegate = null,
        super(key: key);

  const XPaginator.gridView({
    Key? key,
    required this.pageLoadFuture,
    required this.pageItemsGetter,
    required this.listItemBuilder,
    required this.loadingWidgetBuilder,
    required this.errorWidgetBuilder,
    required this.emptyListWidgetBuilder,
    required this.totalItemsGetter,
    required this.pageErrorChecker,
    required this.gridDelegate,
    this.scrollViewKey,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollPhysics,
    this.padding,
    this.shrinkWrap = false,
    this.scrollController,
    this.primary,
    this.semanticChildCount,
    this.cacheExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
  })  : listType = ListType.gridView,
        itemExtent = null,
        onPageChanged = null,
        pageSnapping = true,
        pageController = null,
        super(key: key);

  const XPaginator.pageView({
    Key? key,
    required this.pageLoadFuture,
    required this.pageItemsGetter,
    required this.listItemBuilder,
    required this.loadingWidgetBuilder,
    required this.errorWidgetBuilder,
    required this.emptyListWidgetBuilder,
    required this.totalItemsGetter,
    required this.pageErrorChecker,
    this.scrollViewKey,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.scrollPhysics,
    this.onPageChanged,
    this.pageSnapping = true,
    this.pageController,
  })  : listType = ListType.pageview,
        padding = null,
        shrinkWrap = false,
        scrollController = null,
        primary = null,
        semanticChildCount = null,
        cacheExtent = null,
        addAutomaticKeepAlives = true,
        addRepaintBoundaries = true,
        addSemanticIndexes = true,
        itemExtent = null,
        gridDelegate = null,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return XPaginatorState<T>(
      pageLoadFuture,
      pageItemsGetter,
      listItemBuilder,
      loadingWidgetBuilder,
      errorWidgetBuilder,
      emptyListWidgetBuilder,
      totalItemsGetter,
      pageErrorChecker,
      gridDelegate,
      scrollViewKey,
      scrollDirection,
      reverse,
      scrollPhysics,
      padding,
      shrinkWrap,
      scrollController,
      primary,
      semanticChildCount,
      cacheExtent,
      addAutomaticKeepAlives,
      addRepaintBoundaries,
      addSemanticIndexes,
      itemExtent,
      onPageChanged,
      pageSnapping,
      pageController,
      listType,
    );
  }
}

class XPaginatorState<T> extends State<XPaginator> {
  /// essential
  PageLoadFuture<T> _pageLoadFuture;
  PageItemsGetter<T?> _pageItemsGetter;
  ListItemBuilder _listItemBuilder;
  LoadingWidgetBuilder _loadingWidgetBuilder;
  ErrorWidgetBuilder<T?> _errorWidgetBuilder;
  EmptyListWidgetBuilder<T?> _emptyListWidgetBuilder;
  TotalItemsGetter<T> _totalItemsGetter;
  PageErrorChecker<T?> _pageErrorChecker;

  /// common properties
  Key? _scrollViewKey;
  ScrollPhysics? _scrollPhysics;
  Axis _scrollDirection;
  bool _reverse;

  /// properties - list view, grid view
  EdgeInsets? _padding;
  bool _shrinkWrap;
  ScrollController? _scrollController;
  bool? _primary;
  int? _semanticChildCount;
  double? _cacheExtent;
  bool _addAutomaticKeepAlives;
  bool _addRepaintBoundaries;
  bool _addSemanticIndexes;

  /// properties - list view only
  double? _itemExtent;

  /// properties - grid view only
  SliverGridDelegate? _gridDelegate;

  /// properties - page view only
  ValueChanged<int>? _onPageChanged;
  bool _pageSnapping;
  PageController? _pageController;

  /// runtime variables
  _ListStatus? _listStatus;
  ListType _listType;
  late List _listItems;
  int? _currentPage;
  int? _nTotalItems;
  T? _firstPageData;

  XPaginatorState(
    this._pageLoadFuture,
    this._pageItemsGetter,
    this._listItemBuilder,
    this._loadingWidgetBuilder,
    this._errorWidgetBuilder,
    this._emptyListWidgetBuilder,
    this._totalItemsGetter,
    this._pageErrorChecker,
    this._gridDelegate,
    this._scrollViewKey,
    this._scrollDirection,
    this._reverse,
    this._scrollPhysics,
    this._padding,
    this._shrinkWrap,
    this._scrollController,
    this._primary,
    this._semanticChildCount,
    this._cacheExtent,
    this._addAutomaticKeepAlives,
    this._addRepaintBoundaries,
    this._addSemanticIndexes,
    this._itemExtent,
    this._onPageChanged,
    this._pageSnapping,
    this._pageController,
    this._listType,
  );

  @override
  void initState() {
    _initialize();
    _initialFutureCall();
    super.initState();
  }

  void _initialize() {
    _listStatus = _ListStatus.loading;
    _listItems = [];
    _currentPage = 0;
    _nTotalItems = 0;
  }

  @override
  Widget build(BuildContext context) {
    switch (_listStatus) {
      case _ListStatus.success:
        return _buildPaginatorWidget();

      case _ListStatus.loading:
        return Center(child: _loadingWidgetBuilder());

      case _ListStatus.error:
        return Center(child: _errorWidgetBuilder(_firstPageData, _onError));

      case _ListStatus.empty:
      default:
        return _emptyListWidgetBuilder(_firstPageData);
    }
  }

  Widget _buildPaginatorWidget() {
    switch (_listType) {
      case ListType.listView:
        return AnimationLimiter(
          child: ListView.builder(
            key: _scrollViewKey,
            padding: _padding,
            physics: _scrollPhysics,
            scrollDirection: _scrollDirection,
            shrinkWrap: _shrinkWrap,
            itemCount: _getItemCount(),
            itemBuilder: _listVewItemBuilder,
            controller: _scrollController,
            reverse: _reverse,
            primary: _primary,
            semanticChildCount: _semanticChildCount,
            cacheExtent: _cacheExtent,
            itemExtent: _itemExtent,
            addAutomaticKeepAlives: _addAutomaticKeepAlives,
            addRepaintBoundaries: _addRepaintBoundaries,
            addSemanticIndexes: _addSemanticIndexes,
          ),
        );
      case ListType.gridView:
        return AnimationLimiter(
          child: GridView.builder(
            key: _scrollViewKey,
            gridDelegate: _gridDelegate!,
            padding: _padding,
            physics: _scrollPhysics,
            scrollDirection: _scrollDirection,
            shrinkWrap: _shrinkWrap,
            itemCount: _getItemCount(),
            itemBuilder: _gridVewItemBuilder,
            controller: _scrollController,
            reverse: _reverse,
            primary: _primary,
            semanticChildCount: _semanticChildCount,
            cacheExtent: _cacheExtent,
            addAutomaticKeepAlives: _addAutomaticKeepAlives,
            addRepaintBoundaries: _addRepaintBoundaries,
            addSemanticIndexes: _addSemanticIndexes,
          ),
        );
      case ListType.pageview:
      default:
        return PageView.builder(
          key: _scrollViewKey,
          physics: _scrollPhysics,
          scrollDirection: _scrollDirection,
          itemCount: _getItemCount(),
          itemBuilder: _listVewItemBuilder,
          controller: _pageController,
          reverse: _reverse,
          onPageChanged: _onPageChanged,
          pageSnapping: _pageSnapping,
        );
    }
  }

  Widget _listVewItemBuilder(BuildContext context, int index) {
    if (index < _listItems.length) {
      return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(seconds: 2),
          child: ScaleAnimation(
              child: FadeInAnimation(
                  child: _listItemBuilder(_listItems[index], index))));
    } else {
      return FutureBuilder(
        future: _pageLoadFuture(_currentPage! + 1),
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (_pageErrorChecker(snapshot.data)) {
                return _errorWidgetBuilder(snapshot.data, _onError);
              }
              _listItems.addAll(_pageItemsGetter(snapshot.data));
              _currentPage = _currentPage! + 1;
              Future.microtask(() {
                setState(() {});
              });
              return _loadingWidgetBuilder();
            default:
              return _loadingWidgetBuilder();
          }
        },
      );
    }
  }

  Widget _gridVewItemBuilder(BuildContext context, int index) {
    if (index < _listItems.length) {
      return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(seconds: 2),
          columnCount: 2,
          child: ScaleAnimation(
              child: FadeInAnimation(
                  child: _listItemBuilder(_listItems[index], index))));
    } else {
      return FutureBuilder(
        future: _pageLoadFuture(_currentPage! + 1),
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (_pageErrorChecker(snapshot.data)) {
                return _errorWidgetBuilder(snapshot.data, _onError);
              }
              _listItems.addAll(_pageItemsGetter(snapshot.data));
              _currentPage = _currentPage! + 1;
              Future.microtask(() {
                setState(() {});
              });
              return _loadingWidgetBuilder();
            default:
              return _loadingWidgetBuilder();
          }
        },
      );
    }
  }

  int? _getItemCount() {
    if (_nTotalItems! > _listItems.length) {
      return _listItems.length + 1;
    }
    return _nTotalItems;
  }

  void _onError() {
    if (_listItems.isEmpty) {
      setState(
        () {
          _listStatus = _ListStatus.loading;
        },
      );
      _initialFutureCall();
    } else {
      setState(() {});
    }
  }

  void changeState({
    PageLoadFuture<T>? pageLoadFuture,
    PageItemsGetter<T?>? pageItemsGetter,
    ListItemBuilder? listItemBuilder,
    LoadingWidgetBuilder? loadingWidgetBuilder,
    ErrorWidgetBuilder<T?>? errorWidgetBuilder,
    EmptyListWidgetBuilder<T?>? emptyListWidgetMaker,
    TotalItemsGetter<T>? totalItemsGetter,
    PageErrorChecker<T?>? pageErrorChecker,
    Key? scrollViewKey,
    ScrollPhysics? scrollPhysics,
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsets? padding,
    bool? shrinkWrap,
    ScrollController? scrollController,
    bool? primary,
    int? semanticChildCount,
    double? cacheExtent,
    bool? addAutomaticKeepAlives,
    bool? addRepaintBoundaries,
    bool? addSemanticIndexes,
    double? itemExtent,
    SliverGridDelegate? gridDelegate,
    ValueChanged<int>? onPageChanged,
    bool? pageSnapping,
    PageController? pageController,
    ListType? listType,
    bool resetState = false,
  }) {
    _pageLoadFuture = pageLoadFuture ?? _pageLoadFuture;
    _pageItemsGetter = pageItemsGetter ?? _pageItemsGetter;
    _listItemBuilder = listItemBuilder ?? _listItemBuilder;
    _loadingWidgetBuilder = loadingWidgetBuilder ?? _loadingWidgetBuilder;
    _errorWidgetBuilder = errorWidgetBuilder ?? _errorWidgetBuilder;
    _emptyListWidgetBuilder = emptyListWidgetMaker ?? _emptyListWidgetBuilder;
    _totalItemsGetter = totalItemsGetter ?? _totalItemsGetter;
    _pageErrorChecker = pageErrorChecker ?? _pageErrorChecker;
    _scrollViewKey = scrollViewKey ?? _scrollViewKey;
    _scrollPhysics = scrollPhysics ?? _scrollPhysics;
    _scrollDirection = scrollDirection ?? _scrollDirection;
    _reverse = reverse ?? _reverse;
    _padding = padding ?? _padding;
    _shrinkWrap = shrinkWrap ?? _shrinkWrap;
    _scrollController = scrollController ?? _scrollController;
    _primary = primary ?? _primary;
    _semanticChildCount = semanticChildCount ?? _semanticChildCount;
    _cacheExtent = cacheExtent ?? _cacheExtent;
    _addAutomaticKeepAlives = addAutomaticKeepAlives ?? _addAutomaticKeepAlives;
    _addRepaintBoundaries = addRepaintBoundaries ?? _addRepaintBoundaries;
    _addSemanticIndexes = addSemanticIndexes ?? _addSemanticIndexes;
    _itemExtent = itemExtent ?? _itemExtent;
    _gridDelegate = gridDelegate ?? _gridDelegate;
    _onPageChanged = onPageChanged ?? _onPageChanged;
    _pageSnapping = pageSnapping ?? _pageSnapping;
    _pageController = pageController ?? _pageController;
    _listType = listType ?? _listType;

    if (resetState) {
      _initialize();
      setState(() {});
      _initialFutureCall();
    }
    setState(() {});
  }

  void _initialFutureCall() {
    Future<T> future = _pageLoadFuture(1);
    future.then((T pageData) {
      _firstPageData = pageData;
      _nTotalItems = _totalItemsGetter(pageData);
      if (_pageErrorChecker(pageData)) {
        setState(() {
          _listStatus = _ListStatus.error;
        });
      } else if (_nTotalItems == 0) {
        setState(() {
          _listStatus = _ListStatus.empty;
        });
      } else {
        _currentPage = _currentPage! + 1;
        _listItems.addAll(_pageItemsGetter(pageData));
        setState(() {
          _listStatus = _ListStatus.success;
        });
      }
    });
  }
}

enum _ListStatus { loading, error, success, empty }
