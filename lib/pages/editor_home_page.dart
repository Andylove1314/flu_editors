
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/edtor_home_cubit.dart';
import '../flu_editor.dart';
import '../widgets/custom_widget.dart';
import '../widgets/diff/diff_widget.dart';
import '../widgets/main_pan.dart';

class EditorHomePage extends StatelessWidget {
  final String orignal;

  const EditorHomePage({super.key, required this.orignal});

  final _panHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (orignal != context.read<EditorHomeCubit>().state.afterPath &&
            !context.read<EditorHomeCubit>().saved) {
          showSaveImagePop(context, onSave: () {
            context.read<EditorHomeCubit>().saveImage();
            EditorUtil.clearTmpObject();
            Navigator.pop(context);
          }, onCancel: () {
            EditorUtil.clearTmpObject();
            Navigator.pop(context);
          });
          return Future.value(false);
        }
        EditorUtil.clearTmpObject();
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
        '图片编辑',
        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
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
                        ? () => context.read<EditorHomeCubit>().saveImage()
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
          before: Image.file(File(orignal)),
          after: BlocBuilder<EditorHomeCubit, EditorHomeState>(
            builder: (BuildContext context, EditorHomeState state) {
              return Image.file(File(state.afterPath));
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
              context.read<EditorHomeCubit>().toEditor(context, action.type);
            },
          ),
        )
      ],
    );
  }
}
