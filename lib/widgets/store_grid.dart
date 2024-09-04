
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
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
                        childAspectRatio: 1.5,
                      ),
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        if (store['name']
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase())) {
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      store['pictureUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object error, StackTrace? stackTrace) {
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      store['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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