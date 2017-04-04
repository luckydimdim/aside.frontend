import 'pane_types.dart';

/**
 * Объект, содержаий информацию о типе панели,
 * которую нужно добавить и доп. данные для ее функционирования
 */
class PaneAddedEvent {
  /**
   * Тип панели
   */
  PaneType type = PaneType.none;

  /**
   * Дополнительные данные
   */
  dynamic data = null;
}