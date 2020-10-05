import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplayground19/api/api.dart';
import 'package:iplayground19/bloc/data_bloc.dart';
import 'package:iplayground19/bloc/notification.dart';
import 'package:iplayground19/components/session_card.dart';

class FavoritePage extends StatefulWidget {
  final ScrollController scrollController;

  FavoritePage({Key key, this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    DataBloc dataBloc = BlocProvider.of(context);
    // ignore: close_sinks
    NotificationBloc notificationBloc = BlocProvider.of(context);

    var content = BlocBuilder<DataBloc, DataBlocState>(
      cubit: dataBloc,
      builder: (context, dataState) {
        if (dataState is DataBlocLoadingState) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('載入中，請稍候…'),
                  SizedBox(height: 20),
                  CupertinoActivityIndicator(),
                ],
              ),
            ),
          );
        }

        if (dataState is DataBlocErrorState) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('載入時發生問題'),
                  CupertinoButton(
                    child: Text('重試'),
                    onPressed: () {
                      dataBloc.add(DataBlocEvent.load);
                    },
                  ),
                ],
              ),
            ),
          );
        }

        if (dataState is DataBlocLoadedState) {
          return BlocBuilder<NotificationBloc, NotificationBlocState>(
            cubit: notificationBloc,
            builder: (context, notificationState) {
              if (notificationState is NotificationBlocLoadedState) {
                final saved = notificationState.sessions;
                if (saved.isEmpty) {
                  return SafeArea(
                      child: Center(
                          child: Text(
                    '您還沒有任何最愛的議程',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle,
                  )));
                }
                final all = dataState.sessions;
                final filtered = all.keys
                    .where((x) => saved.contains(x))
                    .map((x) => all[x])
                    .cast<Session>()
                    .toList();
                filtered.sort();

                var slivers = <Widget>[];
                slivers.add(SliverToBoxAdapter(
                    child:
                        SizedBox(height: MediaQuery.of(context).padding.top)));
                slivers.add(SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final session = filtered[index];
                    final id = session.proposalId.substring(5);
                    final program = dataState.programs[id];
                    final card = SessionCard(
                      session: session,
                      program: program,
                      showDetails: true,
                    );
                    return card;
                  },
                  childCount: filtered.length,
                )));

                slivers.add(SliverToBoxAdapter(child: SizedBox(height: 30)));
                slivers.add(SliverToBoxAdapter(
                    child: SizedBox(
                        height: MediaQuery.of(context).padding.bottom)));

                return CustomScrollView(
                  slivers: slivers,
                  controller: widget.scrollController,
                );
              }
              return Container();
            },
          );
        }

        return Container();
      },
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('我的最愛'),
      ),
      child: Scaffold(
        body: Scrollbar(child: content),
      ),
    );
  }
}
