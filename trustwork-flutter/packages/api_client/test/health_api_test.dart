import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for HealthApi
void main() {
  final instance = ApiClient().getHealthApi();

  group(HealthApi, () {
    // Health Check
    //
    // Basic health check — verifies the app is running and DB is reachable.
    //
    //Future<BuiltMap<String, JsonObject>> healthCheckHealthGet() async
    test('test healthCheckHealthGet', () async {
      // TODO
    });

  });
}
