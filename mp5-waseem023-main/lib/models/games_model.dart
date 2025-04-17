



class Game {
  final int id;
  final String player1;
  final String player2;
  final int position;
  final int status;
  final int turn;
  Game({
    required this.id,
    required this.player1,
    required this.player2,
    required this.position,
    required this.status,
    required this.turn,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1': player1,
      'player2': player2,
      'position': position,
      'status': status,
      'turn': turn,
    };
  }

  factory Game.fromJson(Map<String, dynamic> map) {
    return Game(
      id: map['id']?.toInt() ?? 0,
      player1: map['player1'] ?? '',
      player2: map['player2'] ?? '',
      position: map['position']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      turn: map['turn']?.toInt() ?? 0,
    );
  }


  @override
  String toString() => '$id $player1 vs $player2';
}

