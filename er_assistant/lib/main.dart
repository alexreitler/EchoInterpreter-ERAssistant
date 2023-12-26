import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ImageModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Example',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/second': (context) => const SecondPage(),
      },
    );
  }
}

class ImageModel extends ChangeNotifier {
  String? _selectedImagePath;

  String? get selectedImagePath => _selectedImagePath;

  void setSelectedImagePath(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00001D),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(label: 'A'),
                CustomButton(label: 'B'),
                CustomButton(label: 'C'),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'FULL PROCEDURE',
                style: TextStyle(
                  fontSize: 40.0,
                  color: Color(0xFF00001D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;

  const CustomButton({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('$label button pressed.');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 40.0,
          color: Color(0xFF00001D),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  bool imagePicked = false;
  bool pneumotoraxdetected = false;

  Future<void> _pickImage(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Provider.of<ImageModel>(context, listen: false)
          .setSelectedImagePath(result.files.single.path!);
      sendImageToBackend(result.files.single.path);
    }
  }

  Future<void> sendImageToBackend(String? filePath) async {
    const url = 'http://127.0.0.1:5000/predict'; // modify url...
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('image', filePath!));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var classProbabilities = jsonResponse['class_probabilities'];
        if (classProbabilities == 'normal') {
          setState(() {
            imagePicked = true;

            pneumotoraxdetected = false;
          });
          print('Normal image');
        } else if (classProbabilities == 'pneumothorax') {
          setState(() {
            imagePicked = true;

            pneumotoraxdetected = true;
          });
          print('Pneumothorax detected');
        }
        print('Image processed successfully');
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00001D),
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Image.asset(
                      'assets/images/guideimg.png',
                      height: 545,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Consumer<ImageModel>(
                        builder: (context, imageModel, child) {
                          return imageModel.selectedImagePath != null
                              ? Image.file(
                                  File(imageModel.selectedImagePath!),
                                  height: 545,
                                  fit: BoxFit.cover,
                                )
                              : const Text(
                                  'Waiting for upload...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 30.0,
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 80.0,
              color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 80.0,
                      child: ElevatedButton(
                        onPressed: () => _pickImage(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          'UPLOAD',
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Color(0xFF00001D),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (imagePicked & !pneumotoraxdetected)
                    Expanded(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green,
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          'No abnormalities found',
                          style: TextStyle(
                            color: Color(0xFF00001D),
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                  if (imagePicked & pneumotoraxdetected)
                    Expanded(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.red,
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          'PNEUMOTORAX',
                          style: TextStyle(
                            color: Color(0xFF00001D),
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                  if (!imagePicked)
                    Expanded(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.yellow,
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          'Waiting for uploud..',
                          style: TextStyle(
                            color: Color(0xFF00001D),
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
