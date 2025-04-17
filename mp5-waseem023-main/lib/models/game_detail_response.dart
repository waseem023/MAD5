class GameDetailsResponse {
  final int id;
  final String player1;
  final String player2;
  final int position;
  final List<String> ships;
  final List<String> shots;
  final int status;
  final List<String> sunk;
  final int turn;
  final List<String> wrecks;
  GameDetailsResponse({
    required this.id,
    required this.player1,
    required this.player2,
    required this.position,
    required this.ships,
    required this.shots,
    required this.status,
    required this.sunk,
    required this.turn,
    required this.wrecks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1': player1,
      'player2': player2,
      'position': position,
      'ships': ships,
      'shots': shots,
      'status': status,
      'sunk': sunk,
      'turn': turn,
      'wrecks': wrecks,
    };
  }

  factory GameDetailsResponse.fromJson(Map<String, dynamic> map) {
    return GameDetailsResponse(
      id: map['id']?.toInt() ?? 0,
      player1: map['player1'] ?? '',
      player2: map['player2'] ?? '',
      position: map['position']?.toInt() ?? 0,
      ships: List<String>.from(map['ships'] ?? []),
      shots: List<String>.from(map['shots'] ?? []),
      status: map['status']?.toInt() ?? 0,
      sunk: List<String>.from(map['sunk'] ?? []),
      turn: map['turn']?.toInt() ?? 0,
      wrecks: List<String>.from(map['wrecks'] ?? []),
    );
  }
}
