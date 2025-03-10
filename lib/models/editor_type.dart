import 'package:flutter/widgets.dart';

enum EditorType { crop, colors, filter, blur, sticker, text, frame }

extension EditorTypeExtension on EditorType {
  // 获取枚举的字符串表示
  String get name {
    return toString().split('.').last;
  }
  
  // 静态方法：从字符串获取 EditorType
  static EditorType? fromString(String? groupName) {
    if (groupName == null) return null;
    
    try {
      // 尝试将字符串转换为枚举
      return EditorType.values.firstWhere(
        (type) => type.name.toLowerCase() == groupName.toLowerCase(),
        orElse: () => throw Exception('未找到匹配的 EditorType'),
      );
    } catch (e) {
      debugPrint('无法将 $groupName 转换为 EditorType: $e');
      return null;
    }
  }
} 