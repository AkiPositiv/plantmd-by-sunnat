class Diagnosis {
  final String mainDiagnosis;
  final List<String> alternatives;
  final String description;
  final List<String> treatmentSteps;
  final List<String> warnings;
  final List<String> preventionTips;

  Diagnosis({
    required this.mainDiagnosis,
    required this.alternatives,
    required this.description,
    required this.treatmentSteps,
    required this.warnings,
    required this.preventionTips,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      mainDiagnosis: json['main_diagnosis'] ?? '',
      alternatives: List<String>.from(json['alternatives'] ?? []),
      description: json['description'] ?? '',
      treatmentSteps: List<String>.from(json['treatment_steps'] ?? []),
      warnings: List<String>.from(json['warnings'] ?? []),
      preventionTips: List<String>.from(json['prevention_tips'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'main_diagnosis': mainDiagnosis,
    'alternatives': alternatives,
    'description': description,
    'treatment_steps': treatmentSteps,
    'warnings': warnings,
    'prevention_tips': preventionTips,
  };
}