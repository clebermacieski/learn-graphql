import 'package:app_boilerplate/components/add_task.dart';
import 'package:app_boilerplate/components/todo_item_tile.dart';
import 'package:app_boilerplate/data/todo_fetch.dart';
import 'package:app_boilerplate/model/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class All extends StatefulWidget {
  All({Key key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  void initState() {
    super.initState();
  }

  VoidCallback refetchQuery;

  @override
  Widget build(BuildContext context) {
    print("All tab");
    return Column(
      children: <Widget>[
        Mutation(
          options: MutationOptions(
            documentNode: gql(TodoFetch.addTodo),
            onCompleted: (dynamic resultData) {
              refetchQuery();
            },
          ),
          builder: (RunMutation runMutation,
              QueryResult result,) {
            return AddTask(
              onAdd: (value) {
                runMutation({"title": value, "isPublic": false});
              },
            );
          },
        ),
        Expanded(
          child: Query(
            options: QueryOptions(
              documentNode: gql(TodoFetch.fetchAll),
              variables: {
                "is_public": false,
              },
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              refetchQuery = refetch;

              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.loading) {
                return Text("Carregando");
              }
              final List<LazyCacheMap> todos =
              (result.data["todos"] as List<dynamic>).cast<LazyCacheMap>();

              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  dynamic responseData = todos[index];
                  return TodoItemTile(
                    item: TodoItem.fromElements(responseData["id"],
                        responseData["title"], responseData["is_completed"]),
                    toggleDocument: TodoFetch.toggleTodo,
                    toggleRunMutation: {
                      'id': responseData["id"],
                      'isCompleted': !responseData['is_completed']
                    },
                    deleteDocument: TodoFetch.deleteTodo,
                    deleteRunMutaion: {
                      'id': responseData["id"],
                    },
                    refetchQuery: refetchQuery,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
