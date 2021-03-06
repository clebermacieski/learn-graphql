import 'package:app_boilerplate/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config {
  static final HttpLink httpLink = HttpLink(
    uri: 'https://hasura.io/learn/graphql',
  );

  static final AuthLink authLink =
      AuthLink(getToken: () async => await sharedPreferenceService.token);

  static final WebSocketLink websocketLink = WebSocketLink(
    url: 'wss://hasura.io/learn/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      initPayload: {
        'headers': {
          'Authorization': () async => await sharedPreferenceService.token
        },
      },
    ),
  );

  static final Link link = authLink.concat(httpLink).concat(websocketLink);

  static ValueNotifier<GraphQLClient> initializeClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
        link: link,
      ),
    );
    return client;
  }
}
