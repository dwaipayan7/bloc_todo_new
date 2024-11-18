part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

class TodoLoadingState extends TodoState{}

class TodoLoadedState extends TodoState{

  final List<Todo> todos;

  TodoLoadedState({required this.todos});
}

class TodoErrorState extends TodoState{
  final String message;

  TodoErrorState({required this.message});
}
