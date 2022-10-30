import 'package:dio/dio.dart';
import 'package:evince_test/pages/detail_page.dart';
import 'package:evince_test/services/network_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final networkService = NetworkService(Dio());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: networkService.getAudios(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.error.toString(),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
                child: Center(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(audio: data[index]),
                            ),
                          ),
                          tileColor: Colors.brown[50],
                          selectedTileColor: Colors.brown[200],
                          contentPadding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(data[index].title),
                          ),
                          subtitle: Text(data[index].description),
                        ),
                      ),
                    ),
                    itemCount: data.length,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
