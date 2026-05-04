part of '../flutter_artist_dio.dart';

class RestDebugScreen extends StatelessWidget {
  static const String routeName = "/debug-network-inspector";

  const RestDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Inspector"),
      ),
      body: const DebugNetworkInspectorView(
        showJson: true,
        showInScrollView: false,
        showToken: false,
      ),
    );
  }
}
