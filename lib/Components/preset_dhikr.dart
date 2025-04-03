class PresetDhikr {
  static List<Map<String, dynamic>> get morningAdhkar => [
    {
      "title": "Morning Adhkar",
      "phrases": [
        {"text": "Subhanallah", "count": 33, "description": "Glory to Allah"},
        {"text": "Alhamdulillah", "count": 33, "description": "Praise to Allah"},
        {"text": "Allahu Akbar", "count": 34, "description": "Allah is the Greatest"},
      ],
    },
  ];

  static List<Map<String, dynamic>> get eveningAdhkar => [
    {
      "title": "Evening Adhkar",
      "phrases": [
        {"text": "Astaghfirullah", "count": 100, "description": "Seeking Forgiveness"},
        {"text": "La ilaha illallah", "count": 100, "description": "Declaration of Faith"},
      ],
    },
  ];
}