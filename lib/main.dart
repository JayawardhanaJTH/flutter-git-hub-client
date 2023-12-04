import 'package:flutter/material.dart';
import 'package:git_client/github_login.dart';
import 'package:git_client/github_oauth_credentials.dart';
import 'package:git_client/github_summary.dart';
import 'package:github/github.dart';
import 'package:window_to_front/window_to_front.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
        builder: (context, httpClient) {
          WindowToFront.activate();
          return FutureBuilder(
              future: viewerDetails(httpClient.credentials.accessToken),
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(title),
                    elevation: 2,
                  ),
                  body: GithubSummary(
                      gitHub: _getGitHub(httpClient.credentials.accessToken)),
                  // body: Center(
                  //   child: Text(snapshot.hasData
                  //       ? 'Hello ${snapshot.data!.login}!'
                  //       : 'Retrieving viewer login details...'),
                  // ),
                );
              });
        },
        githubClientId: githubClientId,
        githubClientSecret: githubClientSecret,
        githubScopes: githubClientScopes);
  }
}

Future<CurrentUser> viewerDetails(String accessTocken) async {
  final github = GitHub(auth: Authentication.withToken(accessTocken));
  return github.users.getCurrentUser();
}

GitHub _getGitHub(String accessToken) {
  return GitHub(auth: Authentication.withToken(accessToken));
}
