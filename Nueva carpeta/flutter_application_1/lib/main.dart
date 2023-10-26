import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camara y Galeria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Camara y Galeria'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _images = []; // Lista para almacenar múltiples fotos
  int _selectedImageIndex = -1;

  Future _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  void _clearImage(int index) {
    setState(() {
      _images.removeAt(index);
      _selectedImageIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt), text: "Cámara"),
              Tab(icon: Icon(Icons.photo), text: "Galería"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera),
                    child: Text("Tomar Foto"),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  if (_selectedImageIndex >= 0)
                    Image.file(_images[_selectedImageIndex]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedImageIndex >= 0)
                        ElevatedButton(
                          onPressed: () => _clearImage(_selectedImageIndex),
                          child: Text("Borrar Foto"),
                        ),
                      ElevatedButton(
                        onPressed: () => _selectedImageIndex = -1,
                        child: Text("Regresar"),
                      ),
                    ],
                  ),
                  if (_images.isEmpty)
                    Text("No se ha seleccionado ninguna foto."),
                  if (_images.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Image.file(_images[index]),
                            onTap: () {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                          );
                        },
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