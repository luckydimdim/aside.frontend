import 'package:angular2/core.dart';
import '../abstract_pane.dart';

@Component(
    selector: 'dashboard-pane', templateUrl: 'dashboard_pane_component.html')
class DashboardPaneComponent implements AbstractPane {
  String id = 'dashboardpane';
  Type type = DashboardPaneComponent;
  String iconClass = 'icon-settings';
  String paneClass = 'p-1';

  /**
   * Дополнительные данные,
   * переданные из компонента-создателя панели
   */
  dynamic data = null;
}
