import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';

/// Heuristic field extraction from OCR text (offline, no network).
class OcrFieldExtractor {
  const OcrFieldExtractor();

  List<OcrExtractedField> extract(OcrScanType type, OcrRawResult raw) {
    final text = raw.fullText;
    return switch (type) {
      OcrScanType.vaccinationCard => _vaccination(text),
      OcrScanType.prescription => _prescription(text),
      OcrScanType.diagnosticReport => _diagnostic(text),
    };
  }

  List<OcrExtractedField> _vaccination(String text) {
    final fields = <OcrExtractedField>[];
    final vaccine = _firstMatch(text, _vaccinePatterns);
    if (vaccine != null) {
      fields.add(_field(
        OcrFieldKeys.vaccineName,
        'ocrFieldVaccineName',
        vaccine.$1,
        vaccine.$2,
        text,
        confidence: 0.85,
      ));
    }
    final dose = _labeledValue(
      text,
      labels: const ['dose', 'ডোজ', 'booster'],
      valuePattern: RegExp(
        r'(dose\s*[:=]?\s*)([0-9]+(?:st|nd|rd|th)?|I{1,3}|primary|booster)',
        caseSensitive: false,
      ),
    );
    if (dose != null) {
      fields.add(_field(
        OcrFieldKeys.doseLabel,
        'ocrFieldDose',
        dose.$1,
        dose.$2,
        text,
      ));
    }
    final date = _findDate(text);
    if (date != null) {
      fields.add(_field(
        OcrFieldKeys.givenDate,
        'ocrFieldGivenDate',
        date.$1,
        date.$2,
        text,
        confidence: 0.8,
      ));
    }
    final batch = _labeledValue(
      text,
      labels: const ['batch', 'lot', 'ব্যাচ'],
      valuePattern: RegExp(
        r'(?:batch|lot|ব্যাচ)\s*(?:no\.?|number|#)?\s*[:=]?\s*([A-Za-z0-9\-\/]+)',
        caseSensitive: false,
      ),
    );
    if (batch != null) {
      fields.add(_field(
        OcrFieldKeys.batchNumber,
        'ocrFieldBatch',
        batch.$1,
        batch.$2,
        text,
      ));
    }
    final clinic = _labeledValue(
      text,
      labels: const ['clinic', 'hospital', 'centre', 'center', 'ক্লিনিক', 'হাসপাতাল'],
      valuePattern: RegExp(
        r'(?:clinic|hospital|centre|center|ক্লিনিক|হাসপাতাল)\s*[:=]?\s*(.+)',
        caseSensitive: false,
      ),
    );
    if (clinic != null) {
      fields.add(_field(
        OcrFieldKeys.clinicName,
        'ocrFieldClinic',
        _trimLine(clinic.$1),
        clinic.$2,
        text,
        confidence: 0.55,
      ));
    }
    return fields;
  }

