class GenerateActivityUsecase {
  Future<List<DateTime>> call() async {
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 365));
    return List.generate(365, (i) => startDate.add(Duration(days: i)));
  }
}
