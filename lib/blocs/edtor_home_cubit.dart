import 'package:flu_editor/utils/editor_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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
      [int? subActionIndex]) async {
    saved = false;
    if (type == EditorType.crop) {
      EditorUtil.goCropPage(context, this.state.afterPath);
    } else if (type == EditorType.colors) {
      EditorUtil.goColorsPage(context, this.state.afterPath);
    } else if (type == EditorType.filter) {
      if (EditorUtil.filterList.isEmpty) {
        await EditorUtil.fetchFilterList(context);
      }
      EditorUtil.goFilterPage(context, this.state.afterPath, subActionIndex);
    } else if (type == EditorType.blur) {
      EditorUtil.showToast('功能开发中...');
      // ... todo
    } else if (type == EditorType.sticker) {
      if (EditorUtil.stickerList.isEmpty) {
        await EditorUtil.fetchStickerList(context);
      }
      EditorUtil.goStickerPage(context, this.state.afterPath, subActionIndex);
    } else if (type == EditorType.text) {
      if (EditorUtil.fontList.isEmpty) {
        await EditorUtil.fetchFontList(context);
      }
      EditorUtil.goFontPage(context, this.state.afterPath, subActionIndex);
    } else if (type == EditorType.frame) {
      if (EditorUtil.frameList.isEmpty) {
        await EditorUtil.fetchFrameList(context);
      }
      EditorUtil.goFramePage(context, this.state.afterPath, subActionIndex);
    }
  }
}
