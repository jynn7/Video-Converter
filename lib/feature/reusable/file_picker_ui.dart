import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoconverter/feature/videoconverter/bloc/video_converter_bloc.dart';
import 'package:desktop_drop/desktop_drop.dart';


class FilePickerComponent extends StatefulWidget {
  final ValueNotifier<String?> selectedFormatNotifier;
  final ValueNotifier<bool?> copyMethod;

  const FilePickerComponent({Key? key, required this.selectedFormatNotifier, required this.copyMethod}) : super(key: key);

  @override
  _FilePickerComponentState createState() => _FilePickerComponentState();
}

class _FilePickerComponentState extends State<FilePickerComponent>{
  int totalFiles=0;
  bool isDragging=false;
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<VideoConverterBloc,VideoConverterState>(
      listener: (context,state){
        //handle any state changes at here
        if(state is FilesPickedState){
          setState(() {
            totalFiles=state.files.length;
          });
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
                  Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Select files',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: screenHeight*0.01),
                          FilledButton.icon(
                            onPressed: (){
                              context.read<VideoConverterBloc>().add(PickFilesEvent());
                            },
                            label: const Text('Pick Files'),
                          ),

                        ],
                      ),
                      Spacer(),
                      Card(
                        color: Colors.deepPurple[200],
                        child:Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight*0.01,horizontal: screenHeight*0.02),
                          child: Column(
                            children: [
                              const Text(
                                'Total Files Selected',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                totalFiles.toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),

                    ],

                  ),

                  SizedBox(height: screenHeight*0.03),
                  DropTarget(
                    onDragEntered: (details){
                      setState(() {
                        isDragging=true;
                      });
                    },
                    onDragExited: (details){
                      setState(() {
                        isDragging=false;
                      });
                    },
                    onDragDone: (details){
                      final List<String>filePaths=details.files.map((file)=>file.path).toList();
                      context.read<VideoConverterBloc>().add(DropFilesEvent(filePaths));
                    },

                    child: Container(
                      height: screenHeight*0.16,
                      child: Card(
                        color: Colors.white,
                        child: isDragging? const Center(
                          child: Text(
                            'Drag and drop files here',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        )
                        :ListView.separated(
                          itemCount: state is FilesPickedState ? state.files.length : 0,
                          separatorBuilder: (context, index) => const Divider(), // Divider between items
                          itemBuilder: (context, index) {
                            if(state is FilesPickedState){
                              log('total files = ${totalFiles.toString()}');
                              return ListTile(
                                title: Text(state.files[index]),
                              );
                            }

                          },
                        ),
                      ),
                    ),
                  ),
                  /*
                  Container(
                    height: screenHeight*0.16,
                    child: Card(
                      color: Colors.white,
                      child: ListView.separated(
                        itemCount: state is FilesPickedState ? state.files.length : 0,
                        separatorBuilder: (context, index) => const Divider(), // Divider between items
                        itemBuilder: (context, index) {
                          if(state is FilesPickedState){
                            log('total files = ${totalFiles.toString()}');
                            return ListTile(
                              title: Text(state.files[index]),
                            );
                          }

                        },
                      ),
                    ),
                  ),

                   */
                  SizedBox(height: screenHeight*0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: (){
                        final targetFormat=widget.selectedFormatNotifier.value;
                        if(targetFormat!=null && state is FilesPickedState){
                          context.read<VideoConverterBloc>().add(ConvertFilesEvent(state.files, targetFormat,widget.copyMethod.value));
                        }

                      },
                      label: Text('Submit'),
                      icon: Icon(Icons.send_outlined),
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
