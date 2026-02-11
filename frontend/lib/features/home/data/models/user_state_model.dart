class UserStateModel {
  final String userId;
  final int seed;
  final int step;
  final String? currentImageUrl;
  final int maxSaveSlots;
  final int tickets;

  UserStateModel({
    required this.userId,
    required this.seed,
    required this.step,
    this.currentImageUrl,
    required this.maxSaveSlots,
    required this.tickets,
  });

  factory UserStateModel.fromJson(Map<String, dynamic> json) {
    return UserStateModel(
      userId: json['user_id'] as String,
      seed: json['seed'] as int,
      step: json['step'] as int,
      currentImageUrl: json['current_image_url'] as String?,
      maxSaveSlots: json['max_save_slots'] as int,
      tickets: json['tickets'] as int,
    );
  }
}

class ProgressResponseModel {
  final String status;
  final String? beforeUrl;
  final String afterUrl;
  final int newStep;

  ProgressResponseModel({
    required this.status,
    this.beforeUrl,
    required this.afterUrl,
    required this.newStep,
  });

  factory ProgressResponseModel.fromJson(Map<String, dynamic> json) {
    return ProgressResponseModel(
      status: json['status'] as String,
      beforeUrl: json['before_url'] as String?,
      afterUrl: json['after_url'] as String,
      newStep: json['new_step'] as int,
    );
  }
}
