import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flu_editor/models/action_data.dart';
import 'package:flu_editor/utils/editor_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/edtor_home_cubit.dart';
import '../flu_editor.dart';
import '../generated/l10n.dart';
import '../widgets/custom_widget.dart';
import '../widgets/diff/diff_widget.dart';
import '../widgets/main_pan.dart';

class EditorHomePage extends StatelessWidget {
  final String orignal;

  final int? actionIndex;
  final int? subActionIndex;

  const EditorHomePage(
      {super.key,
      required this.orignal,
      this.actionIndex,
      this.subActionIndex});

  final _panHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    // 在构建后显示功能提示弹窗
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFeatureDialog(context);
    });

    return WillPopScope(
      onWillPop: () {
        if (orignal != context.read<EditorHomeCubit>().state.afterPath &&
            !context.read<EditorHomeCubit>().saved) {
          showSaveImagePop(context, onSave: () {
            context.read<EditorHomeCubit>().getSaveImagePath().then((path) {
              EditorUtil.homeSavedCallback?.call(context, path);
            });
          }, onCancel: () {
            EditorUtil.clearTmpObject(
                context.read<EditorHomeCubit>().state.afterPath);
            Navigator.pop(context);
          });
          return Future.value(false);
        }
        EditorUtil.clearTmpObject(
            context.read<EditorHomeCubit>().state.afterPath);
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            _content(context),
            Positioned(top: 0, left: 0, right: 0, child: _bar(context)),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  AppBar _bar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        EditorLang.of(context).editor_name,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      shadowColor: const Color(0xff19191A).withOpacity(0.1),
      elevation: 2,
      actions: [
        BlocBuilder<EditorHomeCubit, EditorHomeState>(
          builder: (BuildContext context, EditorHomeState state) {
            return saveAction(
                action:
                    orignal != context.read<EditorHomeCubit>().state.afterPath
                        ? () async {
                            // 保存图片
                            final path = await context
                                .read<EditorHomeCubit>()
                                .getSaveImagePath();
                            EditorUtil.homeSavedCallback?.call(context, path);
                          }
                        : null);
          },
        )
      ],
    );
  }

  Widget _content(BuildContext context) {
    return Stack(
      children: [
        FadeBeforeAfter(
          before: Image.file(File(orignal),
              width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
          after: BlocBuilder<EditorHomeCubit, EditorHomeState>(
            builder: (BuildContext context, EditorHomeState state) {
              return Image.file(File(state.afterPath),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain);
            },
          ),
          diffBg: const Color(0xffFAFBFF),
          diffActionBottom: 13.0,
          diffActionRight: 9.0,
          actionMargin: EdgeInsets.only(bottom: _panHeight),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MainPan(
            panHeight: _panHeight,
            onClick: (action) {
              context
                  .read<EditorHomeCubit>()
                  .toEditor(context, EditorType.values[action.type]);
            },
          ),
        )
      ],
    );
  }

  // 修改功能提示弹窗方法
  void _showFeatureDialog(BuildContext context) {
    // 保存当前上下文中的 cubit 引用
    final editorCubit = context.read<EditorHomeCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('新功能提示'),
          content: Text('我们添加了新的编辑功能，立即体验？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('稍后再说'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // 使用保存的 cubit 引用而不是从对话框上下文中读取
                editorCubit.toEditor(
                  context, // 使用原始上下文
                  EditorType.values[actionIndex ?? 6],
                  subActionIndex ?? 1,
                );
              },
              child: Text('立即体验'),
            ),
          ],
        );
      },
    );
  }
}
