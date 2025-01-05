library loading_provider;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Configuration for [LoadingProvider].
///
/// You can use [LoadingProvider] to manage loadings in your application.
class LoadingConfig {
  /// The background color of the loading. If not specified, it will be
  /// [Theme.of(context).colorScheme.primaryContainer] with 0.3 opacity.
  final Color? backgroundColor;

  /// The widget to show when loading. If not specified, it will be a
  /// [CircularProgressIndicator].
  final Widget widget;

  /// Creates a new [LoadingConfig].
  ///
  /// [backgroundColor] is the background color of the loading. If not specified,
  /// it will be [Theme.of(context).colorScheme.primaryContainer] with 0.3
  /// opacity.
  ///
  /// [widget] is the widget to show when loading. If not specified, it will be a
  /// [CircularProgressIndicator].
  const LoadingConfig({
    this.backgroundColor,
    this.widget = const CircularProgressIndicator(),
  });

  /// Builds the loading widget.
  ///
  /// The [context] is the build context to use to build the widget.
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ??
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      alignment: Alignment.center,
      child: widget,
    );
  }
}

/// Controls the loadings of the application.
class LoadingsController with ChangeNotifier {
  /// The configurations for the loadings.
  final Map<String, LoadingConfig> _loadings;
  LoadingsController(this._loadings);

  /// Whether there's a loading happening.
  bool _loading = false;

  /// The name of the current loading, or null if there's no loading.
  String? _current;

  /// Starts a loading with the given [name]. If [name] is null, it will be
  /// the default loading.
  void on([String? name]) {
    _current = name;
    _loading = true;
    notifyListeners();
  }

  /// Stops the current loading.
  void off() {
    _current = null;
    _loading = false;
    notifyListeners();
  }

  /// Executes a function and shows a loading during the execution of the
  /// function. The function should return a [Future] that resolves to the result
  /// of the function.
  Future<dynamic> resolve(Future<dynamic> Function() func) async {
    on();
    try {
      var result = await func();
      return result;
    } finally {
      off();
    }
  }

  /// Whether there's a loading happening.
  bool get hasLoading => _loading;

  /// The configuration for the current loading.
  LoadingConfig get config => _loadings[_current] ?? _loadings['default']!;
}

/// A widget that provides the [LoadingsController] to its descendants using the
/// [ChangeNotifierProvider] widget.
///
/// This widget is used to provide the [LoadingsController] to the app, so that
/// you can use the [loadingController] extension to access the controller from
/// any [BuildContext] in the app.
///
/// The [appBuilder] parameter is a function that takes a [BuildContext] and a
/// function that builds the app. The [appBuilder] function is called with the
/// [BuildContext] of the [LoadingProvider] widget, and the function that builds
/// the app is called with the [BuildContext] of the [LoadingProvider] widget and
/// a function that builds the app. The function that builds the app is called
/// with the [BuildContext] of the [LoadingProvider] widget.
///
/// The [loadings] parameter is a map of loading names to [LoadingConfig]
/// objects. If the [loadings] parameter is not provided, an empty map is used.
/// The default loading is named 'default', and the [LoadingConfig] object for
/// the default loading is created with the default constructor.
///
/// The [LoadingProvider] widget is intended to be used as the root widget of
/// the app, or at least as the parent of the widgets that use the
/// [loadingController] extension to access the [LoadingsController] object.
class LoadingProvider extends StatelessWidget {
  late final LoadingsController controller;
  LoadingProvider(
      {super.key,
      required this.appBuilder,
      Map<String, LoadingConfig>? loadings}) {
    controller = LoadingsController(
        (loadings ?? {})..putIfAbsent('default', () => const LoadingConfig()));
  }
  final Widget Function(
      BuildContext, Widget Function(BuildContext, Widget?) builder) appBuilder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, _) {
        return appBuilder(
          context,
          (context, child) {
            var controller = context.watch<LoadingsController>();
            return LoadingWidget(
              isLoading: controller.hasLoading,
              config: controller.config,
              child: child,
            );
          },
        );
      },
    );
  }
}

/// An extension on [BuildContext] that provides the [LoadingsController]
/// instance associated with the context.
extension LoadingProviderStateExtension on BuildContext {
  /// The [LoadingsController] instance associated with the context.
  LoadingsController get loadingController => read<LoadingsController>();
}

/// A widget that shows a loading widget based on the [isLoading] flag.
///
/// The [isLoading] flag determines whether the loading widget should be shown.
/// If [isLoading] is true, the loading widget is shown. Otherwise, the child
/// widget is shown.
///
/// The [config] parameter is the configuration for the loading widget. If not
/// specified, the default configuration is used.
///
/// The [child] parameter is the child widget to show when the loading widget is
/// not shown. If not specified, the child widget is null.
class LoadingWidget extends StatelessWidget {
  /// Creates a new [LoadingWidget].
  const LoadingWidget({
    super.key,
    required this.isLoading,
    this.config = const LoadingConfig(),
    this.child,
  });

  /// The flag that determines whether the loading widget should be shown.
  final bool isLoading;

  /// The configuration for the loading widget.
  final LoadingConfig config;

  /// The child widget to show when the loading widget is not shown.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        if (isLoading) config.build(context),
      ],
    );
  }
}

/// A widget that allows the user to show a loading widget by calling the
/// [setLoading] callback.
class LoadingBuilder extends StatefulWidget {
  /// Creates a new [LoadingBuilder].
  const LoadingBuilder({
    super.key,
    this.config = const LoadingConfig(),
    required this.builder,
  });

  /// The configuration for the loading widget.
  final LoadingConfig config;

  /// The callback that is called with the [setLoading] callback. The callback
  /// should return a widget that is shown when the loading widget is not shown.
  final Widget Function(BuildContext context, void Function(bool) setLoading)
      builder;

  @override
  State<LoadingBuilder> createState() => _LoadingBuilderState();
}

/// State for the [LoadingBuilder] widget, which manages the loading state.
class _LoadingBuilderState extends State<LoadingBuilder> {
  /// Indicates whether the loading widget should be displayed.
  bool isLoading = false;

  /// Sets the loading state and updates the UI if the [State] is still mounted.
  ///
  /// [isLoading] determines whether the loading widget should be shown.
  void setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        this.isLoading = isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: isLoading,
      config: widget.config,
      child: widget.builder(context, setLoading),
    );
  }
}
