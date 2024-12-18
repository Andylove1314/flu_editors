import 'package:flu_editor/flu_editor.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class BackTipPopWidget extends StatelessWidget {
  Function() onSave;
  Function() onCancel;

  BackTipPopWidget({super.key, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 5, top: 5),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      'icon_close@3x'.imagePng,
                      width: 18,
                    )),
              ),
            ),
             Padding(
              padding:
                  const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
              child: Text(
                EditorLang.of(context).editor_exit_tip,
                style: const TextStyle(
                    color: Color(0xff19191A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 29),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 30)),
                        side: WidgetStateProperty.all(
                          const BorderSide(
                              color: Color(0xff979797), width: 1), // 设置边框颜色和宽度
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onCancel.call();
                      },
                      child:  Text(
                        EditorLang.of(context).editor_exit_no,
                        style: const TextStyle(
                            color: Color(0xff19191A),
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  FilledButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        onSave.call();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xffFF799E)),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 30))),
                      child:  Text(
                        EditorLang.of(context).editor_exit_save,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
