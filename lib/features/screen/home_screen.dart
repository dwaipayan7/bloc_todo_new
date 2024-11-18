import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../data/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final Map<int, bool> _isFadingOut = {};

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App', style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.orangeAccent,
        // actions: [
        //   IconButton(
        //     onPressed: _showAddTodoDialog,
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoadedState) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return AnimatedOpacity(
                  opacity: _isFadingOut[index] == true ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) {
                          context.read<TodoBloc>().add(AlterTodo(index: index));
                        },
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(todo.subtitle),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(context, index),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is TodoErrorState) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No todos found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add, color: Colors.white,),
        splashColor: Colors.orange,
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }



  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _subtitleController,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16, // Text size
                  fontWeight: FontWeight.bold, // Text weight
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final todo = Todo(
                    title: _titleController.text,
                    subtitle: _subtitleController.text,
                  );
                  context.read<TodoBloc>().add(AddTodo(todo: todo));
                  _titleController.clear();
                  _subtitleController.clear();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  void _deleteItem(BuildContext context, int index) {
    setState(() {
      _isFadingOut[index] = true; // Start fade-out animation
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      context.read<TodoBloc>().add(RemoveTodo(index: index));
      setState(() {
        _isFadingOut.remove(index); // Clean up animation state
      });
    });
  }

}

