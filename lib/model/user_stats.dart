class UserStats {

  UserStats.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    totalScore = json['total_score'];
    attemptLeft = json['attempt_left'];
    maxScore = json['max_score_once'];
    lastScore = json['last_score'];
  }

  String username;
  String name;
  int totalScore;
  int attemptLeft;
  int maxScore;
  int lastScore;
}
