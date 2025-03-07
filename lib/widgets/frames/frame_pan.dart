import 'package:flu_editor/widgets/custom_widget.dart';
import 'package:flu_editor/widgets/frames/frame_list.dart';
import 'package:flutter/material.dart';

import '../../flu_editor.dart';
import '../../generated/l10n.dart';
import '../confirm_bar.dart';
import '../vip_bar.dart';
import 'frame_class_widget.dart';

class FramePan extends StatefulWidget {
  final List<FrameData> frs;

  FrameDetail? usingDetail;

  final Function({FrameDetail? item, String? path}) onChanged;

  final Function() onEffectSave;

  final int? initialIndex;

  FramePan(
      {super.key,
      required this.frs,
      required this.onChanged,
      required this.onEffectSave,
      this.usingDetail,
      this.initialIndex});

  @override
  State<FramePan> createState() => _FramePanState();
}

class _FramePanState extends State<FramePan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool vipSticker = false;

  late int position;

  @override
  void initState() {
    super.initState();
    position = widget.initialIndex ?? 0;
    _tabController =
        TabController(length: widget.frs.length, vsync: this, initialIndex: widget.initialIndex ?? 0)
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
          height: 170,
          child: TabBarView(
            controller: _tabController,
            children: widget.frs
                .map((item) => FrameList(
                    usingDetail: widget.usingDetail,
                    sts: item.list ?? [],
                    onChanged: ({FrameDetail? item, String? path}) {
                      setState(() {
                        vipSticker = item?.isVipFrame ?? false;
                      });
                      widget.onChanged(item: item, path: path);
                    }))
                .toList(),
          ),
        ),
        ConfirmBar(
          content: FrameClassWidget(
            position: position,
            tabController: _tabController,
            tags: widget.frs,
          ),
          cancel: () {
            Navigator.of(context).pop();
          },
          confirm: () async {
            if (showVipBg) {
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
