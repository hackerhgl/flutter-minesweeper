class Cell {
  final int x;
  final int y;
  final bool isBomb;
  final bool isRevealed;
  final int count;
  Cell({
    required this.x,
    required this.y,
    required this.isBomb,
    this.isRevealed = false,
    required this.count,
  });

  Cell copyWith({
    int? x,
    int? y,
    bool? isBomb,
    bool? isRevealed,
    int? count,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      isBomb: isBomb ?? this.isBomb,
      isRevealed: isRevealed ?? this.isRevealed,
      count: count ?? this.count,
    );
  }
}
