class ConsentStatus {
  static String all = 'ALL';
  static String requested = 'REQUESTED';
  static String denied = 'DENIED';
  static String granted = 'GRANTED';
  static String revoked = 'REVOKED';
  static String expired = 'EXPIRED';
}

final List<String> hiTypes = [
  'Diagnostic Report',
  'Prescription',
  'Immunization Record',
  'Discharge Summary',
  'OP Consultation',
  'Health Document Record',
  'Wellness Record',
];

final List<String> hiTypesCode = [
  'DiagnosticReport',
  'Prescription',
  'ImmunizationRecord',
  'DischargeSummary',
  'OPConsultation',
  'HealthDocumentRecord',
  'WellnessRecord',
];

final List<String> visitTypes = ['New', 'Existing'];
