import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'video_converter_event.dart';
part 'video_converter_state.dart';

class VideoConverterBloc extends Bloc<VideoConverterEvent, VideoConverterState> {
  Process? _currentProcess;
  VideoConverterBloc() : super(VideoConverterInitial()) {

    //registered event handler with the below _onPickFiles
    on<PickFilesEvent>(_onPickFiles);

    //drop file event handler
    on<DropFilesEvent>((event,emit){
      emit(FilesPickedState(event.files));
    });

    //convert file event
    on<ConvertFilesEvent>(runFFmpegBeta);

    //cancel event
    on<CancelConversionEvent>(_cancelConversion);
  }

  //pick file event bloc
  Future<void> _onPickFiles(PickFilesEvent event, Emitter<VideoConverterState>emit)async{
    try{
      FilePickerResult? result=await FilePicker.platform.pickFiles(allowMultiple: true);

      if(result!=null){
        List<String>files=result.paths.map((path) => path!).toList();
        log(files.toString());
        emit(FilesPickedState(files));
      }
      else{
        log('File picked is empty');
      }
    }
    catch(e){
      log('Error picking files: $e');
      emit(VideoConverterInitial());
    }
  }

  //run bash command of ffmpeg
  Future<void>runFFmpeg(ConvertFilesEvent event,Emitter<VideoConverterState>emit)async{
    try{
      List<String>successFiles=[];
      Directory? downloadDir=await getDownloadsDirectory();

      //check output directory avalability
      if (downloadDir == null) {
        log('Could not find the default download directory.');
        return;
      }

      for(int i=0;i<event.files.length;i++){
        //get filename from ori file
        String fileName=event.files[i].split(Platform.pathSeparator).last;
        String outputFileName=fileName.replaceAll('.flv', '.mp4');

        Directory outputDir=Directory('${downloadDir.path}${Platform.pathSeparator}converted_file');
        if(!outputDir.existsSync()){
          await outputDir.create(recursive: true);
        }

        String outputPath='${outputDir.path}${Platform.pathSeparator}$outputFileName';
        final result=await Process.run('ffmpeg',[
          '-i',event.files[i],
          '-vcodec','copy',
          '-acodec','copy',
          '-y', outputPath,
        ]);
        //success
        if(result.exitCode==0){
          print('Video converted successfully: $outputPath');
          successFiles.add(outputPath);
        }
        else{
          log('error in conversion ${result.stderr}');
        }
      }
      emit(ConversionCompletedState(successFiles,event.format,event.copyMethod));

    }
    catch(e){
      log('Exception: $e');
    }
  }

