import 'dart:ui';
import 'package:flu_editor/flu_editor.dart';
import 'package:flutter/material.dart';

class InputPopWidget extends StatefulWidget {
  InputPopWidget(
      {super.key, required this.input, required this.content, this.font});

  final String content;
  String? font;
  final Function(String content) input;

  @override
  _InputPopWidgetState createState() => _InputPopWidgetState();
}

class _InputPopWidgetState extends State<InputPopWidget> {
  final TextEditingController _topController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode 用于控制焦点

  @override
  void initState() {
    super.initState();
    // 初始化顶部的 TextField 内容
    _topController.text = widget.content;
    WidgetsBinding.instance.addPostFrameCallback((s) {
      // 自动聚焦，弹出键盘
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle topStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 28,
        fontFamily: widget.font);
    TextStyle bottomStyle = const TextStyle(
        color: Color(0xff19191A), fontWeight: FontWeight.w500, fontSize: 16);
    TextStyle bottomHintStyle = const TextStyle(
        color: Color(0xff646466), fontWeight: FontWeight.w500, fontSize: 16);

    // 获取键盘高度
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 高斯模糊背景
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // 设置模糊强度
            child: Container(
              color: Colors.black.withOpacity(0.5), // 半透明背景色
            ),
          ),

          // 顶部显示文字区域
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2)),
              child: Text(
                  _topController.text.isEmpty ? '点击输入文案' : _topController.text,
                  style: topStyle),
            ),
          ),

          // 输入框区域
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: keyboardHeight),
              // 调整输入框的位置避免被键盘遮挡
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        // 关联 FocusNode
                        controller: _topController,
                        maxLines: null,
                        style: bottomStyle,
                        cursorColor: const Color(0xff19191A),
                        onChanged: (t) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: '输入文案',
                            hintStyle: bottomHintStyle,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10)),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.input.call(_topController.text);
                        },
                        icon: Image.asset(
                          'icon_queren_edit'.imagePng,
                          width: 21,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
