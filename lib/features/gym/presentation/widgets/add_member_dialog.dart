import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/member.dart';
import '../bloc/member_bloc.dart';
import '../bloc/member_event.dart';

class AddMemberDialog extends StatefulWidget {
  final Member? member;
  const AddMemberDialog({super.key, this.member});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _paymentController;
  late final TextEditingController _notesController;
  late DateTime _startDate;
  late DateTime _endDate;
  double _months = 1.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.fullName);
    _paymentController = TextEditingController(
      text: widget.member?.paymentAmount.toString() ?? '0.0',
    );
    _notesController = TextEditingController(text: widget.member?.notes);
    _startDate = widget.member?.startDate ?? DateTime.now();
    _endDate =
        widget.member?.endDate ?? _startDate.add(const Duration(days: 30));
  }

  void _updateEndDate(double months) {
    setState(() {
      _months = months;
      _endDate = _startDate.add(Duration(days: (months * 30).toInt()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.member != null;

    return AlertDialog(
      title: Text(isEdit ? 'تعديل بيانات المشترك' : 'إضافة مشترك جديد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم بالكامل',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'المبلغ المدفوع',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('تاريخ البدء'),
              subtitle: Text(
                '${_startDate.year}/${_startDate.month}/${_startDate.day}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                    _updateEndDate(_months);
                  });
                }
              },
            ),
            ListTile(
              title: const Text('تاريخ الانتهاء'),
              subtitle: Text(
                '${_endDate.year}/${_endDate.month}/${_endDate.day}',
              ),
              trailing: const Icon(Icons.edit_calendar),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate,
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() => _endDate = date);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              initialValue: [0.5, 1.0, 3.0, 6.0, 12.0].contains(_months)
                  ? _months
                  : null,
              decoration: const InputDecoration(
                labelText: 'خطة الاشتراك',
                border: OutlineInputBorder(),
              ),
              items: [0.5, 1.0, 3.0, 6.0, 12.0]
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m == 0.5 ? 'نصف شهر (15 يوم)' : '$m شهر'),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) _updateEndDate(val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              final member = Member(
                id: widget.member?.id ?? const Uuid().v4(),
                fullName: _nameController.text,
                startDate: _startDate,
                endDate: _endDate,
                status: MemberStatus.active,
                paymentAmount: double.tryParse(_paymentController.text) ?? 0.0,
                notes: _notesController.text,
              );

              if (widget.member != null) {
                context.read<MemberBloc>().add(UpdateMemberEvent(member));
              } else {
                context.read<MemberBloc>().add(AddMemberEvent(member));
              }
              Navigator.pop(context);
            }
          },
          child: Text(isEdit ? 'حفظ التعديلات' : 'إضافة'),
        ),
      ],
    );
  }
}
