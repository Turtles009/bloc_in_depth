import 'package:flutter/foundation.dart' show immutable;

import 'person.dart';

const persons1Url = 'http://192.168.1.48:5500/api/persons1.json';
const persons2Url = 'http://192.168.1.48:5500/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonsLoader loader; //Dependency injection

  const LoadPersonAction({
    required this.url,
    required this.loader,
  }) : super();
}
