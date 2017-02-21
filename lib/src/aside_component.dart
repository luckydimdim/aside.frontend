import 'package:angular2/core.dart';
import 'panes/dashboard_settings/dashboard_settings_component.dart';
import 'package:aside/src/panes/pane_wrapper_component.dart';
import 'package:aside/src/panes/abstract_pane.dart';

@Component(selector: 'aside')
@View(templateUrl: 'aside_component.html',
    directives: const [PaneWrapperComponent, DashboardSettingsComponent
    ])
class AsideComponent implements AfterViewInit {
  final ChangeDetectorRef _changeDetectorRef;
  Map<Type, AbstractPane> panes = new Map<Type, AbstractPane>();

  AsideComponent(this._changeDetectorRef) {}

  @override
  void ngAfterViewInit() {
    panes[DashboardSettingsComponent] = new AbstractPane();
    _changeDetectorRef.detectChanges();
  }

  void updatePanesInfo(Type type, AbstractPane pane) {
    panes[type] = pane;
  }
}
