import 'package:flutter/material.dart';

import '../screens/StoreDetails.dart';

class StoreGrid extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final List<dynamic> stores;
  final String searchQuery;

  StoreGrid({
    required this.isLoading,
    required this.errorMessage,
    required this.stores,
    required this.searchQuery,
  });

  String getImageUrl(String relativePath) {
    final baseUrl = 'http://10.0.2.2:3000'; 
    return '$baseUrl$relativePath';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 0, 11, 20),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : stores.isEmpty
                  ? Center(child: Text('No stores available'))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        if (store['name']
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase())) {
                          final imageUrl = getImageUrl(store['pictureUrl']);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoreDetailsPage(
                                    store: store,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 236, 243, 248),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0)),
                                      child: Container(
                                        width: double.infinity,
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.fill,
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 50,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      store['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
    );
  }
}