  List<OcrExtractedField> _prescription(String text) {
    final fields = <OcrExtractedField>[];
    final med = _firstMatch(text, _medicinePatterns) ??
        _firstMedicineLine(text);
    if (med != null) {
      fields.add(_field(
        OcrFieldKeys.medicineName,
        'ocrFieldMedicineName',
        med.$1,
        med.$2,
        text,
        confidence: 0.8,
      ));
    }
    final strength = _firstMatch(
      text,
      [
        RegExp(r'\b(\d+(?:\.\d+)?\s?(?:mg|mcg|g|ml|IU))\b', caseSensitive: false),
      ],
    );
    if (strength != null) {
      fields.add(_field(
        OcrFieldKeys.strength,
        'ocrFieldStrength',
        strength.$1,
        strength.$2,
        text,
      ));
    }
    final dosage = _labeledValue(
      text,
      labels: const ['dosage', 'dose', 'sig', 'ডোজ'],
      valuePattern: RegExp(
        r'(?:dosage|dose|sig|ডোজ)\s*[:=]?\s*(.+)',
        caseSensitive: false,
      ),
    );
    if (dosage != null) {
      fields.add(_field(
        OcrFieldKeys.dosage,
        'ocrFieldDosage',
        _trimLine(dosage.$1),
        dosage.$2,
        text,
      ));
    }
    final freq = _firstMatch(
      text,
      [
        RegExp(
          r'\b((?:once|twice|thrice)\s+daily|every\s+\d+\s+hours?|১\s*বার|২\s*বার|৩\s*বার|od|bd|tds|qid)\b',
          caseSensitive: false,
        ),
      ],
    );
    if (freq != null) {
      fields.add(_field(
        OcrFieldKeys.frequency,
        'ocrFieldFrequency',
        freq.$1,
        freq.$2,
        text,
      ));
    }
    final doctor = _labeledValue(
      text,
      labels: const ['dr', 'doctor', 'prescribed by', 'ডা'],
      valuePattern: RegExp(
        r'(?:dr\.?|doctor|prescribed by|ডা\.?)\s*[:=]?\s*([A-Za-z.\s]+)',
        caseSensitive: false,
      ),
    );
    if (doctor != null) {
      fields.add(_field(
        OcrFieldKeys.prescribedBy,
        'ocrFieldPrescribedBy',
        _trimLine(doctor.$1),
        doctor.$2,
        text,
        confidence: 0.7,
      ));
    }
    final date = _findDate(text);
    if (date != null) {
      fields.add(_field(
        OcrFieldKeys.startDate,
        'ocrFieldStartDate',
        date.$1,
        date.$2,
        text,
      ));
    }
    return fields;
  }

  List<OcrExtractedField> _diagnostic(String text) {
    final fields = <OcrExtractedField>[];
    final titleMatch = _firstMatch(text, _reportTitlePatterns);
    if (titleMatch != null) {
      fields.add(_field(
        OcrFieldKeys.documentTitle,
        'ocrFieldDocumentTitle',
        titleMatch.$1,
        titleMatch.$2,
        text,
        confidence: 0.75,
      ));
    } else {
      final fallback = text
          .split('\n')
          .map((l) => l.trim())
          .firstWhere((l) => l.length > 3, orElse: () => 'Diagnostic report');
      fields.add(_field(
        OcrFieldKeys.documentTitle,
        'ocrFieldDocumentTitle',
        fallback,
        text.indexOf(fallback).clamp(0, text.length),
        text,
        confidence: 0.4,
      ));
    }
    final date = _findDate(text);
    if (date != null) {
      fields.add(_field(
        OcrFieldKeys.documentDate,
        'ocrFieldDocumentDate',
        date.$1,
        date.$2,
        text,
      ));
    }
    final facility = _labeledValue(
      text,
      labels: const ['lab', 'laboratory', 'hospital', 'diagnostic', 'ল্যাব'],
      valuePattern: RegExp(
        r'(?:lab(?:oratory)?|hospital|diagnostic|ল্যাব)\s*[:=]?\s*(.+)',
        caseSensitive: false,
      ),
    );
    if (facility != null) {
      fields.add(_field(
        OcrFieldKeys.facility,
        'ocrFieldFacility',
        _trimLine(facility.$1),
        facility.$2,
        text,
      ));
    }
    final findings = _collectFindings(text);
    if (findings != null) {
      fields.add(_field(
        OcrFieldKeys.findings,
        'ocrFieldFindings',
        findings.$1,
        findings.$2,
        text,
        confidence: 0.5,
      ));
    }
    return fields;
  }

  static final _vaccinePatterns = <RegExp>[
    RegExp(
      r'\b(BCG|HepB|Hepatitis\s*B|OPV|IPV|DTP|DTaP|Tdap|Hib|PCV|PCV13|PCV10|'
      r'MMR|MR|Varicella|Rotavirus|Typhoid|JE|COVID(?:-?19)?|'
      r'Influenza|Flu|HPV|Pentavalent|Measles|Polio)\b',
      caseSensitive: false,
    ),
    RegExp(r'(বিসিজি|হেপাটাইটিস|পোলিও|হাম|রুবেলা|কোভিড)'),
  ];

