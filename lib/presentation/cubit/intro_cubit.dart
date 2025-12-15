import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/local/intro_data.dart';

class IntroCubit extends Cubit<int> {
  IntroCubit() : super(0);

  void setPage(int index) => emit(index);

  void nextPage() {
    if (state < pages.length - 1) {
      emit(state + 1);
    }
  }

  void prevPage() {
    if (state > 0) {
      emit(state - 1);
    }
  }
}
