import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String language;
  final Function(List<File>) onImagesSelected;

  const ImagePickerWidget({
    super.key,
    required this.language,
    required this.onImagesSelected,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final List<File> _images = [];
  final _picker = ImagePicker();

  bool get _isRussian => widget.language == 'ru';

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.map((f) => File(f.path)));
      });
      widget.onImagesSelected(List.unmodifiable(_images));
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
    widget.onImagesSelected(List.unmodifiable(_images));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isRussian ? 'Выберите фото:' : 'Rasmlarni tanlang:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _images.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _buildAddButton();
            return _buildImageTile(index - 1);
          },
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: Color(0xFF2E7D32), size: 32),
            const SizedBox(height: 4),
            Text(
              _isRussian ? 'Добавить' : 'Qoʻshish',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(_images[index], fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
