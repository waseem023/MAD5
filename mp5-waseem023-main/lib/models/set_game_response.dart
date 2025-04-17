

class SetGameResponse {
  final int id;
  final bool matched;
  final int player;
  SetGameResponse({
    required this.id,
    required this.matched,
    required this.player,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matched': matched,
      'player': player,
    };
  }

  factory SetGameResponse.fromJson(Map<String, dynamic> map) {
    return SetGameResponse(
      id: map['id']?.toInt() ?? 0,
      matched: map['matched'] ?? false,
      player: map['player']?.toInt() ?? 0,
    );
  }

}
