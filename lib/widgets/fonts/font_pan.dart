import 'package:flu_editor/utils/constant.dart';
import 'package:flu_editor/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

import '../../flu_editor.dart';
import '../confirm_bar.dart';
import 'font_align_pan.dart';
import 'font_class_widget.dart';
import 'font_font_pan.dart';
import 'font_style_pan.dart';

class FontPan extends StatefulWidget {
  FontDetail? usingDetail;

  final Function({FontDetail? item, String? ttfPath, String? imgPath}) onFontChanged;
  final Function({Color? color, double? opacity, int? style}) onStyleChanged;
  final Function({double? worldSpace, double? lineSpace, int? algin})
      onAlginChanged;

  final Function() onEffectSave;

  FontPan(
      {super.key,
      required this.onFontChanged,
      required this.onStyleChanged,
      required this.onAlginChanged,
      required this.onEffectSave,
      this.usingDetail});

  @override
  State<StatefulWidget> createState() => _FontPanState();
}

class _FontPanState extends State<FontPan> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int position = 0;
  bool vipFont = false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: fontActions.length, vsync: this, initialIndex: 0)
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
                      {FontDetail? item, String? ttfPath, String? imgPath, bool? showVipPop}) {
                    setState(() {
                      vipFont = showVipPop ?? false;
                    });
                    widget.onFontChanged.call(item:item, ttfPath:ttfPath, imgPath: imgPath);
                  },
                  usingDetail: widget.usingDetail,
                );
              }
              if (item.type == 1) {
                return FontStylePan(
                  onChanged: widget.onStyleChanged,
                );
              }
              if (item.type == 2) {
                return FontAlginPan(
                  onChanged: widget.onAlginChanged,
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
            if (vipFont) {
              showVipPop(context, content: '您使用了VIP素材，请在开通会员后保存效果？',
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
