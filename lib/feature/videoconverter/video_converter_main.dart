import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:videoconverter/feature/reusable/converter_settings_ui.dart';
import 'package:videoconverter/feature/reusable/file_convert_ui.dart';
import 'package:videoconverter/feature/videoconverter/bloc/video_converter_bloc.dart';

import '../reusable/file_picker_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoConverterMain extends StatefulWidget {
  const VideoConverterMain({super.key, required this.title});
  final String title;

  @override
  State<VideoConverterMain> createState() => _VideoConverterMainState();
}

class _VideoConverterMainState extends State<VideoConverterMain> {

  final ValueNotifier<String?> selectedFormatNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<bool?> copyMethod = ValueNotifier<bool?>(true);

  bool _isDialogVisible = false; // Track if the dialog is already shown

  void _showErrorInfoDialog(String errMsg) {
    if (_isDialogVisible) return; // Prevent showing multiple dialogs

    _isDialogVisible = true; // Set dialog visibility to true

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Message'),
          content: Text(errMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _isDialogVisible = false; // Reset dialog visibility
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    ).then((_) {
      _isDialogVisible = false; // Ensure the dialog is reset after closing
    });
  }

  // Loading UI during conversion
  Widget _buildLoadingUI(double screenHeight,double screenWidth, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: false,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined),
                onPressed:(){
                  context.read<VideoConverterBloc>().add(CancelConversionEvent());
                } ,
              ),
            ),
          ),


          SizedBox(
            width: screenWidth*0.2,
            height: screenHeight*0.3,
            child: CircularProgressIndicator(),
          ),

          SizedBox(height: screenHeight * 0.02),
          Text('Conversion in progress... Please wait.'),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth=MediaQuery.of(context).size.width;
    final double screenHeight=MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context)=>VideoConverterBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),

        body: BlocBuilder<VideoConverterBloc,VideoConverterState>(
          builder: (context, state) {
            if(state is ConversionInProgressState){
              return _buildLoadingUI(screenHeight,screenWidth,context);
            }
            else if(state is ConversionCompletedState){
              print('enter conversion completed state');
              selectedFormatNotifier.value=state.selectedFormat;
              print(selectedFormatNotifier.value.toString());
              copyMethod.value=state.copyMethod;
              return Row(
                children: [
                  //Row 1
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight*0.01),
                        Align(
                          alignment: Alignment.center,
                          child: FilePickerComponent(selectedFormatNotifier: selectedFormatNotifier,copyMethod: copyMethod),
                        ),
                        SizedBox(height: screenHeight*0.01),
                        Align(
                          alignment: Alignment.center,
                          child: FileConvertedComponent(),
                        ),
                      ],
                    ),
                  ),
                  //Row 2
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        ConverterSettingsUi(selectedFormatNotifier: selectedFormatNotifier,copyMethod: copyMethod),
                      ],
                    ),
                  ),


                ],

              );
            }
            else if(state is VideoConverterInitialWithError){
              print('enter conversion error state');
              WidgetsBinding.instance.addPostFrameCallback((_){
                _showErrorInfoDialog(state.error);
              });
              return Row(
                children: [
                  //Row 1
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight*0.01),
                        Align(
                          alignment: Alignment.center,
                          child: FilePickerComponent(selectedFormatNotifier: selectedFormatNotifier,copyMethod: copyMethod),
                        ),
                        SizedBox(height: screenHeight*0.01),
                        Align(
                          alignment: Alignment.center,
                          child: FileConvertedComponent(),
                        ),
                      ],
                    ),
                  ),
                  //Row 2
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        ConverterSettingsUi(selectedFormatNotifier: selectedFormatNotifier,copyMethod: copyMethod),
                      ],
                    ),
                  ),
                ],
              );
            }
            else{
              return Row(
                children: [
                  //Row 1
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight*0.01),
                        Align(
                          alignment: Alignment.center,
                          child: FilePickerComponent(selectedFormatNotifier: selectedFormatNotifier,copyMethod: copyMethod),
                        ),
                        SizedBox(height: screenHeight*0.01),
                        Align(
                          alignment: Alignment.center,
                          child: FileConvertedComponent(),
                        ),
                      ],
                    ),
                  ),
                  //Row 2
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        ConverterSettingsUi(selectedFormatNotifier: selectedFormatNotifier,copyMethod: copyMethod),
                      ],
                    ),
                  ),


                ],

              );

            }


          },

        )

      ),
    );

  }
}