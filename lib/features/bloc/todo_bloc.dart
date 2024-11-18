import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import '../data/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<TodoStarted>(_onStarted);
    on<AddTodo>(_onAdd);
    on<RemoveTodo>(_onRemove);
    on<AlterTodo>(_onAlter);
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    try {
      final todos = (json['todos'] as List)
          .map((todoJson) => Todo.fromJson(todoJson as Map<String, dynamic>))
          .toList();
      return TodoLoadedState(todos: todos);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    if (state is TodoLoadedState) {
      return {
        'todos': state.todos.map((todo) => todo.toJson()).toList(),
      };
    }
    return null;
  }

  FutureOr<void> _onStarted(TodoStarted event, Emitter<TodoState> emit) {
    if (state is TodoInitial) {
      emit(TodoLoadingState());
      // Assuming initial state is empty list of todos
      emit(TodoLoadedState(todos: []));
    }
  }

  FutureOr<void> _onAdd(AddTodo event, Emitter<TodoState> emit) {
    if (state is TodoLoadedState) {
      final currentState = state as TodoLoadedState;
      final updatedTodos = List<Todo>.from(currentState.todos)..add(event.todo);
      emit(TodoLoadedState(todos: updatedTodos));
    }
  }

  FutureOr<void> _onRemove(RemoveTodo event, Emitter<TodoState> emit) {
    if (state is TodoLoadedState) {
      final currentState = state as TodoLoadedState;
      final updatedTodos = List<Todo>.from(currentState.todos)
        ..removeAt(event.index);
      emit(TodoLoadedState(todos: updatedTodos));
    }
  }

  FutureOr<void> _onAlter(AlterTodo event, Emitter<TodoState> emit) {
    if (state is TodoLoadedState) {
      final currentState = state as TodoLoadedState;
      final updatedTodos = List<Todo>.from(currentState.todos);
      final todo = updatedTodos[event.index];
      updatedTodos[event.index] = todo.copyWith(isDone: !todo.isDone);
      emit(TodoLoadedState(todos: updatedTodos));
    }
  }
}
