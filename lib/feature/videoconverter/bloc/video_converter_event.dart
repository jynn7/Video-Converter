part of 'video_converter_bloc.dart';

@immutable
sealed class VideoConverterEvent {}

//pick file event
class PickFilesEvent extends VideoConverterEvent{

}

//drop file event
class DropFilesEvent extends VideoConverterEvent{
  List<String>files;
  DropFilesEvent(this.files);
}

class ConvertFilesEvent extends VideoConverterEvent {
  List<String>files;
  String format;
  bool? copyMethod;
  ConvertFilesEvent(this.files,this.format,this.copyMethod);

}

class CancelConversionEvent extends VideoConverterEvent{

}