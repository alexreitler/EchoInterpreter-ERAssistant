import 'dart:io';

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
              child: const Text(
                'FULL PROCEDURE',
                style: TextStyle(fontSize: 16.0),
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
        // Add your button click logic here
        print('$label button pressed.');
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 16.0),
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
  Future<void> _pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Provider.of<ImageModel>(context, listen: false)
          .setSelectedImagePath(result.files.single.path!);
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
                            style: TextStyle(color: Colors.white),
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
                    child: ElevatedButton(
                      onPressed: () => _pickImage(context),
                      child: const Text('Upload'),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.red,
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'No abnormalities found',
                        style: TextStyle(color: Colors.white),
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
