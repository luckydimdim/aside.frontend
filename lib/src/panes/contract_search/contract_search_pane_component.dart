import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:contracts/contracts_service.dart';
import 'package:contracts/contract_general_model.dart';

import '../abstract_pane.dart';

@Component(
  templateUrl: 'contract_search_pane_component.html',
  selector: 'contract-search-pane')
/**
 * Поиск и выбор договоров автокомплитером
 */
class ContractSearchPaneComponent implements AbstractPane, OnInit {
  final Router _router;

  String id = 'contract-search-pane';
  Type type = ContractSearchPaneComponent;
  String iconClass = 'fa fa-file';
  String paneClass = 'p-1';

  ContractsService _service;
  List<ContractGeneralModel> contracts = new List<ContractGeneralModel>();
  ContractGeneralModel selectedContract = null;

  ContractSearchPaneComponent(this._service, this._router);

  @override
  ngOnInit() async {
    contracts = await _service.general.getContracts();
  }

  /**
   * Заполнить и показать блок с информацией о выбранном договоре
   */
  void showSelectedContractInfo(Event event) {
    selectedContract = contracts.firstWhere(
      (ContractGeneralModel contract) => contract.id ==
        (event.target as SelectElement).value, orElse: () => null);
  }

  /**
   * Нажатие на кнопку выбора договора
   */
  void selectContract() {
    // TODO: необходимо избавиться от хардкода
    _router.navigateByUrl('/create/${ selectedContract?.id ?? '' }');
  }
}