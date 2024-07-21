import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_in_depth/bloc/bloc_actions.dart';
import 'package:bloc_in_depth/bloc/persons_bloc.dart';
import 'package:bloc_in_depth/bloc/person.dart';

const mockedPersons1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockedPersons2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing bloc', () {
    // Write our test
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    // Fetch mock data (persons1) and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons form first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_1',
            loader: mockGetPersons1,
          ),
        );
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_1',
            loader: mockGetPersons1,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: true,
        ),
      ],
    );

    // Fetch mock data (persons2) and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons form second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_2',
            loader: mockGetPersons2,
          ),
        );
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_2',
            loader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: true,
        ),
      ],
    );
  });
}
