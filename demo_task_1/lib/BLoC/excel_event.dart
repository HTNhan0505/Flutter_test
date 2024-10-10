abstract class ExcelEvent {}

class UploadExcelEvent extends ExcelEvent {
  final String filePath;

  UploadExcelEvent(this.filePath);
}