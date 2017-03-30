class AbstractPane {
  /**
   * Уникальный ID панели. Используется при построении Bootstrap Tab
   */
  String id;

  /**
   * Иконка панели
   */
  String iconClass;

  /**
   * Дополнительный CSS класс панели.
   * TODO: сделать возможность использования нескольких классов, например через ;
   */
  String paneClass;
}