  static final _medicinePatterns = <RegExp>[
    RegExp(
      r'\b(Paracetamol|Acetaminophen|Amoxicillin|Azithromycin|Ibuprofen|'
      r'Cetirizine|ORS|Zinc|Vitamin\s*D|Salbutamol|Omeprazole|'
      r'Napa|Ace|Seclo|Fexo|Allegra|Montair)\b',
      caseSensitive: false,
    ),
    RegExp(r'(প্যারাসিটামল|অ্যামোক্সিসিলিন|জিঙ্ক|ও আর এস)'),
  ];

  static final _reportTitlePatterns = <RegExp>[
    RegExp(
      r'\b(CBC|Complete Blood Count|Blood Report|Urine (?:R/?E|Routine)|'
      r'X-?Ray|Ultrasound|USG|MRI|CT Scan|Pathology Report|'
      r'Diagnostic Report|Lab Report)\b',
      caseSensitive: false,
    ),
    RegExp(r'(রক্ত পরীক্ষা|প্রস্রাব|এক্স-রে|আল্ট্রাসাউন্ড)'),
  ];

  (String, int)? _firstMatch(String text, List<RegExp> patterns) {
    for (final pattern in patterns) {
      final m = pattern.firstMatch(text);
      if (m != null) {
        final value = (m.groupCount >= 1 ? m.group(1) : m.group(0))?.trim();
        if (value != null && value.isNotEmpty) {
          return (value, m.start);
        }
      }
    }
    return null;
  }

  (String, int)? _firstMedicineLine(String text) {
    for (final line in text.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.length < 3) continue;
      if (RegExp(r'tab\.?|cap\.?|syrup|susp|mg|ml', caseSensitive: false)
          .hasMatch(trimmed)) {
        final cleaned = trimmed.replaceFirst(RegExp(r'^[\-\*\d\.\)\s]+'), '');
        return (cleaned, text.indexOf(trimmed));
      }
    }
    return null;
  }

  (String, int)? _labeledValue(
    String text, {
    required List<String> labels,
    required RegExp valuePattern,
  }) {
    final m = valuePattern.firstMatch(text);
    if (m == null) return null;
    final value = (m.groupCount >= 1 ? m.group(m.groupCount) : m.group(0))
        ?.trim();
    if (value == null || value.isEmpty) return null;
    // Ensure at least one label token appears nearby for weak patterns.
    final window = text
        .substring(
          (m.start - 24).clamp(0, text.length),
          (m.end + 8).clamp(0, text.length),
        )
        .toLowerCase();
    final hit = labels.any((l) => window.contains(l.toLowerCase()));
    if (!hit && m.groupCount < 1) return null;
    return (value, m.start);
  }

  (String, int)? _findDate(String text) {
    final patterns = [
      RegExp(
        r'\b(\d{1,2}[\/\-.\s]\d{1,2}[\/\-.\s]\d{2,4})\b',
      ),
      RegExp(
        r'\b(\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{2,4})\b',
        caseSensitive: false,
      ),
      RegExp(
        r'\b((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{1,2},?\s+\d{2,4})\b',
        caseSensitive: false,
      ),
    ];
    return _firstMatch(text, patterns);
  }

  (String, int)? _collectFindings(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .where(
          (l) => RegExp(
            r'hemoglobin|wbc|rbc|platelet|result|finding|impression|হেমোগ্লোবিন',
            caseSensitive: false,
          ).hasMatch(l),
        )
        .take(5)
        .toList();
    if (lines.isEmpty) return null;
    final joined = lines.join('\n');
    return (joined, text.indexOf(lines.first));
  }

  String _trimLine(String value) {
    final line = value.split('\n').first.trim();
    return line.length > 80 ? '${line.substring(0, 80)}…' : line;
  }

  OcrExtractedField _field(
    String key,
    String labelKey,
    String value,
    int start,
    String fullText, {
    double confidence = 0.65,
  }) {
    final end = (start + value.length).clamp(0, fullText.length);
    return OcrExtractedField(
      key: key,
      labelKey: labelKey,
      value: value,
      matchedText: value,
      confidence: confidence,
      sourceStart: start,
      sourceEnd: end,
    );
  }
}
