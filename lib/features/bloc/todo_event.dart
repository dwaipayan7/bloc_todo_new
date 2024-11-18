part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class TodoStarted extends TodoEvent{}

class AddTodo extends TodoEvent{

  final Todo todo;

  AddTodo({required this.todo});

}

class RemoveTodo extends TodoEvent{

  final int index;

  RemoveTodo({required this.index});

}

class AlterTodo extends TodoEvent{
  final int index;

  AlterTodo({required this.index});
}




