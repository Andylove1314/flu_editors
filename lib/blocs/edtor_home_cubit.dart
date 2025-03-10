import 'package:equatable/equatable.dart';
import 'package:flu_editor/utils/editor_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../flu_editor.dart';

part 'editor_home_state.dart';

class EditorHomeCubit extends Cubit<EditorHomeState> {
  bool saved = false;

  EditorHomeCubit(String orignalPath) : super(EditorHomeState(orignalPath));

  Future<String> getSaveImagePath() async {
    // await EditorUtil.saveCallback?.call(state.afterPath);
    saved = true;
    return state.afterPath;
  }

  Future<void> toEditor(BuildContext context, EditorType type,
      [String? subGroupId]) async {
    saved = false;
    if (type == EditorType.crop) {
      EditorUtil.goCropPage(context, state.afterPath);
    } else if (type == EditorType.colors) {
      EditorUtil.goColorsPage(context, state.afterPath);
    } else if (type == EditorType.filter) {
      if (EditorUtil.filterList.isEmpty) {
        await EditorUtil.fetchFilterList(context);
      }
      final index = EditorUtil.filterList
          .indexWhere((element) => element.id.toString() == subGroupId);
      if (index != -1) {
        EditorUtil.goFilterPage(context, state.afterPath, index);
      } else {
        EditorUtil.goFilterPage(context, state.afterPath);
      }
    } else if (type == EditorType.blur) {
      EditorUtil.showToast('功能开发中...');
      // ... todo
    } else if (type == EditorType.sticker) {
      if (EditorUtil.stickerList.isEmpty) {
        await EditorUtil.fetchStickerList(context);
      }
      final index = EditorUtil.stickerList
          .indexWhere((element) => element.id.toString() == subGroupId);
      if (index != -1) {
        EditorUtil.goStickerPage(context, state.afterPath, index);
      } else {
        EditorUtil.goStickerPage(context, state.afterPath);
      }
    } else if (type == EditorType.text) {
      if (EditorUtil.fontList.isEmpty) {
        await EditorUtil.fetchFontList(context);
      }
      final index = EditorUtil.fontList
          .indexWhere((element) => element.id.toString() == subGroupId);
      if (index != -1) {
        EditorUtil.goFontPage(context, state.afterPath, index);
      } else {
        EditorUtil.goFontPage(context, state.afterPath);
      }
    } else if (type == EditorType.frame) {
      if (EditorUtil.frameList.isEmpty) {
        await EditorUtil.fetchFrameList(context);
      }
      final index = EditorUtil.frameList
          .indexWhere((element) => element.id.toString() == subGroupId);
      if (index != -1) {
        EditorUtil.goFramePage(context, state.afterPath, index);
      } else {
        EditorUtil.goFramePage(context, state.afterPath);
      }
    }
  }
}
