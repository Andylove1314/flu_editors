import 'dart:io';

import 'package:flu_editor/widgets/stickers/sticker_pan.dart';
import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';

import '../blocs/edtor_home_cubit.dart';
import '../flu_editor.dart';
import '../generated/l10n.dart';
import '../widgets/custom_widget.dart';
import '../widgets/stickers/sticker_pre_view.dart';

class EditorStickerPage extends StatefulWidget {
  final String afterPath;
  final int? subActionIndex;

  const EditorStickerPage({super.key, required this.afterPath, this.subActionIndex});

  @override
  State<EditorStickerPage> createState() => _EditorStickerPageState();
}

class _EditorStickerPageState extends State<EditorStickerPage> {
  late LindiController _stickerController;

  var _contentW = 0.0;
  var _contentH = 0.0;

  final GlobalKey _imageKey = GlobalKey();

  String? currentStickerPath;
  int stickerCount = 0;

  final List<StickDetail?> _stickers = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('fffffff666666');
    var stickerSize = (MediaQuery.of(context).size.width - 63) / 4;
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
              StikerPreView(
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
                stickerSize: Size(stickerSize, stickerSize),
                addStickerPath: currentStickerPath,
                addCount: stickerCount,
                onRemove: (index) {
                  debugPrint('remove= $index');
                  _stickers.removeAt(index);
                },
                onCheck: (index) {

                },
              ),
            ],
          )),
          StickerPan(
            sts: EditorUtil.stickerList,
            initialIndex: widget.subActionIndex,
            onChanged: ({StickDetail? item, String? path}) {
              setState(() {
                currentStickerPath = path;
                stickerCount++;
                _stickers.add(item);
              });
            },
            onEffectSave: () async {
              if (_stickerController.widgets.isEmpty) {
                return;
              }

              ///最后检查
              bool isContainVipSticker =
                  _stickers.any((item) => item?.isVipSticker ?? false);
              if (isContainVipSticker &&
                  !(EditorUtil.vipStatusCallback?.call() ?? false)) {
                showVipPop(context,
                    content: EditorLang.of(context).editor_vip_limited_3,
                    onSave: () {
                  EditorUtil.vipActionCallback?.call();
                }, onCancel: () {});
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
}
