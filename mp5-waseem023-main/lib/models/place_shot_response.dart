

class PlaceShotResponse {
  final String message;
  final bool sunkShip;
  final bool won;
  PlaceShotResponse({
    required this.message,
    required this.sunkShip,
    required this.won,
  });



  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sunk_ship': sunkShip,
      'won': won,
    };
  }

  factory PlaceShotResponse.fromJson(Map<String, dynamic> map) {
    return PlaceShotResponse(
      message: map['message'] ?? '',
      sunkShip: map['sunk_ship'] ?? false,
      won: map['won'] ?? false,
    );
  }


  @override
  String toString() => message;

}