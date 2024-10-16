part of 'video_converter_bloc.dart';

@immutable
sealed class VideoConverterState {}

final class VideoConverterInitial extends VideoConverterState {

}

final class VideoConverterInitialWithError extends VideoConverterState {
  String error;
  VideoConverterInitialWithError(this.error);

}


//picked file state
class FilesPickedState extends VideoConverterState{
  List<String> files;
  FilesPickedState(this.files);
}

class ConversionInProgressState extends VideoConverterState{

}
class ConvertingState extends VideoConverterState{

}

class ConversionCompletedState extends VideoConverterState{
  List<String> convertedFiles;
  String selectedFormat;
  bool? copyMethod;
  ConversionCompletedState(this.convertedFiles,this.selectedFormat,this.copyMethod);
}
