import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todos/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc_todos/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:flutter_bloc_todos/models/todos_filter_model.dart';

import '../models/todos_model.dart';
import 'add_todo_screeen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: const [
              Tab(
                icon: Icon(Icons.pending),
              ),
              Tab(
                icon: Icon(Icons.add_task),
              )
            ],
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context)
                      .add(const UpdateTodos(todosFilter: TodosFilter.pending));
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                      const UpdateTodos(todosFilter: TodosFilter.completed));
                  break;
              }
            },
          ),
        ),
        body: TabBarView(children: [
          _todos('Pending To Dos'),
          _todos('Completed To Dos'),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          ),
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  BlocBuilder<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocBuilder<TodosFilterBloc, TodosFilterState>(
      builder: (context, state) {
        //Check State
        if (state is TodosFilterLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TodosFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: (context, index) {
                    return _todoCard(context, state.filteredTodos[index]);
                  },
                )
              ],
            ),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Card _todoCard(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              todo.task,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.read<TodosBloc>().add(
                          UpdateTodo(todo: todo.copyWith(isCompleted: true)));
                    },
                    icon: const Icon(Icons.check)),
                IconButton(
                    onPressed: () {
                      context.read<TodosBloc>().add(DeleteTodo(todo: todo));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Delete ${todo.task} Complete.')));
                    },
                    icon: const Icon(Icons.cancel)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
