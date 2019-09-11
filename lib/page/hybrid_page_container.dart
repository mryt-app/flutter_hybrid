import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid/page/hybrid_page.dart';
import 'package:flutter_hybrid/page/hybrid_page_observer.dart';
import 'package:flutter_hybrid/support/logger.dart';

enum HybridPageContainerOperation {
  push, 
  onstage, 
  pop, 
  remove,
}

/// Every hybrid flutter page is wrapped in an overlay entry.
class _HybridPageOverlayEntry extends OverlayEntry {
  bool _removed = false;
  _HybridPageOverlayEntry(HybridPage page)
      : super(
            builder: (BuildContext ctx) => page,
            opaque: true,
            maintainState: true);

  @override
  void remove() {
    assert(!_removed);

    if (_removed) {
      return;
    }

    _removed = true;
    super.remove();
  }
}

/// Maintains hybrid flutter page in an [Overlay].
class HybridPageContainer extends StatefulWidget {
  final Navigator initialNavigator;
  final PrePushRouteCallback prePushRouteCallback;
  final PostPushRouteCallback postPushRouteCallback;
  const HybridPageContainer(
      {Key key, this.initialNavigator, this.prePushRouteCallback, this.postPushRouteCallback})
      : super(key: key);
      
  @override
  State<StatefulWidget> createState() => HybridPageContainerState();

  static HybridPageContainerState tryOf(BuildContext context) {
    final HybridPageContainerState manager =
        context.ancestorStateOfType(const TypeMatcher<HybridPageContainerState>());
    return manager;
  }

  static HybridPageContainerState of(BuildContext context) {
    final HybridPageContainerState manager =
        context.ancestorStateOfType(const TypeMatcher<HybridPageContainerState>());
    assert(manager != null, 'Not in flutter hybrid');
    return manager;
  }
}

class HybridPageContainerState extends State<HybridPageContainer> {
  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();
  final List<HybridPage> _offstagePages = <HybridPage>[];
  final HybridPageObserverProxy _hybridPageObserverProxy =
      HybridPageObserverProxy();

  List<_HybridPageOverlayEntry> _hybridPageEntries;

  HybridPage _onstagePage;

  String _lastShownPageId;

  PrePushRouteCallback get prePushRouteCallback => widget.prePushRouteCallback;
  PostPushRouteCallback get postPushRouteCallback => widget.postPushRouteCallback;

  HybridPageObserverProxy get hybridPageObserverProxy => _hybridPageObserverProxy;

  int get pageCount => _offstagePages.length + (_onstagePage != null ? 1 : 0);

  //Settings for current visible page.
  HybridPageSettings get onstageSettings => _onstagePage.settings;

  //Current visible page.
  HybridPageState get onstagePage => _stateOf(_onstagePage);

  HybridPageState get maybeOnstageNextPage =>
      _offstagePages.isEmpty ? null : _stateOf(_offstagePages.last);

  bool canPop() => _offstagePages.isNotEmpty;

  @override
  void initState() {
    super.initState();

    assert(widget.initialNavigator != null);
    _onstagePage = HybridPage.copy(widget.initialNavigator, HybridPageSettings.defaultSettings());

    _hybridPageObserverProxy.addObserver(HybridPageCanPopObserver());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void updateFocus() {
    final HybridPageState now = _stateOf(_onstagePage);
    if (now != null) {
      FocusScope.of(context).setFirstFocus(now.focusScopeNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      key: _overlayKey,
      initialEntries: const <OverlayEntry>[],
    );
  }

  HybridPageState _stateOf(HybridPage container) {
    if (container.key != null &&
        container.key is GlobalKey<HybridPageState>) {
      final GlobalKey<HybridPageState> globalKey =
          container.key as GlobalKey<HybridPageState>;
      return globalKey.currentState;
    }

    assert(
        false, 'key of HybridPage must be GlobalKey<HybridPageState>');
    return null;
  }

  void _onShownPageChanged(String oldPageId, String newPageId) {
    Logger.debug('onShownPageChanged old:$oldPageId now:$newPageId');
    FlutterHybrid.sharedInstance
      .nativeNavigationMessenger.notifyFlutterShownPageChanged(oldPageId, newPageId);
  }

  void _refreshOverlayEntries() {
    Logger.debug('refreshOverlayEntries, onstage: ${_onstagePage.settings}');
    for (HybridPage offstage in _offstagePages) {
      Logger.debug('refreshOverlayEntries, offstage: ${offstage.settings}');
    }

    final OverlayState overlayState = _overlayKey.currentState;
    if (overlayState == null) {
      return;
    }

    if (_hybridPageEntries != null && _hybridPageEntries.isNotEmpty) {
      for (_HybridPageOverlayEntry entry in _hybridPageEntries) {
        entry.remove();
      }
    }

    final List<HybridPage> containers = <HybridPage>[];
    containers.addAll(_offstagePages);

    assert(_onstagePage != null, 'Should have at least one HybridPage');
    containers.add(_onstagePage);

    _hybridPageEntries = containers
        .map<_HybridPageOverlayEntry>(
            (HybridPage hybridPage) => _HybridPageOverlayEntry(hybridPage))
        .toList(growable: false);
    overlayState.insertAll(_hybridPageEntries);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final String currentPageId = _onstagePage.settings.uniqueID;
      if (_lastShownPageId != currentPageId) {
        final String oldPageId = _lastShownPageId;
        _lastShownPageId = currentPageId;
        _onShownPageChanged(oldPageId, currentPageId);
      }
      updateFocus();
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _refreshOverlayEntries();
      });
    } else {
      _refreshOverlayEntries();
    }

