// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class EditorLang {
  EditorLang();

  static EditorLang? _current;

  static EditorLang get current {
    assert(_current != null,
        'No instance of EditorLang was loaded. Try to initialize the EditorLang delegate before accessing EditorLang.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<EditorLang> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = EditorLang();
      EditorLang._current = instance;

      return instance;
    });
  }

  static EditorLang of(BuildContext context) {
    final instance = EditorLang.maybeOf(context);
    assert(instance != null,
        'No instance of EditorLang present in the widget tree. Did you add EditorLang.delegate in localizationsDelegates?');
    return instance!;
  }

  static EditorLang? maybeOf(BuildContext context) {
    return Localizations.of<EditorLang>(context, EditorLang);
  }

  /// `Image Editing`
  String get editor_name {
    return Intl.message(
      'Image Editing',
      name: 'editor_name',
      desc: '',
      args: [],
    );
  }

  /// `Intensity`
  String get editor_intensity {
    return Intl.message(
      'Intensity',
      name: 'editor_intensity',
      desc: '',
      args: [],
    );
  }

  /// `Crop`
  String get editor_crop {
    return Intl.message(
      'Crop',
      name: 'editor_crop',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get editor_crop_orignal {
    return Intl.message(
      'Original',
      name: 'editor_crop_orignal',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get editor_crop_freedom {
    return Intl.message(
      'Free',
      name: 'editor_crop_freedom',
      desc: '',
      args: [],
    );
  }

  /// `Rotate`
  String get editor_rotate {
    return Intl.message(
      'Rotate',
      name: 'editor_rotate',
      desc: '',
      args: [],
    );
  }

  /// `Horizontal`
  String get editor_rotate_lr {
    return Intl.message(
      'Horizontal',
      name: 'editor_rotate_lr',
      desc: '',
      args: [],
    );
  }

  /// `Vertical`
  String get editor_rotate_tb {
    return Intl.message(
      'Vertical',
      name: 'editor_rotate_tb',
      desc: '',
      args: [],
    );
  }

  /// `Turn 90°`
  String get editor_rotate_l90 {
    return Intl.message(
      'Turn 90°',
      name: 'editor_rotate_l90',
      desc: '',
      args: [],
    );
  }

  /// `Turn 90°`
  String get editor_rotate_r90 {
    return Intl.message(
      'Turn 90°',
      name: 'editor_rotate_r90',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get editor_restore {
    return Intl.message(
      'Reset',
      name: 'editor_restore',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get editor_color {
    return Intl.message(
      'Color',
      name: 'editor_color',
      desc: '',
      args: [],
    );
  }

  /// `Delete Successfully`
  String get editor_color_delete_pf_successfully {
    return Intl.message(
      'Delete Successfully',
      name: 'editor_color_delete_pf_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete Failed`
  String get editor_color_delete_pf_faild {
    return Intl.message(
      'Delete Failed',
      name: 'editor_color_delete_pf_faild',
      desc: '',
      args: [],
    );
  }

  /// `Formula`
  String get editor_color_pf {
    return Intl.message(
      'Formula',
      name: 'editor_color_pf',
      desc: '',
      args: [],
    );
  }

  /// `No Formula`
  String get editor_color_pf_no {
    return Intl.message(
      'No Formula',
      name: 'editor_color_pf_no',
      desc: '',
      args: [],
    );
  }

  /// `Brightness`
  String get editor_color_ld {
    return Intl.message(
      'Brightness',
      name: 'editor_color_ld',
      desc: '',
      args: [],
    );
  }

  /// `Saturation`
  String get editor_color_bhd {
    return Intl.message(
      'Saturation',
      name: 'editor_color_bhd',
      desc: '',
      args: [],
    );
  }

  /// `Contrast`
  String get editor_color_dbd {
    return Intl.message(
      'Contrast',
      name: 'editor_color_dbd',
      desc: '',
      args: [],
    );
  }

  /// `Highlights`
  String get editor_color_gg {
    return Intl.message(
      'Highlights',
      name: 'editor_color_gg',
      desc: '',
      args: [],
    );
  }

  /// `Shadows`
  String get editor_color_yy {
    return Intl.message(
      'Shadows',
      name: 'editor_color_yy',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get editor_color_sw {
    return Intl.message(
      'Temperature',
      name: 'editor_color_sw',
      desc: '',
      args: [],
    );
  }

  /// `Vignette`
  String get editor_color_yying {
    return Intl.message(
      'Vignette',
      name: 'editor_color_yying',
      desc: '',
      args: [],
    );
  }

  /// `Sharpen`
  String get editor_color_rh {
    return Intl.message(
      'Sharpen',
      name: 'editor_color_rh',
      desc: '',
      args: [],
    );
  }

  /// `Noise`
  String get editor_color_zd {
    return Intl.message(
      'Noise',
      name: 'editor_color_zd',
      desc: '',
      args: [],
    );
  }

  /// `Vividness`
  String get editor_color_xyd {
    return Intl.message(
      'Vividness',
      name: 'editor_color_xyd',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get editor_color_bph {
    return Intl.message(
      'Balance',
      name: 'editor_color_bph',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get editor_color_bph_red {
    return Intl.message(
      'Red',
      name: 'editor_color_bph_red',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get editor_color_bph_green {
    return Intl.message(
      'Green',
      name: 'editor_color_bph_green',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get editor_color_bph_blue {
    return Intl.message(
      'Blue',
      name: 'editor_color_bph_blue',
      desc: '',
      args: [],
    );
  }

  /// `Exposure`
  String get editor_color_bg {
    return Intl.message(
      'Exposure',
      name: 'editor_color_bg',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get editor_filter {
    return Intl.message(
      'Filter',
      name: 'editor_filter',
      desc: '',
      args: [],
    );
  }

  /// `Stickers`
  String get editor_sticker {
    return Intl.message(
      'Stickers',
      name: 'editor_sticker',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get editor_text {
    return Intl.message(
      'Text',
      name: 'editor_text',
      desc: '',
      args: [],
    );
  }

  /// `font`
  String get editor_text_font {
    return Intl.message(
      'font',
      name: 'editor_text_font',
      desc: '',
      args: [],
    );
  }

  /// `style`
  String get editor_text_style {
    return Intl.message(
      'style',
      name: 'editor_text_style',
      desc: '',
      args: [],
    );
  }

  /// `transparent`
  String get editor_text_style_alpha {
    return Intl.message(
      'transparent',
      name: 'editor_text_style_alpha',
      desc: '',
      args: [],
    );
  }

  /// `bold`
  String get editor_text_style_ct {
    return Intl.message(
      'bold',
      name: 'editor_text_style_ct',
      desc: '',
      args: [],
    );
  }

  /// `italic`
  String get editor_text_style_xt {
    return Intl.message(
      'italic',
      name: 'editor_text_style_xt',
      desc: '',
      args: [],
    );
  }

  /// `underline`
  String get editor_text_style_xhx {
    return Intl.message(
      'underline',
      name: 'editor_text_style_xhx',
      desc: '',
      args: [],
    );
  }

  /// `align`
  String get editor_text_align {
    return Intl.message(
      'align',
      name: 'editor_text_align',
      desc: '',
      args: [],
    );
  }

  /// `word`
  String get editor_text_align_ws {
    return Intl.message(
      'word',
      name: 'editor_text_align_ws',
      desc: '',
      args: [],
    );
  }

  /// `line`
  String get editor_text_align_ls {
    return Intl.message(
      'line',
      name: 'editor_text_align_ls',
      desc: '',
      args: [],
    );
  }

  /// `left`
  String get editor_text_align_left {
    return Intl.message(
      'left',
      name: 'editor_text_align_left',
      desc: '',
      args: [],
    );
  }

  /// `center`
  String get editor_text_align_center {
    return Intl.message(
      'center',
      name: 'editor_text_align_center',
      desc: '',
      args: [],
    );
  }

  /// `right`
  String get editor_text_align_right {
    return Intl.message(
      'right',
      name: 'editor_text_align_right',
      desc: '',
      args: [],
    );
  }

  /// `border`
  String get editor_frame {
    return Intl.message(
      'border',
      name: 'editor_frame',
      desc: '',
      args: [],
    );
  }

  /// `Buy VIP`
  String get editor_vip_action {
    return Intl.message(
      'Buy VIP',
      name: 'editor_vip_action',
      desc: '',
      args: [],
    );
  }

  /// `Give up`
  String get editor_vip_cancel {
    return Intl.message(
      'Give up',
      name: 'editor_vip_cancel',
      desc: '',
      args: [],
    );
  }

  /// `activate VIP to use exclusive material functions`
  String get editor_vip_limited_1 {
    return Intl.message(
      'activate VIP to use exclusive material functions',
      name: 'editor_vip_limited_1',
      desc: '',
      args: [],
    );
  }

  /// `You have used VIP filters. Please save the filter effects after activating VIP?`
  String get editor_vip_limited_2 {
    return Intl.message(
      'You have used VIP filters. Please save the filter effects after activating VIP?',
      name: 'editor_vip_limited_2',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save the edited effects before exiting?`
  String get editor_exit_tip {
    return Intl.message(
      'Do you want to save the edited effects before exiting?',
      name: 'editor_exit_tip',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get editor_exit_no {
    return Intl.message(
      'Cancel',
      name: 'editor_exit_no',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get editor_exit_save {
    return Intl.message(
      'Save',
      name: 'editor_exit_save',
      desc: '',
      args: [],
    );
  }

  /// `You have used VIP materials. Please save the effects after activating membership?`
  String get editor_vip_limited_3 {
    return Intl.message(
      'You have used VIP materials. Please save the effects after activating membership?',
      name: 'editor_vip_limited_3',
      desc: '',
      args: [],
    );
  }

  /// `Transparency`
  String get editor_text_style_alpha_2 {
    return Intl.message(
      'Transparency',
      name: 'editor_text_style_alpha_2',
      desc: '',
      args: [],
    );
  }

  /// `Left and right`
  String get editor_color_yying_zy {
    return Intl.message(
      'Left and right',
      name: 'editor_color_yying_zy',
      desc: '',
      args: [],
    );
  }

  /// `Up and down`
  String get editor_color_yying_sx {
    return Intl.message(
      'Up and down',
      name: 'editor_color_yying_sx',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get editor_color_yying_dx {
    return Intl.message(
      'Size',
      name: 'editor_color_yying_dx',
      desc: '',
      args: [],
    );
  }

  /// `Extension`
  String get editor_color_yying_wy {
    return Intl.message(
      'Extension',
      name: 'editor_color_yying_wy',
      desc: '',
      args: [],
    );
  }

  /// `Blur`
  String get editor_blur {
    return Intl.message(
      'Blur',
      name: 'editor_blur',
      desc: '',
      args: [],
    );
  }

  /// `Hue`
  String get editor_color_sd {
    return Intl.message(
      'Hue',
      name: 'editor_color_sd',
      desc: '',
      args: [],
    );
  }

  /// `Save the effect for one-click use next time before applying the color effect?`
  String get editor_color_effect_save_tip {
    return Intl.message(
      'Save the effect for one-click use next time before applying the color effect?',
      name: 'editor_color_effect_save_tip',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get editor_color_effect_save_no {
    return Intl.message(
      'Cancel',
      name: 'editor_color_effect_save_no',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get editor_color_effect_save_action {
    return Intl.message(
      'Save',
      name: 'editor_color_effect_save_action',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get editor_color_effect_name {
    return Intl.message(
      'Name',
      name: 'editor_color_effect_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the effect name`
  String get editor_color_effect_save_action_tip {
    return Intl.message(
      'Please enter the effect name',
      name: 'editor_color_effect_save_action_tip',
      desc: '',
      args: [],
    );
  }

  /// `Save effect successfully`
  String get editor_color_save_pf_successfully {
    return Intl.message(
      'Save effect successfully',
      name: 'editor_color_save_pf_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save effect`
  String get editor_color_save_pf_faild {
    return Intl.message(
      'Failed to save effect',
      name: 'editor_color_save_pf_faild',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<EditorLang> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<EditorLang> load(Locale locale) => EditorLang.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
