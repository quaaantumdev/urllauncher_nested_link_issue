import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/post/:postId',
        builder: (context, state) => PostPage(
          postId: state.pathParameters['postId']!,
        ),
      ),
      GoRoute(
        path: '/user/:userId',
        builder: (context, state) => UserPage(
          userId: state.pathParameters['userId']!,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Demo',
      routerConfig: _router,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Home'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                final postId = DummyData.postIdForIndex(index: index);
                final userId = DummyData.userIdForPost(postId: postId);
                return _buildSinglePost(
                    context: context, postId: postId, userId: userId);
              },
              itemCount: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinglePost({
    required BuildContext context,
    required String postId,
    required String userId,
  }) {
    return Card(
      /// here is the [Link] widget that creates the the "outer layer"
      child: Link(
        uri: Uri.parse('/post/$postId'),
        builder: (context, followLink) => InkWell(
          onTap: followLink,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('A short post that goes by the id $postId. '
                    'Clicking this outer InkWell should open page for post $postId.'),
              ),

              /// here is the [Link] widget that creates the the "inner layer"
              Link(
                uri: Uri.parse('/user/$userId'),
                builder: (context, followLink) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: InkWell(
                      onTap: followLink,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: const Color(0xcccccccc))),
                        padding: const EdgeInsets.all(16),
                        child: Text('Attributed to user $userId. '
                            'Clicking this inner InkWell should open the page for user $userId.'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostPage extends StatelessWidget {
  final String postId;
  const PostPage({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: BackButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
            title: Text('Post $postId'),
          ),
        ],
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  final String userId;
  const UserPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: BackButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
            title: Text('User $userId'),
          ),
        ],
      ),
    );
  }
}

class DummyData {
  static String postIdForIndex({required int index}) {
    return 'post-$index';
  }

  static String userIdForPost({required String postId}) {
    final nr = (postId.hashCode % 100);
    return 'user-$nr';
  }
}
