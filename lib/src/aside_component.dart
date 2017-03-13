import 'package:angular2/core.dart';
import 'panes/dashboard_settings/dashboard_pane_component.dart';
import 'package:aside/src/panes/pane_wrapper_component.dart';
import 'package:aside/src/panes/abstract_pane.dart';
import 'package:aside/src/panes/messages/messages_pane_component.dart';
import 'package:aside/src/panes/timeline/timeline_pane_component.dart';
import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

@Component(selector: 'aside')
@View(templateUrl: 'aside_component.html',
    directives: const [
      PaneWrapperComponent, DashboardPaneComponent, MessagesPaneComponent
    ])
class AsideComponent
    implements AfterViewInit {
  final ChangeDetectorRef _changeDetectorRef;
  final AsideService _asideService;
  Map<Type, AbstractPane> panes = new Map<Type, AbstractPane>();

  String activePaneId;

  AsideComponent(this._changeDetectorRef, this._asideService) {
    _asideService.onPaneAdding().listen((t) => addPane(t));
    _asideService.onPaneRemoving().listen((t) => removePane(t));
  }

  @override
  void ngAfterViewInit() {
  }

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

    panes.forEach((k, v) =>
    activePaneId = v
        .id); // FIXME: найти более элегантный способ установить активную панель

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

    if (paneInfo.paneClass != '' && paneInfo.paneClass != null)
      result[paneInfo.paneClass] =
      true; //  TODO: сделать возможность использования нескольких классов, например через ;

    if (paneInfo.id == activePaneId) {
      result['active'] = true;
    }
    else {
      result['fade'] = true;
    }

    return result;
  }

  Map<String, bool> navLinkClasses(Type type) {
    var result = new Map<String, bool>();
    result['nav-link'] = true;

    if (!panes.containsKey(type))
      return result;

    var paneInfo = panes[type];

    if (paneInfo.id == activePaneId)
      result['active'] = true;

    return result;
  }

}
