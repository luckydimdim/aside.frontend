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
  String id = 'contract-search-pane';
  Type type = ContractSearchPaneComponent;
  String iconClass = 'fa fa-file';
  String paneClass = 'p-1';

  ContractsService _service;
  List<ContractGeneralModel> contracts = new List<ContractGeneralModel>();
  ContractGeneralModel selectedContract = null;
  bool disabled = false;

  /**
   * Дополнительные данные,
   * переданные из компонента-создателя панели
   */
  dynamic data = null;

  ContractSearchPaneComponent(this._service);

  @override
  ngOnInit() async {

    disabled = data['enabled'] != null && !data['enabled'];

    contracts = await _service.general.getContracts();

    if (data['contractId'] != null) _setSelectedContract(data['contractId']);
  }

  /**
   * Заполнить и показать блок с информацией о выбранном договоре
   */
  void showSelectedContractInfo(Event event) {
    String contractId = (event.target as SelectElement).value;

    _setSelectedContract(contractId);
  }

  /**
   * Находи и устанавливает выбранный договор
   */
  void _setSelectedContract(String contractId) {
    selectedContract = contracts.firstWhere(
        (ContractGeneralModel contract) => contract.id == contractId,
        orElse: () => null);
  }

  /**
   * Нажатие на кнопку выбора договора
   */
  void selectContract() {
    if (selectedContract == null) return;

    var router = data['router'] as Router;

    router.parent.navigate([
      '[Request/RequestCreate]',
      {'id': selectedContract.id}
    ]);
  }
}
