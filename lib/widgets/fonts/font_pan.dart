import 'package:flu_editor/utils/constant.dart';
import 'package:flu_editor/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

import '../../flu_editor.dart';
import '../../generated/l10n.dart';
import '../confirm_bar.dart';
import 'font_align_pan.dart';
import 'font_class_widget.dart';
import 'font_font_pan.dart';
import 'font_style_pan.dart';

class FontPan extends StatefulWidget {
  /// 初始化参数
  FontDetail? fontDetail;
  String? color;
  double? opacity;
  bool? bold;
  bool? italic;
  bool? underline;
  TextAlign? textAlign;
  double? worldSpace;
  double? lineSpace;

  /// 字体
  final Function({FontDetail? item, String? ttfPath, String? imgPath})
      onFontChanged;

  ///样式
  final Function(String? color) onColorChanged;
  final Function(double? opacity) onOpacityChanged;

  final Function(bool? bold) onBold;
  final Function(bool? italic) onItalic;
  final Function(bool? underline) onUnderline;

  /// 对齐
  final Function(double? worldSpace) onWorldSpaceChanged;
  final Function(double? lineSpace) onLineSpaceChanged;
  final Function(TextAlign? align) onAlignChanged;

  /// 保存
  final Function() onEffectSave;

  final int? initialIndex;

  FontPan(
      {super.key,
      required this.onFontChanged,
      required this.onColorChanged,
      required this.onOpacityChanged,
      required this.onBold,
      required this.onItalic,
      required this.onUnderline,
      required this.onWorldSpaceChanged,
      required this.onLineSpaceChanged,
      required this.onAlignChanged,
      required this.onEffectSave,
      this.fontDetail,
      this.color,
      this.opacity,
      this.bold,
      this.italic,
      this.underline,
      this.textAlign,
      this.worldSpace,
      this.lineSpace,
      this.initialIndex});

  @override
  State<StatefulWidget> createState() => _FontPanState();
}

class _FontPanState extends State<FontPan> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late int position;
  bool showViptip = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialIndex ?? 0;
    _tabController =
        TabController(length: fontActions.length, vsync: this, initialIndex: widget.initialIndex ?? 0)
          ..addListener(() {
            setState(() {
              position = _tabController.index;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 230,
          child: TabBarView(
            controller: _tabController,
            children: fontActions.map((item) {
              if (item.type == 0) {
                return FontFontPan(
                  onChanged: (
                      {FontDetail? item,
                      String? ttfPath,
                      String? imgPath,
                      bool? showVipPop}) {
                    setState(() {
                      debugPrint('000000088888 $showVipPop');
                      showViptip = showVipPop ?? false;
                    });
                    widget.onFontChanged
                        .call(item: item, ttfPath: ttfPath, imgPath: imgPath);
                  },
                  fontDetail: widget.fontDetail,
                );
              }
              if (item.type == 1) {
                return FontStylePan(
                  onColorChanged: (color) {
                    widget.onColorChanged(color);
                  },
                  onOpacityChanged: (opacity) {
                    widget.onOpacityChanged.call(opacity);
                  },
                  onBold: (bold) {
                    widget.onBold.call(bold);
                  },
                  onItalic: (italic) {
                    widget.onItalic.call(italic);
                  },
                  onUnderline: (underline) {
                    widget.onUnderline.call(underline);
                  },
                  color: widget.color,
                  opacity: widget.opacity,
                  bold: widget.bold,
                  italic: widget.italic,
                  underline: widget.underline,
                );
              }
              if (item.type == 2) {
                return FontAlignPan(
                  onWorldSpaceChanged: (ws) {
                    widget.onWorldSpaceChanged.call(ws);
                  },
                  onLineSpaceChanged: (ls) {
                    widget.onLineSpaceChanged.call(ls);
                  },
                  onAlignChanged: (align) {
                    widget.onAlignChanged.call(align);
                  },
                  textAlign: widget.textAlign,
                  worldSpace: widget.worldSpace,
                  lineSpace: widget.lineSpace,
                );
              }

              return const SizedBox();
            }).toList(),
          ),
        ),
        ConfirmBar(
          content: FontClassWidget(
            position: position,
            tabController: _tabController,
            tags: fontActions.map((filter) => filter.name).toList(),
            centerTab: true,
            showIndicator: true,
          ),
          cancel: () {
            Navigator.of(context).pop();
          },
          confirm: () async {
            if (showViptip) {
              showVipPop(context, content: EditorLang.of(context).editor_vip_limited_3,
                  onSave: () {
                EditorUtil.vipActionCallback?.call();
              }, onCancel: () {});
              return;
            }
            widget.onEffectSave.call();
          },
        )
      ],
    );
  }
}
