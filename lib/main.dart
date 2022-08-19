import 'package:flutter/material.dart';
import 'package:flutter_bloc_todos/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todos/blocs/todos_filter/todos_filter_bloc.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodosBloc()..add(const LoadTodos())),
        BlocProvider(
            create: (context) => TodosFilterBloc(
                todosBloc: BlocProvider.of<TodosBloc>(context))),
      ],
      child: MaterialApp(
        title: 'Bloc Pattern - Todos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'BLoC To Dos'),
      ),
    );
  }
}
