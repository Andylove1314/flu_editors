import 'package:flu_editor/widgets/custom_widget.dart';
import 'package:flu_editor/widgets/filters/filters_list.dart';
import 'package:flutter/material.dart';

import '../../flu_editor.dart';
import '../../generated/l10n.dart';
import '../confirm_bar.dart';
import '../vip_bar.dart';
import 'filter_class_widget.dart';

class FiltersPan extends StatefulWidget {
  final List<FilterData> fds;

  FilterDetail? usingDetail;

  final Function({FilterDetail? item}) onChanged;

  final SquareLookupTableNoiseShaderConfiguration sourceFiltersConfig;

  final Function() onEffectSave;

  final int? initialIndex;

  FiltersPan(
      {super.key,
      required this.fds,
      required this.sourceFiltersConfig,
      required this.onChanged,
      required this.onEffectSave,
      this.usingDetail,
      this.initialIndex});

  @override
  State<FiltersPan> createState() => _FiltersPanState();
}

class _FiltersPanState extends State<FiltersPan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool vipFilter = false;

  late int position;

  @override
  void initState() {
    super.initState();
    position = widget.initialIndex ?? 0;
    
    _tabController =
        TabController(length: widget.fds.length, vsync: this, initialIndex: widget.initialIndex ?? 0)
          ..addListener(() {
            setState(() {
              position = _tabController.index;
            });
          });
    
  }

  @override
  Widget build(BuildContext context) {
    bool showVipBg =
        vipFilter && !(EditorUtil.vipStatusCallback?.call() ?? false);

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
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 9),
          color: Colors.white,
          child: SizedBox(
            height: 73,
            child: TabBarView(
              controller: _tabController,
              children: widget.fds
                  .map((item) => FiltersList(
                      usingDetail: widget.usingDetail,
                      fds: item.list ?? [],
                      sourceFiltersConfig: widget.sourceFiltersConfig,
                      onScrollNext: () {
                        int index = widget.fds.indexOf(item);
                        if (index < widget.fds.length - 1) {
                          _tabController.animateTo(index + 1);
                        }
                      },
                      onScrollPre: () {
                        int index = widget.fds.indexOf(item);
                        if (index > 0) {
                          _tabController.animateTo(index - 1);
                        }
                      },
                      onChanged: ({FilterDetail? item}) {
                        setState(() {
                          vipFilter = item?.isVipFilter ?? false;
                        });
                        widget.onChanged(item: item);
                      }))
                  .toList(),
            ),
          ),
        ),
        ConfirmBar(
          content: FilterClassWidget(
            position: position,
            tabController: _tabController,
            tags: widget.fds.map((filter) => filter.groupName).toList(),
          ),
          cancel: () {
            Navigator.of(context).pop();
          },
          confirm: () async {
            if (showVipBg) {
              showVipPop(context, content: EditorLang.of(context).editor_vip_limited_2,onSave: () {
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
