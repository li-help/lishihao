class UserModel {
  final String avatar;
  final String nickName;
  final String userId;
  final int points;
  final int collectCount;
  final int viewCount;

  const UserModel({
    this.avatar = '',
    this.nickName = '用户',
    this.userId = '',
    this.points = 0,
    this.collectCount = 0,
    this.viewCount = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      avatar: json['avatar'] as String? ?? '',
      nickName: json['nickName'] as String? ?? '用户',
      userId: json['userId'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      collectCount: json['collectCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
    );
  }

  static const UserModel defaultUser = UserModel();
}
