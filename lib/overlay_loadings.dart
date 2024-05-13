library overlay_loadings;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _defaultColor = Color(0x7E888888);
const _deafultWidget = CircularProgressIndicator();

class LoadingConfig {
  final Color backgroundColor;
  final Widget widget;
  const LoadingConfig({
    this.backgroundColor = _defaultColor,
    this.widget = _deafultWidget,
  });
  Widget build() {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: widget,
    );
  }
}

class LoadingsController with ChangeNotifier {
  final Map<String, LoadingConfig> _loadings;
  LoadingsController(this._loadings);
  bool _loading = false;
  String? _current;

  void on([String? name]) {
    _current = name;
    _loading = true;
    notifyListeners();
  }

  void off() {
    _current = null;
    _loading = false;
    notifyListeners();
  }

  bool get hasLoading => _loading;

  LoadingConfig get config => _loadings[_current] ?? _loadings['default']!;
}

class OverlayLoadings extends StatelessWidget {
  late final LoadingsController controller;
  OverlayLoadings(
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

extension OverlayLoadingsStateExtension on BuildContext {
  LoadingsController get loadingController => read<LoadingsController>();
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.isLoading,
    this.config = const LoadingConfig(),
    this.child,
  });
  final bool isLoading;
  final LoadingConfig config;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        if (isLoading) config.build(),
      ],
    );
  }
}

class LoadingBuilder extends StatefulWidget {
  const LoadingBuilder({
    super.key,
    this.config = const LoadingConfig(),
    required this.builder,
  });
  final LoadingConfig config;
  final Widget Function(BuildContext context, void Function(bool) setLoading)
      builder;

  @override
  State<LoadingBuilder> createState() => _LoadingBuilderState();
}

class _LoadingBuilderState extends State<LoadingBuilder> {
  bool isLoading = false;

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
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
