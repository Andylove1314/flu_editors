import 'package:flu_editor/models/action_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constant.dart';

class AlignWidget extends StatefulWidget {
  TextAlign? textAlign;

  AlignWidget({super.key, required this.onAlign, this.textAlign});

  final Function(TextAlign align) onAlign;

  @override
  State<StatefulWidget> createState() => _AlignWidgetState();
}

class _AlignWidgetState extends State<AlignWidget> {
  ActionData? _currentItem;

  @override
  void initState() {
    if (widget.textAlign == TextAlign.left) {
      _currentItem = fontAlignActions[0];
    } else if (widget.textAlign == TextAlign.center) {
      _currentItem = fontAlignActions[1];
    } else if (widget.textAlign == TextAlign.right) {
      _currentItem = fontAlignActions[2];
    } else {
      _currentItem = fontAlignActions[0];
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AlignWidget oldWidget) {
    if(widget.textAlign == null){
      setState(() {
        _currentItem = fontAlignActions[0];
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: fontAlignActions.map((item) => _item(context, item)).toList(),
      ),
    );
  }

  Widget _item(BuildContext context, ActionData item) {
    bool selected = _currentItem == item;

    return GestureDetector(
      onTap: () {
        if (_currentItem == item) {
          return;
        }

        setState(() {
          _currentItem = item;
        });

        if (item.type == 0) {
          widget.onAlign.call(TextAlign.left);
        } else if (item.type == 1) {
          widget.onAlign.call(TextAlign.center);
        } else if (item.type == 2) {
          widget.onAlign.call(TextAlign.right);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            (selected ? item.selectedIcon : item.icon) ?? '',
            fit: BoxFit.fill,
            width: 33,
            height: 33,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            item.name,
            style: const TextStyle(
                color: Color(0xff646466),
                fontSize: 10,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
