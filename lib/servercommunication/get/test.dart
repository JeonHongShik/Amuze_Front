import 'package:amuze/servercommunication/get/stage_priview_get_server.dart';
import 'package:flutter/material.dart';

class DataDisplayWidget extends StatefulWidget {
  const DataDisplayWidget({super.key});

  @override
  _DataDisplayWidgetState createState() => _DataDisplayWidgetState();
}

class _DataDisplayWidgetState extends State<DataDisplayWidget> {
  late Future<List<StagePreviewServerData>> serverData;

  @override
  void initState() {
    super.initState();
    serverData = stagepreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<StagePreviewServerData>>(
        future: serverData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return Column(
                  children: <Widget>[
                    data.title != null
                        ? Text('Title: ${data.title}')
                        : const SizedBox.shrink(),
                    data.region!.isNotEmpty
                        ? Text('Region: ${data.region}')
                        : const SizedBox.shrink(),
                  ],
                );
              },
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }
}
