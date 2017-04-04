import 'package:angular2/core.dart';
import '../abstract_pane.dart';

@Component(selector: 'messages-pane')
@View(templateUrl: 'messages_pane_component.html')
class MessagesPaneComponent implements AbstractPane {
  String id = 'messagespane';
  Type type = MessagesPaneComponent;
  String iconClass = 'icon-speech';
  String paneClass = 'p-1';

  /**
   * Дополнительные данные,
   * переданные из компонента-создателя панели
   */
  dynamic data = null;
}
