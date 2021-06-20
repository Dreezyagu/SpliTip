import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splitip_state.dart';

class SplitipCubit extends Cubit<SplitipState> {
  SplitipCubit() : super(SplitipQuestion1());

  int _question = 1;
  int get question => _question;

  set questioning(int questn) {
    try {
      _question = questn;
      switch (questn) {
        case 1:
          emit(SplitipQuestion1());
          break;
        case 2:
          emit(SplitipQuestion2());
          break;
        case 3:
          emit(SplitipQuestion3());

          break;
        case 4:
          emit(SplitipResult());
          break;

        default:
      }
    } catch (e) {}
  }
}
