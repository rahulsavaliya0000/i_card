import 'dart:typed_data';
import 'dart:io'; // Import for File class

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Import for getApplicationDocumentsDirectory
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShareExample(),
    );
  }
}

class ShareExample extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();
  void _captureAndShare() {
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        // Save the image to a file (optional)
        final directory = (await getApplicationDocumentsDirectory()).path;
        File file = File('$directory/id_card.png');
        await file.writeAsBytes(image);

        Share.shareFiles(
          [file.path], // Use the file path to share the image
          text: 'Check out my ID card!',
          subject: 'ID Card',
          mimeTypes: ['image/png'],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: IDCard(), // Replace with your ID card widget
            ),
            ElevatedButton(
              onPressed: _captureAndShare,
              child: Text('Share ID Card'),
            ),
          ],
        ),
      ),
    );
  }
}

class IDCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        height: 260.0, // 3 inches
        width: 380.0, // 5 inches
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.white],
          ),
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('FIBTION INFOTECH',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Divider(color: Colors.black),
              Text('ID Card',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.supervised_user_circle_outlined,
                      size: 100,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Name: John Doe',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        Text('Number: +1 234 567 890',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        Text('Email: john.doe@example.com',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        Text('Address: 123 Main St, Anytown',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        Text('Roll No: 123456',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ),
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
