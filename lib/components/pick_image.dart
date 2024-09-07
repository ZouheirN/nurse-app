import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final String label;
  final String text;
  final String imagePath;
  final void Function(File? image)? onImageSelected;

  const PickImage({
    super.key,
    required this.label,
    this.text = 'Upload Image from gallery',
    this.imagePath = 'assets/images/image-gallery.png',
    this.onImageSelected,
  });

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              width: 85,
              height: 85,
            ),
          if (_selectedImage != null) const SizedBox(height: 3),
          InkWell(
            onTap: _pickImageFromGallery,
            child: Row(
              children: [
                Image.asset(
                  widget.imagePath,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_selectedImage);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }
}
