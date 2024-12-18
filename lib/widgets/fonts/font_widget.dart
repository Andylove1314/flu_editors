import 'dart:io';

import 'package:flu_editor/flu_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/font_image_bloc/font_bloc.dart';
import '../net_image.dart';

class FontWidget extends StatelessWidget {
  FontDetail fontDetail;

  Function(FontDetail? item, String? ttfPath, String? imgPath)? onSelect;

  FontWidget({super.key, required this.fontDetail, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        _fetchSrc(),
        BlocProvider(
          create: (context) => FontSourceImageCubit(fontDetail),
          child: BlocBuilder<FontSourceImageCubit, FontSourceImageState>(
              builder: (context, state) {
            Widget icon = Image.asset(
              width: 12,
              'icon_cloud'.imagePng,
              fit: BoxFit.fitWidth,
            );

            if (state is FontSourceImageCaching) {
              icon = SizedBox(
                width: 12,
                height: 12,
                child:
                    EditorUtil.loadingWidget(context, isLight: false, size: 12),
              );
            } else if (state is FontSourceImageCached) {
              icon = const SizedBox();
            }

            return GestureDetector(
              onTap: () {
                debugPrint('000000');
                if (state is FontSourceImageCached) {
                  debugPrint('cached: ${state.path}');
                  onSelect?.call(
                      fontDetail, state.path, state.fontDetail.image);
                } else {
                  context
                      .read<FontSourceImageCubit>()
                      .cacheFont(fontDetail)
                      .then((path) {
                    debugPrint('cached: $path');
                    onSelect?.call(fontDetail, path, fontDetail.image);
                  });
                }
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(bottom: 3, right: 3),
                child: icon,
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _fetchSrc() {
    if (fontDetail.imgFrom == 0) {
      return Image.asset(
        fontDetail.image ?? '',
        fit: BoxFit.fill,
      );
    } else if (fontDetail.imgFrom == 1) {
      return Image.file(
        File(fontDetail.image ?? ''),
        fit: BoxFit.fill,
      );
    }
    return NetImage(
      url: fontDetail.image ?? '',
      fit: BoxFit.fill,
    );
  }
}
