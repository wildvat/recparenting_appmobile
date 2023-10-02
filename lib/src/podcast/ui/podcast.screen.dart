import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/router_names.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, webPageRoute,
          arguments: WebpageArguments(
            url: 'https://www.recparenting.com/masterclasses/',
            title: 'Podcasts',
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: 'Podcast',
        body: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
