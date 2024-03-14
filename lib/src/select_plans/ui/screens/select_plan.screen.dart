import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/select_plans/models/products.model.dart';
import 'package:recparenting/src/select_plans/providers/stripe.provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SelectPlanScreen extends StatefulWidget {
  const SelectPlanScreen({super.key});

  @override
  State<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  late final Future<Products> _getPlans;

  @override
  void initState() {
    super.initState();
    _getPlans = StripeApi().getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.selectPlanTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: _getPlans,
                  builder:
                      (BuildContext context, AsyncSnapshot<Products> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        print(snapshot.data!.list);
                        if (snapshot.data!.list.isEmpty) {
                          return const Text('No plans');
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.list.length,
                            itemBuilder: (BuildContext context, int index) {
                              final WebViewController webController =
                                  WebViewController()..loadHtmlString("""
                                      <!DOCTYPE html>
                                        <html>
                                          <head><meta name="viewport" content="width=device-width, initial-scale=0.7"></head>
                                          <style>strong{font-size: 1.4rem;}</style>
                                          <body style='"margin: 0; padding: 0; overflow:hidden'>                                            
                                            ${snapshot.data!.list[index]!.description}
                                          </body>
                                        </html>
                                      """);
                              return ListTile(
                                onTap: () {
                                  Navigator.pushNamed(context, webPageRoute,
                                      arguments: WebpageArguments(
                                          url:
                                              'https://app.recparenting.com/register?price=${snapshot.data!.list[index]!.price}&product=${snapshot.data!.list[index]!.id}&currency=eur&lang=en',
                                          title: AppLocalizations.of(context)!
                                              .register));
                                  print(
                                      'tapped ${snapshot.data!.list[index]!.price}');
                                },
                                titleAlignment: ListTileTitleAlignment.top,
                                title: Row(
                                  children: [
                                    TitleDefault(
                                      snapshot.data!.list[index]!.name,
                                      size: TitleSize.large,
                                    ),
                                    TitleDefault(
                                      ' | ${snapshot.data!.list[index]!.amount}€/year',
                                      color: TextColors.rec,
                                    )
                                  ],
                                ),
                                subtitle: SizedBox(
                                  height: 150,
                                  child: WebViewWidget(
                                    controller: webController,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: colorRec,
                                ),
                              );
                            });
                      }
                    }
                    return const CircularProgressIndicator();
                  })
            ],
          ),
        ));
  }
}
