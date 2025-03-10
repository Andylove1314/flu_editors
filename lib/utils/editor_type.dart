import 'package:flutter/widgets.dart';

enum EditorType { 
  crop, colors, filter, blur, sticker, text, frame;
  
  // 获取枚举的字符串表示
  String get name {
    return toString().split('.').last;
  }
  
  // 静态方法：从字符串获取 EditorType
  static EditorType? fromString(String? groupName) {
    if (groupName == null) return null;
    
    switch (groupName.toLowerCase()) {
      case 'crop':
        return EditorType.crop;
      case 'colors':
        return EditorType.colors;
      case 'filter':
        return EditorType.filter;
      case 'blur':
        return EditorType.blur;
      case 'sticker':
        return EditorType.sticker;
      case 'text':
        return EditorType.text;
      case 'frame':
        return EditorType.frame;
      default:
        debugPrint('未找到匹配的 EditorType: $groupName');
        return null;
    }
  }
}