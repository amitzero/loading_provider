```markdown
# loading_provider

Amit's Flutter package for easily displaying loading overlays with customizable configurations.

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
      appBuilder: (context, child) {
        return MaterialApp(
          title: 'My App',
          home: MyHomePage(),
        );
      },
    ),
  );
}
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

![Amit's Picture](https://avatars.githubusercontent.com/u/66168865)

**GitHub:** [Amit Hasan](https://github.com/amitzero)
```
