import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesBloc();
    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News!'),
      ),
      body: BuildList(bloc),
    );
  }

  Widget BuildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Refresh(
            ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return NewsListTile(
                  itemId: snapshot.data[index],
                );
              },
            ),
        );
      },
    );
  }
}