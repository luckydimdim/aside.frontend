import 'package:angular2/core.dart';
import 'package:aside/src/panes/abstract_pane.dart';

@Component(selector: 'contract-search-pane')
@View(templateUrl: 'contract_search_pane_component.html')
class ContractSearchPaneComponent implements AbstractPane {
  String id = 'contract-search-pane';
  Type type = ContractSearchPaneComponent;
  String iconClass = 'fa fa-file';
  String paneClass = '';

  ContractSearchPaneComponent();
}
