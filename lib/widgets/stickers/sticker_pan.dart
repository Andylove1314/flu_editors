import 'package:flu_editor/generated/l10n.dart';
import 'package:flu_editor/widgets/custom_widget.dart';
import 'package:flu_editor/widgets/stickers/sticker_class_widget.dart';
import 'package:flu_editor/widgets/stickers/stickers_list.dart';
import 'package:flutter/material.dart';

import '../../flu_editor.dart';
import '../confirm_bar.dart';
import '../vip_bar.dart';

class StickerPan extends StatefulWidget {
  final List<StickerData> sts;
  final int? initialIndex;
  StickDetail? usingDetail;

  final Function({StickDetail? item, String? path}) onChanged;

  final Function() onEffectSave;

  StickerPan(
      {super.key,
      required this.sts,
      required this.onChanged,
      required this.onEffectSave,
      this.usingDetail,
      this.initialIndex});

  @override
  State<StickerPan> createState() => _StickerPanState();
}

class _StickerPanState extends State<StickerPan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool vipSticker = false;

  late int position;

  @override
  void initState() {
    super.initState();
    position = widget.initialIndex ?? 0;

    _tabController =
        TabController(length: widget.sts.length, vsync: this, initialIndex: widget.initialIndex ?? 0)
          ..addListener(() {
            setState(() {
              position = _tabController.index;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    bool showVipBg =
        vipSticker && !(EditorUtil.vipStatusCallback?.call() ?? false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VipBar(
          showVipbg: showVipBg,
          subAction: () {
            EditorUtil.vipActionCallback?.call();
          },
        ),
        Container(
          color: Colors.white,
          child: StickerClassWidget(
            position: position,
            tabController: _tabController,
            tags: widget.sts,
          ),
        ),
        Container(
          color: Colors.white,
          height: 160,
          child: TabBarView(
            controller: _tabController,
            children: widget.sts
                .map((item) => StickersList(
                    usingDetail: widget.usingDetail,
                    sts: item.list ?? [],
                    onChanged: ({StickDetail? item, String? path}) {
                      setState(() {
                        vipSticker = item?.isVipSticker ?? false;
                      });
                      widget.onChanged(item: item, path: path);
                    }))
                .toList(),
          ),
        ),
        ConfirmBar(
          content: Center(
            child: Text(
              EditorLang.of(context).editor_sticker,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xff646466)),
            ),
          ),
          cancel: () {
            Navigator.of(context).pop();
          },
          confirm: () async {
            // if (showVipBg) {
            //   showVipPop(context, content: EditorLang.of(context).editor_vip_limited_3, onSave: () {
            //     EditorUtil.vipActionCallback?.call();
            //   }, onCancel: () {});
            //   return;
            // }
            widget.onEffectSave.call();
          },
        )
      ],
    );
  }
}
