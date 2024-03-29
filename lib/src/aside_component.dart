import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';

import 'package:contracts/contracts_service.dart';
import 'package:time_sheet/time_sheet_service.dart';

import 'panes/dashboard_settings/dashboard_pane_component.dart';
import 'panes/pane_wrapper_component.dart';
import 'panes/abstract_pane.dart';
import 'panes/messages/messages_pane_component.dart';
import 'panes/attachments/attachments_pane_component.dart';
import 'aside_service.dart';
import 'pane_types.dart';
import 'pane_added_event.dart';

@Component(
    selector: 'aside',
    templateUrl: 'aside_component.html',
    providers: const [
      ContractsService,
      TimeSheetService
    ],
    directives: const [
      PaneWrapperComponent,
      DashboardPaneComponent,
      MessagesPaneComponent,
      AttachmentsPaneComponent
    ])
class AsideComponent implements OnDestroy {
  final ChangeDetectorRef _changeDetectorRef;
  final AsideService _asideService;
  StreamSubscription _onPaneAddingSubscription;
  StreamSubscription _onPaneRemovingSubscription;

  Map<PaneType, AbstractPane> panes = new Map<PaneType, AbstractPane>();

  String activePaneId;

  AsideComponent(this._changeDetectorRef, this._asideService) {
    _onPaneAddingSubscription =
        _asideService.onPaneAdding().listen((t) => addPane(t));
    _onPaneRemovingSubscription =
        _asideService.onPaneRemoving().listen((t) => removePane(t));
  }

  void addPane(PaneAddedEvent eventData) {
    if (panes.containsKey(eventData.type)) return;

    panes[eventData.type] = new AbstractPane()..data = eventData.data;

    _changeDetectorRef.detectChanges();
  }

  void removePane(PaneType type) {
    if (!panes.containsKey(type)) return;

    panes.remove(type);

    // FIXME: найти более элегантный способ установить активную панель
    panes.forEach((k, v) => activePaneId = v.id);

    if (panes.isEmpty) {
      (querySelector('body') as BodyElement)
          .classes
          .removeWhere((className) => className == 'aside-menu-open');
    }

    _changeDetectorRef.detectChanges();
  }

  void updatePanesInfo(PaneType type, AbstractPane paneInfo) {
    if (!panes.containsKey(type)) return;

    panes[type] = paneInfo;
    activePaneId = paneInfo.id;

    _changeDetectorRef.detectChanges();
  }

  String getVisibleHref(String id) {
    if (id == '' || id == null) return null;

    return '#' + id;
  }

  Map<String, bool> tabPanelClasses(PaneType type) {
    var result = new Map<String, bool>();
    result['tab-pane'] = true;

    if (!panes.containsKey(type)) return result;

    var paneInfo = panes[type];

    //  TODO: сделать возможность использования нескольких классов, например через ;
    if (paneInfo.paneClass != '' && paneInfo.paneClass != null)
      result[paneInfo.paneClass] = true;

    if (paneInfo.id == activePaneId) {
      result['active'] = true;
    } else {
      result['fade'] = true;
    }

    return result;
  }

  Map<String, bool> navLinkClasses(PaneType type) {
    var result = new Map<String, bool>();
    result['nav-link'] = true;

    if (!panes.containsKey(type)) return result;

    var paneInfo = panes[type];

    if (paneInfo.id == activePaneId) result['active'] = true;

    return result;
  }

  @override
  ngOnDestroy() {
    _onPaneAddingSubscription.cancel();
    _onPaneRemovingSubscription.cancel();
  }
}
