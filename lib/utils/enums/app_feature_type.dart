enum AppFeatureType {
  codeReview('Code Review'),
  codeDocGeneration('Code Documentation'),
  codeComplexityAnalysis('Code Complexity Analysis');

  final String label; // custom property

  const AppFeatureType(this.label); // constructor
}
