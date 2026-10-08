import 'dart:developer';
import '../network/network.dart';
import 'abstract_preference_client.dart';
import 'abstract_preference_manager.dart';
import 'preference_manager.dart';
import 'shared_preferences_client.dart';

/// Example demonstrating Dependency Injection, storing/retrieving authToken & login status,
/// and wiring [AbstractPreferenceManager] directly into [DioNetworkClient].
class PreferenceClientExample {
  final AbstractPreferenceManager preferenceManager;

  PreferenceClientExample({AbstractPreferenceManager? manager})
      : preferenceManager = manager ??
            PreferenceManager(
              preferenceClient: SharedPreferencesClient(),
              onUnauthenticatedCallback: () {
                log('Callback: User session invalidated.');
              },
            );

  /// Example 1: Storing authToken and updating isLoggedIn flag.
  Future<void> loginUser({required String token}) async {
    log('--> Saving Auth Token and setting isLoggedIn = true');
    await preferenceManager.saveAuthSession(token: token, isLoggedIn: true);

    final bool status = await preferenceManager.isLoggedIn;
    final String? storedToken = await preferenceManager.authToken;

    log('Verified Storage -> isLoggedIn: $status, authToken: $storedToken');
  }

  /// Example 2: Inspecting session state asynchronously.
  Future<void> checkSessionState() async {
    final bool loggedIn = await preferenceManager.isLoggedIn;
    final String? token = await preferenceManager.authToken;

    log('Current Session -> Logged In: $loggedIn, Token: $token');
  }

  /// Example 3: Clearing stored auth session on logout.
  Future<void> logoutUser() async {
    log('--> Clearing Auth Session');
    await preferenceManager.clearAuthSession();

    final bool status = await preferenceManager.isLoggedIn;
    final String? token = await preferenceManager.authToken;

    log('Post-Logout Session -> Logged In: $status, Token: $token');
  }
}

/// Executable scenario showcasing initialization and integration with Network Client.
Future<void> runPreferenceManagerExample() async {
  final AbstractPreferenceClient preferenceClient = SharedPreferencesClient();
  final AbstractPreferenceManager prefManager = PreferenceManager(
    preferenceClient: preferenceClient,
    onUnauthenticatedCallback: () {
      log('Unauthenticated event received -> Navigating to Login.');
    },
  );

  final example = PreferenceClientExample(manager: prefManager);

  // Perform login
  await example.loginUser(token: 'sample_jwt_bearer_token_998877');

  // Inject PreferenceManager directly into DioNetworkClient
  final AbstractNetworkClient networkClient = DioNetworkClient(
    authSession: prefManager, // AbstractPreferenceManager implements AbstractAuthSession interface!
    enableLogging: true,
  );

  log('Network Client successfully wired with PreferenceManager as AbstractAuthSession!');
  log('Network Client Base URL: ${networkClient.baseUrl}');

  // Perform logout
  await example.logoutUser();
}
