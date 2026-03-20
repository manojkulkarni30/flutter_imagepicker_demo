import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _showOptionsToPickAnImage(BuildContext context) async {
    final imageSource = await showModalBottomSheet<ImageSource>(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (imageSource != null) {
      await _pickAnImage(imageSource);
    }
  }

  Future<void> _pickAnImage(ImageSource source) async {
    try {
      final pickedImage = await _picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    } catch (e) {
      print('Unexpected error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker in Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: .start,
          spacing: 16,
          children: [
            ClipOval(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: .cover,
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: .center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showOptionsToPickAnImage(context);
                  },
                  label: const Text(
                    'Change Avatar',
                    style: TextStyle(fontSize: 16),
                  ),
                  icon: const Icon(Icons.image),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                  label: const Text(
                    'Remove Avatar',
                    style: TextStyle(fontSize: 16),
                  ),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
