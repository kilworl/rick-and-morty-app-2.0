import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CharactersController extends GetxController {
  final GraphQLClient _graphQLClient = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink("https://rickandmortyapi.com/graphql"),
  );

  RxBool isLoading = false.obs;
  RxList<dynamic> characters = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoading.value = true;

    QueryResult queryResult = await _graphQLClient.query(
      QueryOptions(
        document: gql(
          """query {
            characters {
              results {
                id
                name
                image
                status
                species
                type
                gender
                origin {
                  name
                }
                location {
                  name
                }
              }
            }
          }""",
        ),
      ),
    );

    if (queryResult.hasException) {
      print(queryResult.exception);
    } else {
      characters.assignAll(queryResult.data!['characters']['results']);
    }

    isLoading.value = false;
  }
}
