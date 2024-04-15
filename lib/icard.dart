import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class User {
  late String name = '';
  late String address = '';
  late String email = '';
  late String phone = '';
  String rollNumber = 'FIB-001'; // Initialize with the first roll number

  void generateRollNumber() {
    // Implement logic to generate the roll number here
    // You can update the roll number as needed
  }
}

final ScreenshotController screenshotController = ScreenshotController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserCard(),
    );
  }
}

class UserCard extends StatefulWidget {
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final User user = User();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCardVisible = false; // Add a flag to control the card visibility
  XFile? _userImage;

  void _resetForm() {
    setState(() {
      user.name = '';
      user.address = '';
      user.email = '';
      user.phone = '';
      user.rollNumber = 'FIB-001';
      _userImage = null; // Clear the selected image
      isCardVisible = false; // Hide the card
    });
  }

  Future<void> _showImageSourceOptions() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _userImage = XFile(pickedFile.path);
      });
    }
  }

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
        title: const Text('User ID Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // _captureAndShare();
            },
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.credit_card_rounded,
                  size: 3,
                ),
              )
            ],
          )
        ],
        backgroundColor: const Color(0xff000000),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Move the ID card up by adding padding at the top
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Card(
                  elevation: 4,
                  color: Color(0xff000000),
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 0.9],
                          colors: [
                            Colors.lightGreen,
                            Colors.white,
                          ],
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),

                      // child: Center(
                      //   child: Text(
                      //     'ID Card',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 24.0,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),              child :Container(
                      width: 5 * 72.0, // 3 inches
                      height: 3 * 77.0, // 5 inches
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: 30,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black54,
                                    Colors.black38
                                  ],
                                  stops: [
                                    0.1,
                                    1.0,
                                    1.0,
                                  ],
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'FIBTION INFOTECH',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          // Text(
                          //   'ID Card',
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showImageSourceOptions();
                                    },
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: _userImage != null
                                          ? FileImage(File(_userImage!.path))
                                          : null, // Display the selected image or null
                                      child: _userImage == null
                                          ? Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey,
                                            ) // Display the camera icon as a fallback
                                          : null,
                                    ),
                                  )

                                  // Replace with your profile image
                                  ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Container(
                                  width:
                                      1, // Set the width to the desired thickness of the divider
                                  height:
                                      160, // Set the height to the desired height of the divider
                                  color: Colors
                                      .black, // Set the color to the desired color of the divider
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                flex: 15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 19,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Name : ',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${user.name}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Phone : ',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${user.phone ?? ''}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Email : ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${user.email}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Add : ',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${user.address}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Code : ',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${user.rollNumber}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // User's Name
                    TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        user.name = value!;
                      },
                    ),
                    // User's Address
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Address'),
                      onSaved: (value) {
                        user.address = value!;
                      },
                    ),
                    // User's Email
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        user.email = value!;
                      },
                    ),
                    // User's Phone Number
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        user.phone = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _resetForm, // Call a function to reset the form
                          child: Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              user.generateRollNumber();
                              setState(() {
                                isCardVisible =
                                    true; // Show the card after details are entered
                              });
                            }
                          },
                          child: const Text('Generate ID Card'),
                        ),
                        ElevatedButton(
                          onPressed: _captureAndShare,
                          child: const Text('Share ID Card'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
