import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';

class SelectLanguageWidget extends StatelessWidget {
  SelectLanguageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: (context.read<LanguageBloc>().state.language == 'es')
                ? () => context
                    .read<LanguageBloc>()
                    .add(const LanguageEventUpdate('en'))
                : null,
            child: Text(
              'EN',
              style: TextStyle(
                  color: (context.read<LanguageBloc>().state.language == 'es')
                      ? Colors.white
                      : Colors.white54),
            )),
        TextButton(
            onPressed: (context.read<LanguageBloc>().state.language == 'en')
                ? () => context
                    .read<LanguageBloc>()
                    .add(const LanguageEventUpdate('es'))
                : null,
            child: Text('ES',
                style: TextStyle(
                  color: (context.read<LanguageBloc>().state.language == 'en')
                      ? Colors.white
                      : Colors.white54,
                )))
      ],
    );
  }
}
