import 'dart:async';
import 'dart:core';

import 'dart:html';
import 'pane_types.dart';

import 'package:angular2/angular2.dart';

@Injectable()
class AsideService {
  StreamController<PaneType> _paneAddingController = new StreamController<PaneType>();
  StreamController<PaneType> _paneRemovingController = new StreamController<PaneType>();

  /**
   * Команда - добавить панель
   */
  void addPane(PaneType type) {
    _paneAddingController.add(type);
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
  Stream<PaneType> onPaneAdding() => _paneAddingController.stream;

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