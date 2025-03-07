import 'dart:io';

import 'package:flu_editor/widgets/fonts/input_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';

import '../blocs/edtor_home_cubit.dart';
import '../flu_editor.dart';
import '../widgets/fonts/font_pan.dart';
import '../widgets/fonts/font_pre_view.dart';

class EditorFontPage extends StatefulWidget {
  final String afterPath;
  final int? subActionIndex;

  const EditorFontPage({super.key, required this.afterPath, this.subActionIndex});

  @override
  State<EditorFontPage> createState() => _EditorFontPageState();
}

class _EditorFontPageState extends State<EditorFontPage> {
  late LindiController _stickerController;

  /// current sticker 参数

  String _content = '';
  FontDetail? _fontDetail;
  String? _font;
  String? _color;
  double? _opacity;
  bool? _bold;
  bool? _italic;
  bool? _underline;
  TextAlign? _textAlign;
  double? _worldSpace;
  double? _lineSpace;

  var _contentW = 0.0;
  var _contentH = 0.0;

  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                key: _imageKey,
                fit: BoxFit.contain,
                File(widget.afterPath),
                frameBuilder: (context, child, loadingProgress, loaded) {
                  if (loaded) {
                    _getImageWidgetSize();
                    return child;
                  }
                  return EditorUtil.loadingWidget(context);
                },
              ),
              FontPreView(
                stvWidth: _contentW,
                stvHeight: _contentH,
                bgChild: Container(
                  width: _contentW,
                  height: _contentH,
                  color: Colors.transparent,
                ),
                onInited: (LindiController stickerController) {
                  _stickerController = stickerController;
                },
                content: _content,
                font: _font,
                opacity: _opacity,
                color: _color,
                bold: _bold,
                italic: _italic,
                underline: _underline,
                textAlign: _textAlign,
                worldSpace: _worldSpace,
                lineSpace: _lineSpace,
                onInputContent: () {
                  _showInputPop();
                },
                onClose: () {
                  _content = '';
                  _fontDetail = null;
                  _font = null;
                  _color = null;
                  _opacity = null;
                  _bold = null;
                  _italic = null;
                  _underline = null;
                  _textAlign = null;
                  _worldSpace = null;
                  _lineSpace = null;
                  setState(() {});
                },
              ),
            ],
          )),
          FontPan(
            initialIndex: widget.subActionIndex,
            fontDetail: _fontDetail,
            color: _color,
            opacity: _opacity,
            bold: _bold,
            italic: _italic,
            underline: _underline,
            textAlign: _textAlign,
            worldSpace: _worldSpace,
            lineSpace: _lineSpace,
            onEffectSave: () async {
              if (_fontDetail == null || _content.isEmpty) {
                return;
              }

              EditorUtil.showLoadingdialog(context);
              EditorUtil.addSticker(widget.afterPath, _stickerController)
                  .then((after) {
                if (EditorUtil.editorType == null) {
                  /// 更新 home after
                  EditorUtil.homeCubit?.emit(
                    EditorHomeState(after),
                  );
                } else {
                  if (EditorUtil.singleEditorSavetoAlbum) {
                    EditorUtil.saveCallback?.call(after);
                  }
                  EditorUtil.clearTmpObject(after);
                }

                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            onFontChanged: (
                {FontDetail? item, String? ttfPath, String? imgPath}) {
              _fontDetail = item;
              _font = ttfPath;
              setState(() {});
            },
            onColorChanged: (color) {
              _color = color;
              setState(() {});
            },
            onOpacityChanged: (opacity) {
              _opacity = opacity;
              setState(() {});
            },
            onAlignChanged: (align) {
              _textAlign = align;
              setState(() {});
            },
            onBold: (bold) {
              _bold = bold;
              setState(() {});
            },
            onItalic: (italic) {
              _italic = italic;
              setState(() {});
            },
            onUnderline: (underline) {
              _underline = underline;
              setState(() {});
            },
            onWorldSpaceChanged: (worldSpace) {
              _worldSpace = worldSpace;
              setState(() {});
            },
            onLineSpaceChanged: (lineSpace) {
              _lineSpace = lineSpace;
              setState(() {});
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  void _getImageWidgetSize() {
    if (_contentW != 0.0 && _contentH != 0.0) {
      return;
    }

    var renderBox = _imageKey.currentContext?.findRenderObject();
    if (renderBox == null) {
      return;
    }
    var size = (renderBox as RenderBox).size; // 获取 widget 的宽高

    WidgetsBinding.instance.addPostFrameCallback((s) {
      setState(() {
        _contentW = size.width;
        _contentH = size.height;
      });
      debugPrint('Image width: $_contentW, height: $_contentW');
    });
  }

  void _showInputPop() {
    showDialog(
        context: context,
        builder: (con) => InputPopWidget(
              font: _font,
              input: (s) {
                setState(() {
                  _content = s;
                });
              },
              content: _content,
            ));
  }
}
