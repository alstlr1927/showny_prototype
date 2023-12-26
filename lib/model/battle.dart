class BattleModel {
  Player player1;
  Player player2;
  String winId;

  BattleModel({
    required this.player1,
    required this.player2,
    required this.winId,
  });

  factory BattleModel.fromJson(Map<String, dynamic> json) {
    return BattleModel(
      player1: Player.fromJson(json['player_1'] as Map<String, dynamic>),
      player2: Player.fromJson(json['player_2'] as Map<String, dynamic>),
      winId: json['win_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_1': player1.toJson(),
      'player_2': player2.toJson(),
      'win_id': winId,
    };
  }
}

class Player {
  String name;
  String image;

  Player({
    required this.name,
    required this.image,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
    };
  }
}
