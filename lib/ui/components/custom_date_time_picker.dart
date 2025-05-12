import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

class CustomDateTimePicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool showLabel;
  final String? hintText;
  final Function(String value)? onChanged;

  const CustomDateTimePicker({
    super.key,
    required this.label,
    required this.controller,
    this.showLabel = true,
    this.hintText,
    this.onChanged,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDateTime(BuildContext context) async {
    // Pilih tanggal
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    // Pilih waktu dengan format digital (24 jam)
    final TimeOfDay? time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input, // 🟢 Digital mode (24 jam)
      builder: (context, child) {
        return _hourFormatBuilder(context, child);
      },
    );

    if (time == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final formatted = DateFormat('dd-MM-yyyy HH:mm:ss', 'id_ID').format(dateTime);

    setState(() {
      selectedDate = date;
      selectedTime = time;
      widget.controller.text = formatted;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(formatted);
    }
  }

  // Builder untuk memastikan format 24 jam
  Widget _hourFormatBuilder(BuildContext context, Widget? child) {
    final mediaQueryData = MediaQuery.of(context);

    return MediaQuery(
      data:
          mediaQueryData.alwaysUse24HourFormat
              ? mediaQueryData
              : mediaQueryData.copyWith(alwaysUse24HourFormat: true),
      child: Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: AppColors.black,
          ),
        ),
        child: child!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(widget.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12.0),
        ],
        TextFormField(
          controller: widget.controller,
          onTap: () => _selectDateTime(context),
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.access_time, color: Colors.grey),
            hintText: widget.hintText ?? 'Pilih Tanggal & Jam',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
