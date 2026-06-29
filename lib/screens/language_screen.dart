import 'package:flutter/material.dart';
import 'input_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, size: 80, color: Colors.green[800]),
              const SizedBox(height: 16),
              Text(
                'PlantMD',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tilni tanlang / Выберите язык',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 48),
              _LanguageButton(
                text: 'Русский',
                color: Colors.green[800]!,
                onTap: () => _navigate(context, 'ru'),
              ),
              const SizedBox(height: 16),
              _LanguageButton(
                text: "O'zbekcha",
                color: Colors.teal[700]!,
                onTap: () => _navigate(context, 'uz'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String lang) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => InputScreen(language: lang)),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
