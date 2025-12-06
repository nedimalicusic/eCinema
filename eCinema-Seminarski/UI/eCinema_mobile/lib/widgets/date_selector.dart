import 'package:ecinema_mobile/extensions/date_only_compare.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/date_provider.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  static const int numberOfDays = 10;
  late DateProvider dateProvider;

  void _handleDateSelected(DateTime date) {
    dateProvider.setSelectedDate(date);
  }

  @override
  void initState() {
    super.initState();
    dateProvider = context.read<DateProvider>();
    if (dateProvider.dates.isEmpty) {
      dateProvider.initializeDates(numberOfDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<DateProvider>();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        scrollDirection: Axis.horizontal,
        itemCount: state.dates.length,
        itemBuilder: (context, index) {
          final d = state.dates[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DateContainer(
              date: d,
              isSelected: state.selectedDate.isSameDate(d),
              onDateSelected: _handleDateSelected,
            ),
          );
        },
      ),
    );
  }
}

class DateContainer extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;
  final bool isSelected;

  const DateContainer({
    super.key,
    required this.date,
    required this.onDateSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
          color: isSelected ? Colors.teal : Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.isSameDate(DateTime.now()) ? 'Danas' : DateFormat.MMMd('bs').format(date),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('EEE', 'bs').format(date).toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
