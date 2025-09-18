/// Instance used for specify when imports.run.xml BLoC state is in imports.run.xml loading mode
abstract class LoadingState {
  static FakeLoading? fromBool(bool? value) {
    return value == true ? FakeLoading() : null;
  }
}

class FakeLoading extends LoadingState {}
