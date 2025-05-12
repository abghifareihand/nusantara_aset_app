import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final Function(DateTime, DateTime) onConfirmPressed;

  const CustomDateRangePicker({
    super.key,
    this.initialStart,
    this.initialEnd,
    required this.onConfirmPressed,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStart;
    _rangeEnd = widget.initialEnd;
  }

  void _onConfirm() {
    if (_rangeStart != null && _rangeEnd != null) {
      widget.onConfirmPressed(_rangeStart!, _rangeEnd!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'id_ID',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _rangeStart ?? DateTime.now(),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
                // Jika tidak ada rentang atau sudah selesai memilih sebelumnya
                _rangeStart = selectedDay;
                _rangeEnd = null;
              } else {
                // Jika memilih tanggal lain sebagai end range
                _rangeEnd = selectedDay;

                // Pastikan start lebih kecil dari end
                if (_rangeEnd!.isBefore(_rangeStart!)) {
                  final temp = _rangeStart;
                  _rangeStart = _rangeEnd;
                  _rangeEnd = temp;
                }
              }
            });
          },
          headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: TextStyle(color: AppColors.black, fontSize: 12),
            weekendTextStyle: TextStyle(color: AppColors.black, fontSize: 12),
            outsideTextStyle: TextStyle(color: Colors.red, fontSize: 12),

            // Tanggal Hari Ini (Today) pakai border
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            todayTextStyle: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),

            // Tanggal Mulai Range
            rangeStartDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            rangeStartTextStyle: TextStyle(color: AppColors.white, fontSize: 12),

            // Tanggal Akhir Range
            rangeEndDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            rangeEndTextStyle: TextStyle(color: AppColors.white, fontSize: 12),

            // Tanggal di Tengah Range (highlight dengan warna latar)
            rangeHighlightColor: AppColors.primary.withValues(alpha: 0.2),
            withinRangeTextStyle: TextStyle(color: AppColors.black, fontSize: 12),
          ),
        ),
        SizedBox(height: 8),
        CustomButton.filled(
          height: 46,
          borderRadius: 12,
          fontSize: 14,
          label: 'Pilih Tanggal',
          onPressed: (_rangeStart != null && _rangeEnd != null) ? _onConfirm : null,
        ),
      ],
    );
  }
}
