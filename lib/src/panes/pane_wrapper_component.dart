import 'dart:async';

import 'package:angular2/core.dart';
import 'abstract_pane.dart';

import '../pane_types.dart';
import '../panes/contract_search/contract_search_pane_component.dart';
import '../panes/dashboard_settings/dashboard_pane_component.dart';
import '../panes/messages/messages_pane_component.dart';
import '../panes/timeline/timeline_pane_component.dart';
import '../pane_added_event.dart';

@Component(selector: 'dcl-wrapper')
@View(template: '<div #target></div>')
class PaneWrapperComponent implements AfterViewInit, OnDestroy {
  ComponentResolver _loader;
  bool _isViewInitialized;
  ComponentRef _cmpRef;

  @ViewChild('target', read: ViewContainerRef)
  ViewContainerRef target;

  @Input()
  PaneType type;

  @Input()
  dynamic data;

  @Output()
  final initialized = new EventEmitter<AbstractPane>();

  PaneWrapperComponent(this._loader);

  @override
  void ngAfterViewInit() {
    _isViewInitialized = true;
    updateComponent();
  }

  @override
  void ngOnDestroy() {
    if (_cmpRef != null) {
      _cmpRef.destroy();
    }
  }

  updateComponent() {
    if (!_isViewInitialized) {
      return;
    }

    if (_cmpRef != null) {
      _cmpRef.destroy();
    }

    Type paneType = _resolvePaneType(type);

    Future<ComponentFactory> componentFactoryPromise;
    componentFactoryPromise = this._loader.resolveComponent(paneType);

    componentFactoryPromise.then((componentFactory) {
      _cmpRef = target.createComponent(componentFactory, 0, target.parentInjector);
      AbstractPane pane = _cmpRef.instance as AbstractPane;
      pane.data = data;

      initialized.emit(pane);
    });
  }

  /**
   * Полученеи типа панели по ее названию в енуме
   */
  Type _resolvePaneType(PaneType type) {
    Type result = null;

    switch (type) {
      case PaneType.timeline:
        result = TimelinePaneComponent;
        break;

      case PaneType.dashboard:
        result = DashboardPaneComponent;
        break;

      case PaneType.messages:
        result = MessagesPaneComponent;
        break;

      case PaneType.contractSearch:
        result = ContractSearchPaneComponent;
        break;

      default:
        throw new Exception('Unknown pane');
    }

    return result;
  }
}