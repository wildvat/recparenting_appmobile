import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class TherapistBioHeaderWidget extends StatelessWidget {
  const TherapistBioHeaderWidget({
    super.key,
    required Therapist? therapist,
  }) : _therapist = therapist;

  final Therapist? _therapist;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      color: colorRecDark,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              child: _therapist!.avatar.contains('/avatar/user')
                  ? SvgPicture.network(
                      _therapist!.avatar,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      _therapist!.avatar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '${_therapist!.name} ${_therapist!.lastname}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {
              // todo add ask for change therapist
              showModalBottomSheet<void>(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text(
                              'Formulario de cambio de terapeuta',
                              style: TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              child: const Text('Enviar'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ));
                  });
            },
            icon: const Icon(Icons.sync_problem),
            label: Text(AppLocalizations.of(context)!.terapistChangeButton),
          ),
        ],
      ),
    );
  }
}