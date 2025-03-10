import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flu_editor/flu_editor.dart';
import 'package:flu_editor/generated/l10n.dart';
import 'package:flu_editor_example/route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _fluEditorPlugin = FluEditor();

  /// 当前输入图
  String _currentImage = '';

  bool isVipUser = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _fluEditorPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        EditorLang.delegate
      ],
      supportedLocales: [...EditorLang.delegate.supportedLocales],
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('FluEditorApp'),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                      width: double.infinity,
                      color: Colors.grey,
                      child: Stack(alignment: Alignment.center, children: [
                        _currentImage.isEmpty
                            ? const SizedBox()
                            : Image.file(File(_currentImage)),
                        GestureDetector(
                          onTap: () {
                            _pickImage(context);
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            color: Colors.white.withOpacity(0.4),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 50.0,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Add photo',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]))),
              const SizedBox(
                height: 20,
              ),
              Material(
                child: SizedBox(
                  width: 200,
                  child: FilledButton(
                      onPressed: () async {
                        if (_currentImage.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Add photo pleasen!')));
                          return;
                        }
                        _goEditor(context);
                      },
                      child: const Text('Go Editor')),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    _currentImage = image.path ?? '';
    setState(() {});
  }

  Future<void> _goEditor(BuildContext context) async {
    EditorUtil.goFluEditor(context,
    showFeatureDialog: true,
    groupName: 'filter',
    subGroupId: '2',
        orignal: _currentImage,
        vipStatusCb: () {
          debugPrint('get vip status: $isVipUser');
          return isVipUser;
        },
        vipActionCb: () {
          debugPrint('go Sub');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return RoutePage(
                title: 'Sub page',
              );
            },
          ));
        },
        saveCb: (path) async {
          GallerySaver.saveImage(path, albumName: 'Flu-Editor');
        },
        loadWidgetCb: (islight, size, stroke) => Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: islight ? Colors.white : Colors.black,
                strokeWidth: stroke,
              ),
            ),
        toastActionCb: (msg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg))),
        effectsCb: (page) async => await _fetchPF(),
        saveEffectCb: (effect) async {
          debugPrint('Save pf：${effect.toJson()}');
          return true;
        },
        deleteEffectCb: (id) async {
          debugPrint('Delete：$id');
          return true;
        },
        filtersCb: () => _fetchLJ(),
        stickersCb: () => _fetchStickers(),
        fontsCb: () => _fetchFonts(),
        framesCb: () => _fetchFrames(),
        homeSavedCb: (context, after) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return RoutePage(
                savedPath: after,
                title: 'Saved page',
              );
            },
          ));
        },
        loginCheckCb: () {
          return Future.value(false);
        });
  }

  Future<List<EffectData>> _fetchPF() async {
    return [
      EffectData.fromJson({
        'name': 'test',
        // 'image':
        //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/effect.jpg',
        'asset': 'assets/effect.jpg',
        'id': 0,
        'params': jsonEncode({
          "Brightness": 0.14719999999999997,
          "Saturation": 1.0,
          "Contrast": 1.0,
          "Sharpen": 0.0,
          "Shadow": 0.0,
          "Temperature": 0.0,
          "Noise": 0.0,
          "Exposure": 0.0,
          "Vibrance": 0.0,
          "Highlight": 0.0,
          "Red": 1.0,
          "Green": 1.0,
          "Blue": 1.0,
          "CenterX": 0.5,
          "CenterY": 0.5,
          "Start": 1.0,
          "End": 1.0
        })
      })
    ];
  }

  Future<List<FilterData>> _fetchLJ() async {
    FilterDetail detail1 = FilterDetail();
    detail1.id = 1;
    // detail1.image =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/filter_bg.jpg';
    detail1.image = 'assets/filter_bg.jpg';
    detail1.filterImage = 'luts/01-x.png';
    detail1.name = 'class1';
    detail1.noise = 0.2;
    detail1.vip = 1;
    detail1.lutFrom = 0;
    detail1.imgFrom = 0;

    FilterDetail detail2 = FilterDetail();
    detail2.id = 2;
    // detail2.image =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/filter_bg.jpg';
    detail2.image = 'assets/filter_bg.jpg';
    detail2.filterImage = 'luts/03-x.png';
    detail2.name = 'class2';
    detail2.lutFrom = 0;
    detail2.imgFrom = 0;

    FilterData group1 = FilterData();
    group1.groupName = 'class1';

    group1.list = [detail1, detail2];


    FilterData group2 = FilterData();
    group2.groupName = 'class2';
    group2.list = [detail1, detail2];

    return [group1, group2];
  }

  Future<List<StickerData>> _fetchStickers() async {
    StickDetail detail1 = StickDetail();
    detail1.id = 1;
    // detail1.image =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/sticker_1.png';
    detail1.image = 'assets/sticker_1.png';
    detail1.name = 'sticker1';
    detail1.vip = 0;
    detail1.imgFrom = 0;

    StickDetail detail2 = StickDetail();
    detail2.id = 1;
    // detail2.image =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/sticker_2.png';
    detail2.image = 'assets/sticker_2.png';
    detail2.name = 'sticker2';
    detail2.vip = 0;
    detail2.imgFrom = 0;

    StickerData group1 = StickerData();
    group1.groupName = 'class1';
    // group1.groupImage =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/sticker_1.png';
    group1.groupImage = 'assets/sticker_1.png';
    group1.imgFrom = 0;

    group1.list = [detail1, detail2];


    StickerData group2 = StickerData();
    group2.groupName = 'class2';
    group2.list = [detail1, detail2];

    return [group1, group2];
  }

  Future<List<FontsData>> _fetchFonts() async {
    FontDetail detail1 = FontDetail();
    detail1.id = 1;
    // detail1.image =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/font_1.jpg';
    detail1.image = 'assets/font_1.jpg';
    // detail1.file =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/ttf_1.ttf';
    detail1.file = 'assets/ttf_1.ttf';
    detail1.name = 'font1';
    detail1.vip = 0;
    detail1.imgFrom = 0;
    detail1.ttfFrom = 0;

    FontsData group1 = FontsData();
    group1.groupName = 'Sample';

    group1.list = [detail1];

    return [group1];
  }

  Future<List<FrameData>> _fetchFrames() async {
    FrameDetail detail1 = FrameDetail();
    detail1.id = 1;
    // detail1.image =
    //     'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/frame_1.png';
    detail1.image = 'assets/frame_1.png';
    detail1.name = 'frame1';
    detail1.vip = 0;
    FrameSize size = FrameSize();
    size.frameWidth = 560;
    size.frameHeight = 1000;
    size.frameLeft = 94.0;
    size.frameTop = 142.0;
    size.frameRight = 88.0;
    size.frameBottom = 114.0;
    detail1.params = size;
    detail1.imgFrom = 0;

    FrameDetail detail2 = FrameDetail();
    detail2.id = 2;
    detail2.image =
        'https://github.com/Andylove1314/flu_editors/blob/1.0.4/example/assets/frame_2.png';
    detail2.image = 'assets/frame_2.png';
    detail2.name = 'frame2';
    detail2.vip = 0;
    FrameSize size2 = FrameSize();
    size2.frameWidth = 672;
    size2.frameHeight = 1000;
    size2.frameLeft = 136.0;
    size2.frameTop = 154.0;
    size2.frameRight = 136.0;
    size2.frameBottom = 156.0;
    detail2.params = size2;
    detail2.imgFrom = 0;

    FrameData group1 = FrameData();
    group1.groupName = 'Sample';

    group1.list = [detail1, detail2];

    FrameData group2 = FrameData();
    group2.groupName = 'Sample';
    group2.list = [detail1, detail2];

    return [group1, group2];
  }
}
