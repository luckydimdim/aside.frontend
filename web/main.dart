import 'dart:core';

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/src/core/reflection/reflection.dart';
import 'package:angular2/router.dart';
import 'package:angular2/src/platform/browser/location/hash_location_strategy.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular_utils/cm_router_link.dart';

import 'package:http/http.dart';
import 'package:http/browser_client.dart';

import 'package:master_layout/master_layout_component.dart';
import 'package:alert/src/alert_service.dart';
import 'package:logger/logger_service.dart';
import 'package:config/config_service.dart';

import 'package:aside/aside_component.dart';
import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

bool get isDebug =>
    (const String.fromEnvironment('PRODUCTION', defaultValue: 'false')) !=
    'true';

@Component(
    selector: 'app',
    providers: const [
      ROUTER_PROVIDERS,
      const Provider(LocationStrategy, useClass: HashLocationStrategy)
    ],
    template: '<master-layout></master-layout>',
    directives: const [
      MasterLayoutComponent,
      AsideComponent,
      RouterOutlet,
      CmRouterLink
    ])
class AppComponent {
  final AsideService _asideService;

  AppComponent(this._asideService) {
    _asideService.addPane(PaneType.contractSearch);
    _asideService.addPane(PaneType.timeline);
    _asideService.addPane(PaneType.dashboard);
    _asideService.addPane(PaneType.messages);
  }
}

main() async {
  if (isDebug) {
    reflector.trackUsage();
  }

  ComponentRef ref = await bootstrap(AppComponent, [
    ROUTER_PROVIDERS,
    const Provider(LocationStrategy, useClass: HashLocationStrategy),
    const Provider(AsideService),
    const Provider(AlertService),
    const Provider(LoggerService),
    const Provider(ConfigService),
    // provide(Client, useClass: InMemoryDataService)
    // Using a real back end?
    // Import browser_client.dart and change the above to:
    provide(Client, useFactory: () => new BrowserClient(), deps: [])
  ]);

  if (isDebug) {
    print('Application in DebugMode');
    enableDebugTools(ref);
    print('Unused keys: ${reflector.listUnusedKeys()}');
  }
}
