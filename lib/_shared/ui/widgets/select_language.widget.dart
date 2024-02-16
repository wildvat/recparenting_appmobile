import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';

class SelectLanguageWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
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
            child: TextDefault(
              'EN',
              color: (context.read<LanguageBloc>().state.language == 'en')
                  ? TextColors.white
                  : TextColors.muted,
            )),
        TextButton(
            onPressed: (context.read<LanguageBloc>().state.language == 'en')
                ? () => context
                    .read<LanguageBloc>()
                    .add(const LanguageEventUpdate('es'))
                : null,
            child: TextDefault(
              'ES',
              color: (context.read<LanguageBloc>().state.language == 'es')
                  ? TextColors.white
                  : TextColors.muted,
            ))
      ],
    );
  }
}
