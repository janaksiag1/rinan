import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';
import '../core/utils/formatters.dart';

InputDecoration _decoration({
  String? hint,
  Widget? suffix,
  Widget? prefix,
  bool filled = false,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
    suffixIcon: suffix,
    prefixIcon: prefix,
    filled: filled,
    fillColor: AppColors.bgTertiary,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: AppColors.errorPrimary),
    ),
  );
}

/// Field with label above + helper/portal chip support.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.helpText,
    this.required = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.readOnly = false,
    this.fill = false,
    this.suffix,
    this.portalSynced = false,
    this.onChanged,
    this.initialValue,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? helpText;
  final bool required;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool fill;
  final Widget? suffix;
  final bool portalSynced;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              required ? '$label *' : label,
              style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (portalSynced) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text('Portal ✓',
                    style: AppText.bodySM.copyWith(color: AppColors.infoPrimary)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppText.bodyLG.copyWith(color: AppColors.textPrimary),
          decoration: _decoration(hint: hint, filled: fill || readOnly, suffix: suffix),
        ),
        if (helpText != null) ...[
          const SizedBox(height: 4),
          Text(helpText!, style: AppText.bodySM),
        ],
      ],
    );
  }
}

/// 10-digit Indian mobile field with +91 prefix.
class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    this.label = 'Mobile Number',
    this.hint = '10-digit number',
    this.controller,
    this.onChanged,
    this.readOnly = false,
  });
  final String label;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          onChanged: onChanged,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppText.bodyLG.copyWith(color: AppColors.textPrimary),
          decoration: _decoration(
            hint: hint,
            filled: readOnly,
            prefix: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('+91',
                  style: AppText.bodyLG.copyWith(color: AppColors.textSecondary)),
            ),
          ).copyWith(counterText: '', prefixIconConstraints: const BoxConstraints(minWidth: 0)),
        ),
      ],
    );
  }
}

/// Dropdown styled to match text fields.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    this.value,
    this.hint,
    this.required = false,
    this.onChanged,
  });
  final String label;
  final List<T> items;
  final String Function(T) itemLabel;
  final T? value;
  final String? hint;
  final bool required;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(required ? '$label *' : label,
            style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(hint!, style: AppText.bodyMD.copyWith(color: AppColors.textTertiary))
              : null,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textTertiary),
          style: AppText.bodyLG.copyWith(color: AppColors.textPrimary),
          decoration: _decoration(),
          items: items
              .map((e) => DropdownMenuItem<T>(value: e, child: Text(itemLabel(e))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// 6-box OTP entry. Visual only — accepts input, no verification.
class AppOTPField extends StatefulWidget {
  const AppOTPField({super.key, this.error = false, this.onCompleted});
  final bool error;
  final ValueChanged<String>? onCompleted;

  @override
  State<AppOTPField> createState() => _AppOTPFieldState();
}

class _AppOTPFieldState extends State<AppOTPField> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return SizedBox(
          width: 48,
          height: 56,
          child: TextField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppText.headingMD.copyWith(
              fontFamily: 'monospace',
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(
                  color: widget.error ? AppColors.errorPrimary : AppColors.borderLight,
                  width: widget.error ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.tealPrimary, width: 2),
              ),
            ),
            onChanged: (v) {
              if (v.isNotEmpty && i < 5) _nodes[i + 1].requestFocus();
              if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
              final code = _controllers.map((c) => c.text).join();
              if (code.length == 6) widget.onCompleted?.call(code);
            },
          ),
        );
      }),
    );
  }
}

/// Search field (rounded, tinted).
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.hint = 'Search',
    this.controller,
    this.onChanged,
  });
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
      decoration: _decoration(hint: hint, filled: true).copyWith(
        prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
      ),
    );
  }
}

/// Money input rendered in mono. Visual only.
class AppMoneyField extends StatelessWidget {
  const AppMoneyField({
    super.key,
    required this.label,
    this.controller,
    this.required = false,
    this.onChanged,
  });
  final String label;
  final TextEditingController? controller;
  final bool required;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(required ? '$label *' : label,
            style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppText.mono,
          decoration: _decoration(hint: '0').copyWith(
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('₹',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace')),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
          ),
        ),
      ],
    );
  }
}

/// Date picker field. Visual only — opens the platform picker.
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({super.key, required this.label, this.required = false});
  final String label;
  final bool required;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.required ? '${widget.label} *' : widget.label,
            style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _value ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
            );
            if (picked != null) setState(() => _value = picked);
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _value == null ? 'Select date' : Fmt.date(_value!),
                    style: AppText.bodyLG.copyWith(
                      color: _value == null
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
