import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/second': (context) => const SecondPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00001D),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
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

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF00001D), // Set your desired background color,
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: Image.asset(
                    'assets/images/guideimg.png',
                    //width: double.infinity, // Adjust the width as needed
                    height: 545,
                    //fit: BoxFit.contain, // Adjust the BoxFit as needed
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    //const Text('Waiting for upload...'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        'https://example.com/external_image.jpg',
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Waiting for upload...',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //const Spacer(), // Add Spacer to push yellow bar to the bottom
          Container(
            height: 80.0, // Adjust the height as needed
            color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle file upload logic here
                      // You can use packages like file_picker to implement file selection
                      print('Upload button pressed.');
                    },
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
    );
  }
}
