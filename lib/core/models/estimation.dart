class Estimation {
  final List<EstimationItem> items;
  final List<String> assumptions;
  final List<String> suggestions;

  Estimation({
    required this.items,
    required this.assumptions,
    required this.suggestions,
  });

  double get totalCost => items.fold(0.0, (sum, item) => sum + item.totalCost);

  factory Estimation.fromJson(Map<String, dynamic> json) {
    final List<EstimationItem> items = [];
    for (var item in (json['items'] as List<dynamic>? ?? [])) {
      if (item is Map<String, dynamic>) {
        items.add(EstimationItem.fromJson(item));
      }
    }

    return Estimation(
      items: items,
      assumptions: List<String>.from(json['assumptions'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}

class EstimationItem {
  final String category;
  final String description;
  final double quantity;
  final double unitCost;
  final double totalCost;

  EstimationItem({
    required this.category,
    required this.description,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });

  factory EstimationItem.fromJson(Map<String, dynamic> json) {
    return EstimationItem(
      category: json['category'] ?? 'Unknown',
      description: json['description'] ?? '',
      quantity: (json['quantity'] ?? 1).toDouble(),
      unitCost: (json['unitCost'] ?? 0).toDouble(),
      totalCost: (json['totalCost'] ?? 0).toDouble(),
    );
  }
}
