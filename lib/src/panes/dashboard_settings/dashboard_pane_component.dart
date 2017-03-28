import 'package:angular2/core.dart';
import 'package:aside/src/panes/abstract_pane.dart';

@Component(selector: 'dashboard-pane')
@View(templateUrl: 'dashboard_pane_component.html')
class DashboardPaneComponent implements AbstractPane {
  String id = 'dashboardpane';
  Type type = DashboardPaneComponent;
  String iconClass = 'icon-settings';
  String paneClass = 'p-1';

  DashboardPaneComponent();
}
