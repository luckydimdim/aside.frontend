import 'package:angular2/core.dart';
import '../abstract_pane.dart';

@Component(selector: 'timeline-pane')
@View(templateUrl: 'timeline_pane_component.html')
class TimelinePaneComponent implements AbstractPane {
  String id = 'timelinepane';
  Type type = TimelinePaneComponent;
  String iconClass = 'icon-list';
  String paneClass = '';

  /**
   * Дополнительные данные,
   * переданные из компонента-создателя панели
   */
  dynamic data = null;
}
