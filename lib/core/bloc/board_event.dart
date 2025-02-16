class BoardEvent {}

class MakeMoveEvent extends BoardEvent{
  int cellIndex;
  MakeMoveEvent(this.cellIndex);
}

class ResetGameEvent extends BoardEvent {}
