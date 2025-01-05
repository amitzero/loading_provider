# loading_provider

Flutter package for easily displaying loading overlays with customizable configurations.

1. Import the package:

```dart
import 'package:loading_provider/loading_provider.dart';
```

2. Wrap your `MaterialApp` or root widget with `LoadingProvider`:

```dart
void main() {
  runApp(
    LoadingProvider(
      appBuilder: (context, builder) => MaterialApp(
        home: const Home(),
        builder: builder,
      ),
      loadings: {  // Provide loading configurations with name to use later to show different loadings.
        'loading1': LoadingConfig(
          backgroundColor: Colors.blue.withOpacity(0.5),
          widget: const Text('Loading'),
        ),
        // add other loadings
      },
    ),
  );
}
```

```dart
ElevatedButton(
  onPressed: () async {
    var loading = context.loadingController
    loading.on(); // Show loading overlay. It will use default loading
    await Future.delayed(const Duration(seconds: 3));
    loading.off(); // Hide loading overlay
    loading.on('loading1');  // with name to use specific loading provided in [LoadingProvider]
    await Future.delayed(const Duration(seconds: 3));
    loading.off(); // Hide loading overlay
  },
  child: const Text('Loading'),
),
```

3. Use the `LoadingBuilder` widget to show loading overlays:

```dart
LoadingBuilder(
  config: const LoadingConfig(), // Optional or it will used default loading
  builder: (context, setLoading) {
    return ElevatedButton(
      onPressed: () async {
        setLoading(true); // Show loading overlay
        await Future.delayed(Duration(seconds: 2));
        setLoading(false); // Hide loading overlay
      },
      child: Text('Show Loading'),
    );
  },
);
```

4. Use the `LoadingWidget` widget to show loading overlays:

```dart
LoadingWidget(
  isLoading: true,
  config: const LoadingConfig(), // Optional or it will used default loading
  child: Text('Loading...'),
);
```

## Customization

You can customize the loading overlay by providing a `LoadingConfig` object with your desired configurations:

```dart
LoadingConfig(
  backgroundColor: Colors.blue.withValues(alpha: 0.5),
  widget: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Colors.white),
  ),
)
```

---

## Author

![Amit's Picture](https://lh3.googleusercontent.com/a/ACg8ocKT7DSe8Dbf4oh1hj83szOSYWxQVxs2UAwmDQ38Xb1ERL6c7pA=s432-c-no)

**GitHub:** [Amit Hasan](https://github.com/amitzero)

