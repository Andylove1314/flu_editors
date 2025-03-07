import 'dart:io';

import 'package:flu_editor/widgets/parameters_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/edtor_home_cubit.dart';
import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../flu_editor.dart';
import '../utils/constant.dart';
import '../widgets/diff/diff_widget.dart';
import '../widgets/filters/filters_pan.dart';

class EditorFilterPage extends StatefulWidget {
  final int? subActionIndex;
  const EditorFilterPage({super.key, this.subActionIndex = 0});

  @override
  State<EditorFilterPage> createState() => _EditorFilterPageState();
}

class _EditorFilterPageState extends State<EditorFilterPage> {
  final ShaderConfiguration _none = NoneShaderConfiguration();

  /// filter
  late SquareLookupTableNoiseShaderConfiguration _currentConfig;

  /// current config
  FilterDetail? _filterDetail;

  @override
  void initState() {
    _currentConfig = SquareLookupTableNoiseShaderConfiguration(
      lookup: filterParamInitValues['Intensity'] ?? 0.0,
      lookupMin: filterParamMinValues['IntensityMin'] ?? 0.0,
      lookupMax: filterParamMaxValues['IntensityMax'] ?? 0.0,
      noise: filterParamInitValues['Noise'] ?? 0.0,
      noiseMin: filterParamMinValues['NoiseMin'] ?? 0.0,
      noiseMax: filterParamMaxValues['NoiseMax'] ?? 0.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _currentConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: BlocBuilder<SourceImageCubit, SourceImageReady>(
              builder: (context, state) {
                return FadeBeforeAfter(
                  before: Image.file(File(state.afterPath), width: MediaQuery.of(context).size.width,fit: BoxFit.contain),
                  after: (state.textureSource != null)
                      ? ImageShaderPreview(
                          texture: state.textureSource!,
                          configuration:
                              _filterDetail != null ? _currentConfig : _none,
                        )
                      : EditorUtil.loadingWidget(context),
                  diffActionTop: MediaQuery.of(context).padding.top + 20,
                  diffActionRight: 9.0,
                  contentMargin: const EdgeInsets.only(bottom: 100),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// filters
                if (_filterDetail != null && (_filterDetail?.id ?? 0) >= 0)
                  ..._currentConfig.filtersDataChildren((e) {
                    /// 更新噪点
                    _updateFilterNoise();

                    /// 更新当前配置
                    e.update(_currentConfig);
                    setState(() {});
                  },
                      paramMap: filterParamInitValues,
                      paramNames: ['Intensity']),
                FiltersPan(
                  fds: EditorUtil.filterList,
                  sourceFiltersConfig: _currentConfig,
                  usingDetail: _filterDetail,
                  initialIndex: widget.subActionIndex,
                  onChanged: ({FilterDetail? item}) {
                    _filterDetail = item;
                    _updateFilterNoise();
                    setState(() {});
                  },
                  onEffectSave: () async {
                    if (_filterDetail == null) {
                      return;
                    }

                    EditorUtil.showLoadingdialog(context);
                    String after =
                        await EditorUtil.exportImage(context, _currentConfig);

                    if (EditorUtil.editorType == null) {
                      /// 更新 home after
                      EditorUtil.homeCubit?.emit(
                        EditorHomeState(after),
                      );
                    } else {
                      if(EditorUtil.singleEditorSavetoAlbum){
                        EditorUtil.saveCallback?.call(after);
                      }
                      EditorUtil.clearTmpObject(after);
                    }

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  /// 更新滤镜噪点
  void _updateFilterNoise() {
    bool needRefreshNoise = _filterDetail != null &&
        _filterDetail?.noise != null &&
        (_filterDetail?.noise ?? 0.0) > 0.0;

    if (needRefreshNoise) {
      double intensityValue = _currentConfig.lutIntensity.value * 1.0;
      double maxNoise =
          ((_currentConfig.noiseParamter as ShaderRangeNumberParameter).max ??
                  0.2) *
              1.0;
      _currentConfig.noiseStrength = (intensityValue * maxNoise) * 1.0;
    } else {
      _currentConfig.noiseStrength = 0.0;
    }
  }
}
