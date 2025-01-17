import 'package:flutter/material.dart';
import 'package:loading_provider/loading_provider.dart';

void main() {
  runApp(const MainApp());
}

/// The main application widget.
class MainApp extends StatelessWidget {
  /// Creates a [MainApp] widget.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      appBuilder: (context, builder) => MaterialApp(
        home: const Home(),
        builder: builder,
      ),
      loadings: {
        'load1': LoadingConfig(
          backgroundColor: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.5),
          widget: const Text('Loading'),
        ),
      },
    );
  }
}

/// The main home widget of the app.
class Home extends StatelessWidget {
  /// Creates a [Home] widget.
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Hello World!'),
            ElevatedButton(
              onPressed: () async {
                var loading = context.loadingController..on();
                await Future.delayed(const Duration(seconds: 3));
                loading.off();
              },
              child: const Text('Loading'),
            ),
            const Center(
              child: SizedBox(
                height: 100,
                // width: 100,
                child: LoadingWidget(
                  isLoading: true,
                  child: Text('Loading 1'),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 100,
                child: LoadingBuilder(
                  builder: (context, setLoading) {
                    return ElevatedButton(
                      onPressed: () async {
                        setLoading(true);
                        await Future.delayed(const Duration(seconds: 2));
                        setLoading(false);
                      },
                      child: const Text('Loading 2'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
