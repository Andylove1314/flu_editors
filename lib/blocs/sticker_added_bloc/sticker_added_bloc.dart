import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sticker_added_state.dart';

class StickerAddedCubit extends Cubit<StickerAddedState> {
  StickerAddedCubit(super.initialState){
    debugPrint('StickerAddedCubit create');
  }

  double? opacity;

  void updateOpacity(double value) {
    debugPrint('updateOpacity');
    opacity = value;
    emit(StickerAddedState(value));
  }
}
