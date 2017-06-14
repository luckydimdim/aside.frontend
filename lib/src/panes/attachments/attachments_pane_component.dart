import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:angular_utils/cm_format_size_pipe.dart';
import 'package:time_sheet/time_sheet_service.dart';
import 'package:time_sheet/models.dart';

import '../abstract_pane.dart';

/**
 * Работа с вложениями
 */
@Component(
    templateUrl: 'attachments_pane_component.html',
    selector: 'attachments-pane',
    pipes: const [CmFormatSizePipe])
class AttachmentsPaneComponent implements AbstractPane, OnInit {
  String id = 'attachments-pane';
  Type type = AttachmentsPaneComponent;
  String iconClass = 'fa fa-file';
  String paneClass = 'p-1';

  // контрол только на чтение
  bool disabled = false;

  @ViewChild('fileInput')
  ElementRef fileInput;

  final TimeSheetService _timeSheetService;

  List<AttachmentModel> model = null;

  String timeSheetId;

  /**
   * Дополнительные данные,
   * переданные из компонента-создателя панели
   */
  dynamic data = null;

  AttachmentsPaneComponent(this._timeSheetService);

  @override
  ngOnInit() async {
    disabled = data['enabled'] != null && !data['enabled'];

    timeSheetId = data['timeSheetId'];

    model = await _timeSheetService.getAttachments(timeSheetId);
  }

  /**
   * Получить иконку по типу файла
   */
  String getAttachmentClass(String contentType) {
    contentType = contentType.toLowerCase();

    if (contentType.contains('text'))
      return 'fa-file-text-o';
    else if (contentType.contains('image'))
      return 'fa-file-image-o';
    else if (contentType.contains('excel') ||
        contentType.contains('spreadsheet'))
      return 'fa-file-excel-o';
    else if (contentType.contains('archive'))
      return 'fa-file-archive-o';
    else if (contentType.contains('pdf'))
      return 'fa-file-pdf-o';
    else if (contentType.contains('word'))
      return 'fa-file-word-o';
    else
      return 'fa-file-o';
  }

  /**
   * Выбрали файл на загрузку
   */
  Future fileChange(event) async {
    FileList fileList = event.target.files;

    if (fileList.length > 0) {
      File file = fileList[0];

      bool exist =
          model.any((e) => e.name.toLowerCase() == file.name.toLowerCase());

      var inputElement = (fileInput.nativeElement as InputElement);

      if (exist) {
        window.alert('Файл с таким именем уже существует');
        inputElement.value = '';
        return;
      }

      if (file.size == 0) {
        window.alert('Нельзя загружать файл нулевого размера');
        inputElement.value = '';
        return;
      }

      try {
        await _timeSheetService.addAttachment(timeSheetId, file);
      } catch (e) {
        model = await _timeSheetService.getAttachments(timeSheetId);
        inputElement.value = '';
        rethrow;
      }

      model = await _timeSheetService.getAttachments(timeSheetId);
      inputElement.value = '';
    }
  }

  /**
   * Удалить вложение
   */
  deleteAttachment(String fileName) async {
    if (!window.confirm('Удалить вложение?')) return;

    await _timeSheetService.deleteAttachment(timeSheetId, fileName);

    model.removeWhere((a) => a.name == fileName);
  }

  /**
   * Загрузить вложение
   */
  getAttachment(String fileName) async {
    var token =  await _timeSheetService.createAttachmentToken(timeSheetId, fileName);
    var a = new AnchorElement();
    a.href = _timeSheetService.getAttachmentDownloadUrl(timeSheetId, fileName, token);
    a.download = fileName;

    // только ради IE
    a.classes.add('hidden-xs-up');
    document.body.append(a);

    a.click();
  }

  String decodeAttachmentName(String str) {
    return Uri.decodeFull(str);
  }
}
