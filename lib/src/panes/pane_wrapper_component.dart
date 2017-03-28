import 'dart:async';

import 'package:angular2/core.dart';
import 'abstract_pane.dart';

@Component(selector: 'dcl-wrapper')
@View(template: '<div #target></div>')
class PaneWrapperComponent implements AfterViewInit, OnDestroy {
  ComponentResolver _loader;
  bool _isViewInitialized;
  ComponentRef _cmpRef;

  @ViewChild('target', read: ViewContainerRef)
  ViewContainerRef target;

  @Input()
  Type type;

  @Output()
  final initialized = new EventEmitter<AbstractPane>();

  PaneWrapperComponent(this._loader);

  @override
  void ngAfterViewInit() {
    _isViewInitialized = true;
    updateComponent();
  }

  @override
  void ngOnDestroy() {
    if (_cmpRef != null) {
      _cmpRef.destroy();
    }
  }

  updateComponent() {
    if (!_isViewInitialized) {
      return;
    }

    if (_cmpRef != null) {
      _cmpRef.destroy();
    }

    Future<ComponentFactory> componentFactoryPromise;
    if (type is ComponentFactory) {
      componentFactoryPromise = new Future.value(type);
    } else {
      componentFactoryPromise = this._loader.resolveComponent(type);
    }
    componentFactoryPromise.then((componentFactory) {
      _cmpRef =
          target.createComponent(componentFactory, 0, target.parentInjector);
      initialized.emit((_cmpRef.instance as AbstractPane));
    });
  }
}
