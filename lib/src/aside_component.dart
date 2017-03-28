import 'package:angular2/core.dart';

import 'panes/dashboard_settings/dashboard_pane_component.dart';
import 'panes/contract_search/contract_search_pane_component.dart';
import 'panes/pane_wrapper_component.dart';
import 'panes/abstract_pane.dart';
import 'panes/messages/messages_pane_component.dart';
import 'panes/timeline/timeline_pane_component.dart';
import 'aside_service.dart';
import 'pane_types.dart';

@Component(selector: 'aside')
@View(templateUrl: 'aside_component.html', directives: const [
  PaneWrapperComponent,
  DashboardPaneComponent,
  MessagesPaneComponent])
class AsideComponent implements AfterViewInit {
  final ChangeDetectorRef _changeDetectorRef;
  final AsideService _asideService;
  Map<Type, AbstractPane> panes = new Map<Type, AbstractPane>();

  String activePaneId;

  AsideComponent(this._changeDetectorRef, this._asideService) {
    _asideService.onPaneAdding().listen((t) => addPane(t));
    _asideService.onPaneRemoving().listen((t) => removePane(t));
  }

  @override
  void ngAfterViewInit() {}

  void addPane(PaneType type) {
    switch (type) {
      case PaneType.Dashboard:
        panes[DashboardPaneComponent] = new AbstractPane();
        break;
      case PaneType.Messages:
        panes[MessagesPaneComponent] = new AbstractPane();
        break;
      case PaneType.Timeline:
        panes[TimelinePaneComponent] = new AbstractPane();
        break;
      case PaneType.ContractSearch:
        panes[ContractSearchPaneComponent] = new AbstractPane();
        break;
      default:
        return;
    }
    _changeDetectorRef.detectChanges();
  }

  void removePane(PaneType type) {
    switch (type) {
      case PaneType.Dashboard:
        panes.remove(DashboardPaneComponent);
        break;
      case PaneType.Messages:
        panes.remove(MessagesPaneComponent);
        break;
      case PaneType.Timeline:
        panes.remove(TimelinePaneComponent);
        break;
      default:
        return;
    }

    // FIXME: найти более элегантный способ установить активную панель
    panes.forEach((k, v) => activePaneId = v.id);

    _changeDetectorRef.detectChanges();
  }

  void updatePanesInfo(Type type, AbstractPane paneInfo) {
    if (!panes.containsKey(type))
      return;

    panes[type] = paneInfo;
    activePaneId = paneInfo.id;
    _changeDetectorRef.detectChanges();
  }

  String getVisibleHref(String id) {
    if (id == '' || id == null)
      return null;

    return "#" + id;
  }

  Map<String, bool> tabPanelClasses(Type type) {
    var result = new Map<String, bool>();
    result['tab-pane'] = true;

    if (!panes.containsKey(type))
      return result;

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

  Map<String, bool> navLinkClasses(Type type) {
    var result = new Map<String, bool>();
    result['nav-link'] = true;

    if (!panes.containsKey(type)) return result;

    var paneInfo = panes[type];

    if (paneInfo.id == activePaneId) result['active'] = true;

    return result;
  }
}