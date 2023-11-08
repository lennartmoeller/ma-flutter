import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/skeleton.dart';

abstract class NavigablePage extends StatefulWidget {
  final GlobalKey<SkeletonState> skeletonKey;

  String get icon;

  String get title;

  const NavigablePage({super.key, required this.skeletonKey});
}

abstract class NavigablePageState<T extends NavigablePage, K> extends State<T> {
  late Future<K> futureData;

  String? get title => widget.title;

  String? get subtitle => null;

  Widget? get floatingActionButton => null;

  List<Widget> get headerLeading => [];

  List<Widget> get headerTrailing => [];

  Future<K> loadData();

  Widget content(K data);

  @override
  void initState() {
    super.initState();
    futureData = loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.skeletonKey.currentState!.config.title = title;
      widget.skeletonKey.currentState!.config.subtitle = subtitle;
      widget.skeletonKey.currentState!.config.fab = floatingActionButton;
      widget.skeletonKey.currentState!.config.headerLeading = headerLeading;
      widget.skeletonKey.currentState!.config.headerTrailing = headerTrailing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<K>(
      future: futureData,
      builder: (BuildContext context, AsyncSnapshot<K> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return content(snapshot.data as K);
        } else {
          return Center(child: Text("Beim Laden der Daten ist ein Fehler aufgetreten"));
        }
      },
    );
  }
}
