import 'dart:io';

import 'package:flu_editor/widgets/frames/frame_pan.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photo_view/photo_view.dart';

import '../blocs/edtor_home_cubit.dart';
import '../flu_editor.dart';
import '../widgets/frames/frame_bg_container_widget.dart';

class EditorFramePage extends StatefulWidget {
  final String afterPath;
  final int? subActionIndex;

  const EditorFramePage({super.key, required this.afterPath, this.subActionIndex});

  @override
  State<EditorFramePage> createState() => _EditorFramePageState();
}

class _EditorFramePageState extends State<EditorFramePage> {
  /// current frame
  FrameDetail? _frameDetail;
  String? _currentFrame;

  PhotoViewController? _photoViewController;

  final GlobalKey _imageKey = GlobalKey();

  late double frameAspectRatio;
  img.Image? _input;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _getPre()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FramePan(
                initialIndex: widget.subActionIndex,
                frs: EditorUtil.frameList,
                usingDetail: _frameDetail,
                onChanged: ({FrameDetail? item, String? path}) {
                  _frameDetail = item;
                  _currentFrame = path;
                  setState(() {});
                },
                onEffectSave: () async {
                  if (_frameDetail == null) {
                    return;
                  }
                  EditorUtil.showLoadingdialog(context);
                  EditorUtil.addFrame(_imageKey, widget.afterPath,
                          _currentFrame ?? '', frameAspectRatio)
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
          )
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  /// 相框预览
  Widget _getPre() {
    Widget input = Image.file(
      File(widget.afterPath), width: MediaQuery.of(context).size.width,fit: BoxFit.contain
    );
    if (_frameDetail == null) {
      return input;
    }
    return LayoutBuilder(builder: (context, constraints) {
      var bgWidth = constraints.maxWidth;
      var bgHeight = constraints.maxHeight;
      debugPrint('容器Widget宽高: $bgWidth - $bgWidth');

      // 假设图片的实际尺寸为 imagePixelWidth 和 imagePixelHeight
      double imagePixelWidth =
          _frameDetail?.params?.frameWidth * 1.0; // 图片的实际宽度（像素）
      double imagePixelHeight =
          _frameDetail?.params?.frameHeight * 1.0; // 图片的实际高度（像素）
      // 镂空区域的像素值
      double frameLeftPixel = _frameDetail?.params?.frameLeft * 1.0;
      double frameTopPixel = _frameDetail?.params?.frameTop * 1.0;
      double frameRightPixel = _frameDetail?.params?.frameRight * 1.0;
      double frameBottomPixel = _frameDetail?.params?.frameBottom * 1.0;
      debugPrint('图片pix宽高: $imagePixelWidth - $imagePixelHeight');

      // 计算图片的宽高比
      frameAspectRatio = imagePixelWidth / imagePixelHeight;

      // 计算容器的宽高比
      double containerAspectRatio = bgWidth / bgHeight;

      double displayWidth, displayHeight;
      // 判断是按宽度还是按高度来适应
      if (frameAspectRatio > containerAspectRatio) {
        // 图片宽高比大，按宽度适应容器
        displayWidth = bgWidth;
        displayHeight = bgWidth / frameAspectRatio;
      } else {
        // 图片高宽比大，按高度适应容器
        displayHeight = bgHeight;
        displayWidth = bgHeight * frameAspectRatio;
      }

      debugPrint('图片Widget宽高: $displayWidth - $displayHeight');

      // 计算缩放比例
      double scaleX = displayWidth / imagePixelWidth;
      double scaleY = displayHeight / imagePixelHeight;

      // 将镂空区域像素值转换为显示区域的比例值
      double imageLeft = frameLeftPixel * scaleX;
      double imageTop = frameTopPixel * scaleY;
      double imageRight = frameRightPixel * scaleX;
      double imageBottom = frameBottomPixel * scaleY;
      debugPrint(
          '图片Widget镂边距: $imageLeft - $imageTop - $imageRight - $imageBottom');

      double bgLeft = imageLeft + (bgWidth - displayWidth) / 2;
      double bgTop = imageTop + (bgHeight - displayHeight) / 2;
      double bgRight = imageRight + (bgWidth - displayWidth) / 2;
      double bgBottom = imageBottom + (bgHeight - displayHeight) / 2;
      debugPrint('容器Widget镂边距: $bgLeft - $bgTop - $bgRight - $bgBottom');

      var lkWidth = bgWidth - bgLeft - bgRight;
      var lkHeight = bgHeight - bgTop - bgBottom;
      debugPrint('镂空大小 $lkWidth x $lkHeight}');

      _fetchInputSize(displayWidth, displayHeight).then((size) {
        debugPrint('input大小 ${size.width} x ${size.height}');

        // 计算X、Y方向的缩放比例
        double scaleX = lkWidth / size.width;
        double scaleY = lkHeight / size.height;

        double newScale = scaleX > scaleY ? scaleX : scaleY;
        var left = (displayWidth - lkWidth) / 2;
        double x = imageLeft - left;
        var top = (displayHeight - lkHeight) / 2;
        double y = imageTop - top;

        debugPrint('缩放大小：$newScale');
        debugPrint('偏移：x=$x, y=$y');
        _initInputPosition(newScale, Offset(x, y));
      });

      return Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              child: SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: RepaintBoundary(
                  key: _imageKey,
                  child: PhotoView.customChild(
                    enablePanAlways: true,
                    initialScale: PhotoViewComputedScale.contained,
                    controller: _photoViewController,
                    enableRotation: true,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.white),
                    child: input,
                  ),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                child: _currentFrame == null
                    ? const SizedBox()
                    : FrameBgContainerWidget(
                        frameLeft: bgLeft,
                        frameTop: bgTop,
                        frameRight: bgRight,
                        frameBottom: bgBottom,
                        containerW: bgWidth,
                        containerH: bgHeight,
                      ),
              )),
          Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              child: SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: Image.file(
                  File(_currentFrame ?? ''),
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  /// 初始化输入图位置
  void _initInputPosition(double scale, Offset offset) {
    debugPrint('refresh position');
    if (_photoViewController == null) {
      _photoViewController = PhotoViewController(initialScale: scale);
      _photoViewController?.position = offset;
      setState(() {});
    }
    _photoViewController?.reset();
    _photoViewController?.scale = scale;
    _photoViewController?.position = offset;
  }

  /// 获取输入图宽高
  Future<Size> _fetchInputSize(
      double photoViewWidth, double photoViewHeight) async {
    if (_input == null) {
      List list = await EditorUtil.fileToUint8ListAndImage(widget.afterPath);
      _input = list[0];
    }

    double inputWidth, inputHeight;

    var inputScale = _input!.width / _input!.height;
    var photoViewScale = photoViewWidth / photoViewHeight;

    if (inputScale > photoViewScale) {
      // 图片宽高比大，按宽度适应容器
      inputWidth = photoViewWidth;
      inputHeight = inputWidth / inputScale;
    } else {
      // 图片高宽比大，按高度适应容器
      inputHeight = photoViewHeight;
      inputWidth = photoViewHeight * inputScale;
    }

    return Size(inputWidth, inputHeight);
  }
}