    fn();
  }

  // If page exists, bring it to front else
  // create a page.
  void showHybridPage(HybridPageSettings settings) {
    if (settings.uniqueID == _onstagePage.settings.uniqueID) {
      _onShownPageChanged(null, settings.uniqueID);
      return;
    }

    final int index = _offstagePages.indexWhere((HybridPage hybridPage) =>
        hybridPage.settings.uniqueID == settings.uniqueID);
    if (index > -1) {
      _offstagePages.add(_onstagePage);
      _onstagePage = _offstagePages.removeAt(index);

      setState(() {});

      FlutterHybrid.sharedInstance.pageContainerOperationObserverManager
        .notifyObservers(_onstagePage.settings, HybridPageContainerOperation.onstage);
    } else {
      push(settings);
    }
  }

  HybridPageState pageStateOf(String pageId) {
    if (pageId == _onstagePage.settings.uniqueID) {
      return _stateOf(_onstagePage);
    }

    final HybridPage hybridPage = _offstagePages.firstWhere(
        (HybridPage hybridPage) => hybridPage.settings.uniqueID == pageId,
        orElse: () => null);

    return hybridPage == null ? null : _stateOf(hybridPage);
  }

  bool containsPage(String pageId) {
    if (pageId == _onstagePage.settings.uniqueID) {
      return true;
    }

    return _offstagePages
        .any((HybridPage page) => page.settings.uniqueID == pageId);
  }

  void push(HybridPageSettings settings) {
    assert(!containsPage(settings.uniqueID));

    _offstagePages.add(_onstagePage);
    _onstagePage = HybridPage.obtain(widget.initialNavigator, settings);

    setState(() {});

    FlutterHybrid.sharedInstance.pageContainerOperationObserverManager
        .notifyObservers(_onstagePage.settings, HybridPageContainerOperation.push);
  }

  void pop() {
    assert(canPop());

    final HybridPage oldPage = _onstagePage;
    _onstagePage = _offstagePages.removeLast();
    setState(() {});

    FlutterHybrid.sharedInstance.pageContainerOperationObserverManager
        .notifyObservers(oldPage.settings, HybridPageContainerOperation.pop);
  }

  void remove(String pageId) {
    if (_onstagePage.settings.uniqueID == pageId) {
      pop();
    } else {
      final HybridPage page = _offstagePages.firstWhere(
          (HybridPage page) => page.settings.uniqueID == pageId,
          orElse: () => null);

      if (page != null) {
        _offstagePages.remove(page);
        setState(() {});

        FlutterHybrid.sharedInstance.pageContainerOperationObserverManager
        .notifyObservers(page.settings, HybridPageContainerOperation.remove);
      }
    }

    return null;
  }

  String dump() {
    String info = 'onstage#:\n  ${_onstagePage?.desc()}\noffstage#:';
    for (HybridPage offstagePage in _offstagePages.reversed) {
      info = '$info\n  ${offstagePage?.desc()}';
    }
    return info;
  }
}
