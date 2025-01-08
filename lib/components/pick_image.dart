import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/consts.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

class PickImage extends StatefulWidget {
  final String label;
  final String text;
  final String? initialImageUrl;
  final void Function(String? imageUrl)? onImageSelected;

  const PickImage({
    super.key,
    required this.label,
    this.text = 'Upload Image from gallery',
    this.initialImageUrl,
    this.onImageSelected,
  });

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _selectedImage;
  String? _imageUrl;
  String status = '';

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

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
          const SizedBox(height: 10),
          if (_selectedImage != null)
            if (kIsWeb)
              Image.network(
                _selectedImage!.path,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              )
            else
              Image.file(
                _selectedImage!,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              )
          else if (_imageUrl != null)
            CachedNetworkImage(
              imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
              imageUrl: _imageUrl!,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 10),
          Text(status),
          const SizedBox(height: 10),
          InkWell(
            onTap: _pickImageFromGallery,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/image-gallery.png',
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
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _imageUrl = null;
        status = 'Uploading image...';
      });
      final imageUrl = await _uploadImage(await pickedImage.readAsBytes());
      if (imageUrl != null) {
        setState(() {
          _imageUrl = imageUrl;
          _selectedImage = null;
          status = 'Image uploaded successfully';
        });
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(imageUrl);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<String?> _uploadImage(Uint8List image) async {
    final Uri uploadUrl =
        Uri.parse('https://api.imgbb.com/1/upload?key=$IMGBB_API_KEY');

    try {
      final request = http.MultipartRequest('POST', uploadUrl)
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            image,
            filename: 'image.jpg',
          ),
        );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        return responseData['data']['url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
