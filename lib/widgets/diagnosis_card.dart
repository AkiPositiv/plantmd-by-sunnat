import 'package:flutter/material.dart';
import '../models/diagnosis.dart';

class DiagnosisCard extends StatelessWidget {
  final Diagnosis diagnosis;

  const DiagnosisCard({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Asosiy tashxis / Основной диагноз:'),
            _buildBulletItem(diagnosis.mainDiagnosis),
            if (diagnosis.alternatives.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Alternativlar / Альтернативы:'),
              ...diagnosis.alternatives.map(_buildBulletItem),
            ],
            const Divider(height: 32),
            _buildSectionTitle('Tavsif / Описание:'),
            Text(diagnosis.description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            _buildSectionTitle('Davolash / Лечение:'),
            ...diagnosis.treatmentSteps.map(_buildStepItem),
            if (diagnosis.preventionTips.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionTitle('Oldini olish / Профилактика:'),
              ...diagnosis.preventionTips.map(_buildStepItem),
            ],
            if (diagnosis.warnings.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildWarnings(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 7, color: Color(0xFF388E3C)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF388E3C), fontSize: 16)),
          Expanded(child: Text(step, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildWarnings() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ogohlantirishlar / Предупреждения:',
            style: TextStyle(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...diagnosis.warnings
              .map((w) => Text('⚠️ $w', style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