  Future<void> runFFmpegBeta(ConvertFilesEvent event, Emitter<VideoConverterState> emit) async {
    try {

      emit(ConversionInProgressState());
      List<String> successFiles = [];
      final appSupportDir = await getApplicationSupportDirectory();
      Directory ffmpegDir = Directory('${appSupportDir.path}\\ffmpeg');
      log('windows path for my appdata ${ffmpegDir.toString()}');
      final ffmpegPath = '${ffmpegDir.path}/ffmpeg.exe'; // Adjust path to the executable
      Directory? downloadDir = await getDownloadsDirectory();

      // Check and create the ffmpeg directory if it doesn't exist
      if (!ffmpegDir.existsSync()) {
        await ffmpegDir.create(recursive: true);
      }

      //await checkFFmpeg(ffmpegDir);
      bool checking=await checkFFmpegBin(ffmpegDir);
      log('ffmpeg exist : ${checking.toString()}');
      if(checking==false){
        String errorDesc='Missing of ffmpeg.exe in ${ffmpegDir.path.toString()}';
        emit(VideoConverterInitialWithError(errorDesc));
        return;
      }


      // Check if the output directory is available
      if (downloadDir == null) {
        log('Could not find the default download directory.');
        emit(VideoConverterInitial());
        return;
      }

      // Create output directory if it doesn't exist
      Directory outputDir = Directory('${downloadDir.path}${Platform.pathSeparator}converted_file');
      if (!outputDir.existsSync()) {
        await outputDir.create(recursive: true);
      }

      for (int i = 0; i < event.files.length; i++) {
        // Get filename from original file
        String fileName = event.files[i].split(Platform.pathSeparator).last;
        String outputFileName;
        if (fileName.contains('.')) {
          outputFileName = fileName.replaceAll(RegExp(r'\.[^.]+$'), '.${event.format.toLowerCase()}');
        }
        else {
          int timeStamp=DateTime.now().millisecondsSinceEpoch;
          outputFileName = '${fileName}_${timeStamp.toString()}.${event.format.toLowerCase()}';
        }

        String outputPath = '${outputDir.path}${Platform.pathSeparator}$outputFileName';

        // Declare result variable
        late final ProcessResult result;

        log('copymthod = ${event.copyMethod.toString()}');

        if (event.copyMethod == true) {
          // Run the FFmpeg command for copy method
          log('Run copy only');
          _currentProcess = await Process.start(ffmpegPath, [
            '-i',
            event.files[i],
            '-vcodec',
            'copy',
            '-acodec',
            'copy',
            '-y',
            outputPath,
          ]);
        }
        else {
          // Run the FFmpeg command with re-encoding using libx264 and aac
          log('Run convert acodec and vcodec');
          _currentProcess = await Process.start(ffmpegPath, [
            '-i',
            event.files[i],
            '-vcodec',
            'libx264', // Use H.264 video codec
            '-acodec',
            'aac',     // Use AAC audio codec
            '-y',      // Overwrite output files without asking
            outputPath,
          ]);
        }

        // Listen to stdout and stderr to avoid blocking
        _currentProcess?.stdout.transform(utf8.decoder).listen((data) {
          log('stdout: $data');
        });

        _currentProcess?.stderr.transform(utf8.decoder).listen((data) {
          log('stderr: $data');
        });

        final exitCode=await _currentProcess!.exitCode;

        // Check the result
        if (exitCode == 0) {
          print('Video converted successfully: $outputPath');
          successFiles.add(outputPath);
        }
        //1
        else {
          log('Error in conversion: ${exitCode.toString()}');
        }
      }

      emit(ConversionCompletedState(successFiles,event.format,event.copyMethod));

    } catch (e) {
      log('Exception: $e');
    }
  }

  //CHECK FFmpeg availability
  Future<bool>checkFFmpegBin(Directory ffmpegDir)async{
    // Load the list from JSON
    final byteData = await rootBundle.load('assets/JSON/FFmpeg_dll.json');
    final jsonString = utf8.decode(byteData.buffer.asUint8List());
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Extract list from the FFmpeg key
    final List<String> ffmpegFiles = List<String>.from(jsonMap['FFmpeg']);
    bool allFilesExist = true;


    // Check if all files exist
    for (String fileName in ffmpegFiles) {
      final targetPath = '${ffmpegDir.path}/$fileName';
      if (!File(targetPath).existsSync()) {
        allFilesExist = false;
        break; // Exit the loop if any file is missing
      }
    }
    return allFilesExist==true? true : false;
  }

  //abandoned method as decide to not include precompiled ffmpeg with the project assets
  Future<void>checkFFmpeg(Directory ffmpegDir)async{
    // Load the list from JSON
    final byteData = await rootBundle.load('assets/JSON/FFmpeg-dll-exe.json');
    final jsonString = utf8.decode(byteData.buffer.asUint8List());
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Extract list from the FFmpeg key
    final List<String> ffmpegFiles = List<String>.from(jsonMap['FFmpeg']);
    bool allFilesExist = true;


    // Check if all files exist
    for (String fileName in ffmpegFiles) {
      final targetPath = '${ffmpegDir.path}/$fileName';
      if (!File(targetPath).existsSync()) {
        allFilesExist = false;
        break; // Exit the loop if any file is missing
      }
    }

    // If not all files exist, copy them
    if (!allFilesExist) {
      for (String fileName in ffmpegFiles) {
        final sourcePath = 'assets/ffmpeg/bin/$fileName';
        final targetPath = '${ffmpegDir.path}/$fileName';

        // Copy the file
        final byteData = await rootBundle.load(sourcePath);
        final buffer = byteData.buffer;

        // Write the bytes to the target file
        await File(targetPath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
        debugPrint('Copied $fileName to $targetPath');
      }
    } else {
      debugPrint('All FFmpeg files already exist in $ffmpegDir');
    }

  }

  //not working not sure LMAO
  void _cancelConversion(CancelConversionEvent event, Emitter<VideoConverterState> emit) {
    log('Killing the process...');
    _currentProcess?.stdin.write('q\n');
    _currentProcess?.kill(ProcessSignal.sigkill);
    _currentProcess = null; // Clear the reference
    emit(VideoConverterInitial());
  }

}

