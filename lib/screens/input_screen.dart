import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/image_picker.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  final String language;

  const InputScreen({super.key, required this.language});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<File> _images = [];
  final TextEditingController _symptomsController = TextEditingController();
  bool _isLoading = false;

  bool get _isRussian => widget.language == 'ru';

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRussian
                ? 'Пожалуйста, добавьте хотя бы одно фото'
                : 'Iltimos, kamida bitta rasm qoʻshing',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService().getDiagnosis(
        images: _images,
        symptoms: _symptomsController.text,
        language: widget.language,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            images: _images,
            description: _symptomsController.text,
            analysisResult: result,
            language: widget.language,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(_isRussian ? 'Ошибка!' : 'Xato!'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isRussian ? 'Диагностика растений' : 'Oʻsimlik Diagnostikasi',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ImagePickerWidget(
                          language: widget.language,
                          onImagesSelected: (imgs) =>
                              setState(() => _images = imgs),
                        ),
                        const SizedBox(height: 20),
                        _buildSymptomsInput(),
                      ],
                    ),
                  ),
                  _buildAnalyzeButton(),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4CAF50),
                    strokeWidth: 5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isRussian ? 'Опишите симптомы:' : 'Alomatlarni tasvirlang:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _symptomsController,
          maxLines: 5,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: _isRussian
                ? 'Например: коричневые пятна на листьях, увядание...'
                : 'Masalan: barglarda jigarrang dogʻlar, soʻlish...',
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.analytics, size: 24),
          label: Text(
            _isRussian ? 'Анализировать' : 'Tahlil qilish',
            style: const TextStyle(fontSize: 18),
          ),
          onPressed: _isLoading ? null : _analyze,
        ),
      ),
    );
  }
}
