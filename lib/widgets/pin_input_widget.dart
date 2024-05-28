import 'package:swipe_to_pay/widgets/animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInputWidget extends StatefulWidget {
  const PinInputWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  bool _hasReachNumberThreshold = false;
  double _amountNumberValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input Angka :',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              // numbers
              AnimatedText(
                text: widget.controller.text,
                ondelete: () {
                  widget.controller.text =
                      widget.controller.text.removeLastChar;
                },
              ),
            ],
          ),
        ),
        Keypad(
          controller: widget.controller,
        ),
      ],
    );
  }
}

class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
    this.onKeyPressed,
    required this.controller,
  });

  final ValueSetter<String>? onKeyPressed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const keys = '123456789.0x';
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35, // besar kecil angka
      ),
      itemBuilder: (context, index) {
        final key = keys[index];
        return key == '.'
            ? const SizedBox()
            : ClipRRect(
                child: Material(
                  type: MaterialType.button,
                  color: Colors.white10,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (key == 'x') {
                        controller.text = controller.text.contains('x')
                            ? controller.text
                            : controller.text.isNotEmpty
                                ? '${controller.text}x'
                                : '';
                      } else if (key == '.') {
                        controller.text +=
                            !controller.text.contains('.') ? key : "";
                      } else {
                        controller.text += key;
                      }
                      onKeyPressed?.call(key);
                    },
                    child: Align(child: _buildKeyWidget(context, key)),
                  ),
                ),
              );
      },
      itemCount: keys.length,
    );
  }

  // backspace button
  Widget _buildKeyWidget(BuildContext context, String key) {
    if (key == 'x') {
      return const Icon(
        Icons.backspace_outlined,
        color: Colors.white,
      );
    }

    if (key == '.') {
      return const SizedBox();
    }
    return Text(
      key,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
    );
  }
}

extension KeypadEx on String {
  String get removeLastChar => isNotEmpty ? substring(0, length - 2) : "";
}
