import 'package:angular2/core.dart';
import 'package:aside/src/panes/abstract_pane.dart';

@Component(selector: 'dashboard-settings')
@View(templateUrl: 'dashboard_settings_component.html')
class DashboardSettingsComponent implements AbstractPane {

  String id = "dashboard-settings";
  Type type = DashboardSettingsComponent;
  String iconClass = "icon-settings";

  DashboardSettingsComponent() {
  }
}