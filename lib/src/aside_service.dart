import 'dart:core';
import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'pane_types.dart';
import 'pane_added_event.dart';

@Injectable()
class AsideService {
  StreamController<PaneAddedEvent> _paneAddingController = new StreamController<PaneAddedEvent>();
  StreamController<PaneType> _paneRemovingController = new StreamController<PaneType>();

  /**
   * Команда - добавить панель
   */
  void addPane(PaneType type, [dynamic data]) {
    var eventData = new PaneAddedEvent()
      ..type = type
      ..data = data;

    _paneAddingController.add(eventData);
  }

  /**
   * Команда - удалить
   */
  void removePane(PaneType type) {
    _paneRemovingController.add(type);
  }

  /**
   * Событие - добавить панель
   */
  Stream<PaneAddedEvent> onPaneAdding() => _paneAddingController.stream;

  /**
   * Событие - удалить панель
   */
  Stream<PaneType> onPaneRemoving() => _paneRemovingController.stream;

  /**
   * Открыть панель
   */
  void showPane() {
    (querySelector('body') as BodyElement).classes.add('aside-menu-open');
  }

  /**
   * Закрыть панель
   */
  void hidePane() {
    (querySelector('body') as BodyElement).classes.removeWhere((className) => className == 'aside-menu-open');
  }

  /**
   * Открыть или закрыть панель
   */
  void togglePane() {
    querySelector('body').classes.toggle('aside-menu-open');
  }
}