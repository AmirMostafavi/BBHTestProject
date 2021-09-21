import 'package:flutter/material.dart';

import 'bloc.dart';


class BlocProvider<T extends Bloc> extends StatefulWidget {
  const BlocProvider({Key? key, required this.bloc, required this.child}) : super(key: key);

  final Widget child;
  final T bloc;

  static T? of<T extends Bloc>(BuildContext context) {
    final type = _providerType<BlocProvider<T>>();
    final BlocProvider<T>? provider = context.findAncestorWidgetOfExactType() as BlocProvider<T>?;
    return provider?.bloc;
  }

  static Type _providerType<T>() => T;

  @override
  _BlocProviderState createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
