import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SquareAnimation());
  }
}

/// [Widget] displaying the SquareAnimation page consisting of a square
/// and the buttons.
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

/// State of a [SquareAnimation].
class SquareAnimationState extends State<SquareAnimation> {
  /// The size of the square.
  static const _squareSize = 50.0;

  /// A global key to access the state of the [SquareSlideTransition] widget.
  final GlobalKey<SquareSlideTransitionState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        SquareSlideTransition(
          key: globalKey,
          squareSize: _squareSize,
          updateSquareAnimationState: () {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  !((globalKey.currentState?.controller.isAnimating ?? false) ||
                          !(globalKey.currentState?.controller.value != 1))
                      ? () {
                          setState(() {
                            globalKey.currentState?.controller.animateTo(1);
                          });
                        }
                      : null,
              child: const Text('Right'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed:
                  !((globalKey.currentState?.controller.isAnimating ?? false) ||
                          !(globalKey.currentState?.controller.value != -1))
                      ? () {
                          setState(() {
                            globalKey.currentState?.controller.animateTo(-1);
                          });
                        }
                      : null,
              child: const Text('Left'),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// A widget that embodies the realization of the square animation.
///
/// This widget uses an [AnimationController] to animate the position of square
/// horizontally based on the controller's value.
class SquareSlideTransition extends StatefulWidget {
  /// Creates a [SquareSlideTransition] widget.
  ///
  /// - [squareSize]: The size of the square.
  /// - [updateSquareAnimationState]: A callback to notify the parent widget
  ///   when the animation state changes.
  const SquareSlideTransition(
      {super.key,
      required this.squareSize,
      required this.updateSquareAnimationState});

  /// The size of the square.
  final double squareSize;

  /// A callback to notify the parent widget when the animation state changes.
  final VoidCallback updateSquareAnimationState;

  @override
  State<SquareSlideTransition> createState() => SquareSlideTransitionState();
}

/// The state of the [SquareSlideTransition] widget.
///
/// This class manages the [AnimationController] and updates the position of
/// square based on the controller's value.
class SquareSlideTransitionState extends State<SquareSlideTransition>
    with SingleTickerProviderStateMixin {

  /// The controller for the animation of square.
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        upperBound: 1,
        lowerBound: -1,
        duration: const Duration(seconds: 1),
        vsync: this,
        value: 0)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          widget.updateSquareAnimationState();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(controller.value, 0),
      child: Container(
        width: widget.squareSize,
        height: widget.squareSize,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(),
        ),
      ),
    );
  }
}
