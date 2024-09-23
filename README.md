# loading_provider

Flutter package for easily displaying loading overlays with customizable configurations.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  loading_provider: ^1.0.0
```

## Usage

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
      loadings: {
        'loading1': LoadingConfig(
          backgroundColor: Colors.blue.withOpacity(0.5),
          widget: const Text('Loading'),
        ),
      },
    ),
  );
}
```

```dart
ElevatedButton(
  onPressed: () async {
    var loading = context.loadingController
    loading.on(); // Show loading overlay
    await Future.delayed(const Duration(seconds: 3));
    loading.off(); // Hide loading overlay
  },
  child: const Text('Loading'),
),
```

3. Use the `LoadingBuilder` widget to show loading overlays:

```dart
LoadingBuilder(
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
  child: Text('Loading...'),
);
```

## Customization

You can customize the loading overlay by providing a `LoadingConfig` object with your desired configurations:

```dart
LoadingConfig(
  backgroundColor: Colors.blue.withOpacity(0.5),
  widget: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Colors.white),
  ),
)
```

---

## Author

![Amit's Picture](https://lh3.googleusercontent.com/a/ACg8ocKT7DSe8Dbf4oh1hj83szOSYWxQVxs2UAwmDQ38Xb1ERL6c7pA=s432-c-no)

**GitHub:** [Amit Hasan](https://github.com/amitzero)

