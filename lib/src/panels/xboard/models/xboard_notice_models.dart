// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_notice_models.freezed.dart';
part 'xboard_notice_models.g.dart';

// Helper functions for DateTime to Unix timestamp conversion
int? _toUnixTimestamp(int? date) => date; // Already Unix timestamp
int _fromUnixTimestamp(int? timestamp) => timestamp ?? 0; // Return 0 if timestamp is null

// Helper function for 'show' field (bool or int)
bool _showFromJson(dynamic value) {
  if (value is bool) {
    return value;
  } else if (value is int) {
    return value == 1;
  }
  return false; // Default to false if unexpected type
}

dynamic _showToJson(bool value) => value ? 1 : 0;

@freezed
class Notice with _$Notice {
  const factory Notice({
    required int id,
    required String title,
    required String content,
    @JsonKey(fromJson: _showFromJson, toJson: _showToJson)
    required bool show, // Convert to bool
    @JsonKey(name: 'img_url') String? imgUrl,
    List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    required int createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    required int updatedAt,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}

@freezed
class NoticeResponse with _$NoticeResponse {
  const factory NoticeResponse({
    required List<Notice> data, // Renamed from notices to data to match ApiResponse
    required int total,
  }) = _NoticeResponse;

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    // Extract 'data' and 'total' from the nested map
    final dynamic dataField = json['data'];
    
    // Handle case where 'data' might be a List instead of Map
    if (dataField is List) {
      // If data is directly a list of notices
      final List<Notice> notices = dataField
          .map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .toList();
      return NoticeResponse(
        data: notices,
        total: notices.length,
      );
    } else if (dataField is Map<String, dynamic>) {
      // If data is a map containing 'data' array and 'total'
      final Map<String, dynamic> innerData = dataField;
      final List<Notice> notices = (innerData['data'] as List<dynamic>)
          .map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .toList();
      final int totalCount = innerData['total'] as int? ?? notices.length;

      return NoticeResponse(
        data: notices,
        total: totalCount,
      );
    } else {
      // Fallback: empty response
      return const NoticeResponse(
        data: [],
        total: 0,
      );
    }
  }
}