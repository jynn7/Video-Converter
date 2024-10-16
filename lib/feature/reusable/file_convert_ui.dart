import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoconverter/feature/videoconverter/bloc/video_converter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FileConvertedComponent extends StatelessWidget{
  FileConvertedComponent({Key? key}) : super(key: key);

  Future<void>launchFileExplorer(BuildContext context, String filDir)async{
    Directory parentDir=Directory(filDir).parent;
    final Uri dirUri=Uri.file(parentDir.path);
    log('uri to open ${dirUri.path.toString()}');
    if(await canLaunchUrl(dirUri)){
      await launchUrl(dirUri);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open folder $filDir')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoConverterBloc,VideoConverterState>(
      listener: (context,state){
        //handle any state changes at here
        //example
        if(state is FilesPickedState){
          print('Picked files ${state.files}');
        }
      },
      builder: (context,state){
        final double screenWidth=MediaQuery.of(context).size.width;
        final double screenHeight=MediaQuery.of(context).size.height;
        return Container(
          //height: screenHeight*0.5,
          width: screenWidth*0.7,
          child: Card(
            elevation: 20,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight*0.05,horizontal: screenWidth*0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Converted Files',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.01),
                  Container(
                    height: screenHeight*0.2,
                    child: Card(
                      color: Colors.white,
                      child: ListView.separated(
                        itemCount: state is ConversionCompletedState ? state.convertedFiles.length : 0,
                        separatorBuilder: (context, index) => const Divider(), // Divider between items
                        itemBuilder: (context, index) {
                          if(state is ConversionCompletedState){
                            return ListTile(
                              title: Text(state.convertedFiles[index]),
                              trailing: IconButton(
                                onPressed: (){
                                  launchFileExplorer(context, state.convertedFiles[index].toString());
                                },
                                icon: Icon(Icons.folder),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                  ),
                ],
              ),
            ),

          ),

        );
      },

    );
  }
}
