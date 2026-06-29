import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/secrets.dart';

class ApiService {
  static const _apiKey = geminiApiKey;
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Future<String> getDiagnosis({
    required List<File> images,
    required String symptoms,
    required String language,
  }) async {
    final imageBytes = await Future.wait(images.map((f) => f.readAsBytes()));

    final prompt =
        language == 'uz' ? _uzbekPrompt(symptoms) : _russianPrompt(symptoms);

    final parts = <Map<String, dynamic>>[
      {'text': prompt},
      for (final bytes in imageBytes)
        {
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': base64Encode(bytes),
          },
        },
    ];

    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': parts},
        ],
        'generationConfig': {'maxOutputTokens': 2000},
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final msg = body['error']?['message'] ?? response.statusCode.toString();
      final label = language == 'uz' ? 'API xatosi' : 'Ошибка API';
      throw Exception('$label: $msg');
    }

    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final content =
        body['candidates'][0]['content']['parts'][0]['text'] as String;

    return content
        .replaceAll(RegExp(r'\*\*'), '')
        .replaceAll(RegExp(r'\*'), '')
        .replaceAll(RegExp(r'^#{1,3} ?', multiLine: true), '')
        .replaceAll('__', '')
        .trim();
  }

  String _uzbekPrompt(String symptoms) {
    final extra =
        symptoms.isNotEmpty ? '\n2. Foydalanuvchi tavsifi: "$symptoms"' : '';
    return '''
Siz tajribali agronomsiz. Quyidagi ma\'lumotlarni tahlil qiling:
1. Yuklangan rasmlar$extra

Quyidagi strukturada javob bering:
- Asosiy tashxis (ehtimollik foizi bilan)
- Qo\'shimcha tashxis variantlari (agar mavjud bo\'lsa)
- Kasallik haqida qisqacha ma\'lumot
- Davolash usullari (bosqichma-bosqich)
- Oldini olish choralari
- Ogohlantirishlar (zarur bo\'lsa)

Agar bir nechta kasallik belgilari mavjud bo\'lsa, har birining ehtimollik foizini ko\'rsating.
Javobingiz aniq va tushunarli bo\'lsin.''';
  }

  String _russianPrompt(String symptoms) {
    final extra =
        symptoms.isNotEmpty ? '\n2. Описание симптомов: "$symptoms"' : '';
    return '''
Вы опытный агроном. Проанализируйте данные:
1. Загруженные фотографии растений$extra

Сформируйте ответ по структуре:
- Основной диагноз (с указанием вероятности в %)
- Альтернативные диагнозы (при наличии)
- Краткое описание заболевания
- Методы лечения (пошагово)
- Меры профилактики
- Предупреждения (если необходимы)

При наличии нескольких возможных заболеваний укажите процент вероятности для каждого.
Ответ должен быть чётким и структурированным.''';
  }
}
