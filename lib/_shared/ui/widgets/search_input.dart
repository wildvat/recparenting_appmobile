import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';

class SearchInputForm extends StatefulWidget {
  const SearchInputForm(
      {this.onFieldSubmitted, this.onTap, this.readOnly = false, Key? key})
      : super(key: key);
  final ValueSetter? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  SearchInputFormState createState() => SearchInputFormState();
}

class SearchInputFormState extends State<SearchInputForm> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
          key: _key,
          child: TextFormField(
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onFieldSubmitted,
            controller: _searchController,
            //style: TextStyle(color: color),
            validator: (search) {
              if (search == null || search.isEmpty) {
                return AppLocalizations.of(context)!.fieldIncomplete;
              }
              return null;
            },
            style: TextStyle(color: TextColors.white.color),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintStyle: const TextStyle(color: Colors.white),
                hintText: AppLocalizations.of(context)!.generalSearch,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                )),
          )),
    );
  }
}
