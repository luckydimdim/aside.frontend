import 'dart:html';
import 'dart:async';
import 'dart:core';

import 'pane_types.dart';

import 'package:angular2/angular2.dart';

@Injectable()
class AsideService {
  StreamController<PaneType> _paneAddingController = new StreamController<PaneType>();
  StreamController<PaneType> _paneRemovingController = new StreamController<PaneType>();

  /*
  * Команда - добавить панель
  * */
  void addPane(PaneType type) {
    _paneAddingController.add(type);
  }

  /*
  * Команда - удалить
  * */
  void removePane(PaneType type) {
    _paneRemovingController.add(type);
  }

  /*
  * Событие - добавить панель
  * */
  Stream<PaneType> onPaneAdding() => _paneAddingController.stream;

  /*
  * Событие - удалить панель
  * */
  Stream<PaneType> onPaneRemoving() => _paneRemovingController.stream;
}