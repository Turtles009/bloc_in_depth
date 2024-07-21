import 'dart:convert';
import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/bloc_actions.dart';
import 'bloc/person.dart';
import 'bloc/persons_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const HomePage(),
      ),
    );
  }
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((request) => request.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<PersonsBloc>().add(
                            const LoadPersonAction(
                              url: persons1Url,
                              loader: getPersons,
                            ),
                          );
                    },
                    child: const Text('Load Person #1 API'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<PersonsBloc>().add(
                            const LoadPersonAction(
                              url: persons2Url,
                              loader: getPersons,
                            ),
                          );
                    },
                    child: const Text('Load Person #2 API'),
                  ),
                ],
              ),
              BlocBuilder<PersonsBloc, FetchResult?>(
                builder: (context, fetchResult) {
                  fetchResult?.log();
                  final persons = fetchResult?.persons;
                  if (persons == null) {
                    return const SizedBox.shrink();
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        final person = persons[index]!;
                        return ListTile(
                          title: Text(person.name),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
