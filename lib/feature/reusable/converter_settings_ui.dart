import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConverterSettingsUi extends StatefulWidget {
  final ValueNotifier<String?> selectedFormatNotifier;
  final ValueNotifier<bool?> copyMethod;
  const ConverterSettingsUi({super.key,required this.selectedFormatNotifier, required this.copyMethod});

  @override
  _ConverterSettingState createState() => _ConverterSettingState();
}

class _ConverterSettingState extends State<ConverterSettingsUi> {
  String? selectedValue;
  final List<String> options = ['MP4', 'MKV', 'FLV','TS','MOV'];
  bool isCopyEnabled=true;

  void _showInfoDialog() {
    String infoMessage =
        'The "Copy" option allows you to duplicate the audio and video streams without re-encoding. '
        'This means faster conversion and no loss of quality. The video codec will remain as original, '
        'and the audio codec will remain as original. Only the file format will change, ensuring compatibility '
        'with your desired output format.\n'
        'When the "Copy" option is disabled, the video codec will be changed to H.264 (libx264) '
        'and the audio codec will be changed to AAC. This may take longer, but it allows for better compatibility '
        'with the target format and ensures the output meets quality standards.';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings Description'),
          content: Text(infoMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth=MediaQuery.of(context).size.width;
    final double screenHeight=MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
      width: screenWidth*0.4,
      height: screenHeight*0.5,
      child: Card(
        elevation: 20,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: screenWidth*0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //CoLUMN 1
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 30,

                  ),
                ),
              ),
              //Column 2
              Row(
                children: [
                  Text(
                      'Target format'
                  ),
                  SizedBox(width: 8.0), // Optional: Add spacing between the Text and TextFormField
                  DropdownButton<String>(
                    hint: Text('Select a format'),
                    value: widget.selectedFormatNotifier.value,
                    items: options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        //selectedValue=value;
                        widget.selectedFormatNotifier.value=value;
                      });
                    },
                  ),
                ],
              ),
              //Column 3
              Row(
                children: [
                  Text(
                      'Copy'
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: (){
                      _showInfoDialog();
                    },
                    icon: Icon(Icons.info_outline_rounded),
                  ),
                  SizedBox(width: 8.0),

                  Switch(
                    value: widget.copyMethod.value ?? false,
                    onChanged: (value){
                      setState(() {
                        //isCopyEnabled=value;
                        widget.copyMethod.value=value;
                        log(widget.copyMethod.value.toString());
                      });
                    },
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
