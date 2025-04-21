import 'dart:io';

import 'package:flu_editor/utils/editor_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/edtor_home_cubit.dart';
import '../flu_editor.dart';
import '../generated/l10n.dart';
import '../widgets/custom_widget.dart';
import '../widgets/diff/diff_widget.dart';
import '../widgets/main_pan.dart';


class EditorHomePage extends StatefulWidget {
  final String orignal;

  final bool? showFeatureDialog;
  final EditorType? groupType;
  final String? subGroupId;
  final FeatureDialogBuilder? featureDialogBuilder;

  const EditorHomePage({
    super.key,
    required this.orignal,
    this.groupType,
    this.subGroupId,
    this.showFeatureDialog = false,
    this.featureDialogBuilder
  });

  @override
  State<EditorHomePage> createState() => _EditorHomePageState();
}

class _EditorHomePageState extends State<EditorHomePage> {
  final _panHeight = 100.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showFeatureDialog == true) {
        _showFeatureDialog(context, widget.featureDialogBuilder);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.orignal != context.read<EditorHomeCubit>().state.afterPath &&
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
                    widget.orignal != context.read<EditorHomeCubit>().state.afterPath
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
          before: Image.file(File(widget.orignal),
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
  void _showFeatureDialog(
      BuildContext context, FeatureDialogBuilder? featureDialogBuilder) {
    // 保存当前上下文中的 cubit 引用
    final editorCubit = context.read<EditorHomeCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // 定义确认按钮的回调函数
        onConfirm() {
          Navigator.of(dialogContext).pop();

          editorCubit.toEditor(
            context, // 使用原始上下文
            widget.groupType ?? EditorType.crop,
            widget.subGroupId,
          );
        }

        return featureDialogBuilder?.call(dialogContext, onConfirm) ??
            AlertDialog(
              title: const Text(
                '新功能提示',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              content: const Text(
                '我们添加了新的编辑功能，立即体验？',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text(
                    '稍后再说',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    editorCubit.toEditor(
                      context, // 使用原始上下文
                      widget.groupType ?? EditorType.crop,
                      widget.subGroupId,
                    );
                  },
                  child: const Text(
                    '立即体验',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            );
      },
    );
  }
}
