// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/member_bloc.dart';
import '../bloc/member_event.dart';
import '../bloc/member_state.dart';
import '../../domain/entities/member.dart';
import '../widgets/add_member_dialog.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Hero(
          tag: 'manage_btn',
          child: Material(
            color: Colors.transparent,
            child: Text(
              'قائمة المشتركين',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ), // Subscriber List
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<MemberBloc>().add(FilterMembers(query: value));
              },
              decoration: InputDecoration(
                hintText: 'بحث بالاسم...', // Search by name
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          if (state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MemberLoaded) {
            final members = state.filteredMembers;
            if (members.isEmpty) {
              return const Center(
                child: Text('لا يوجد مشتركين حالياً'),
              ); // No subscribers currently
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return _MemberCard(member: member);
              },
            );
          }
          return const Center(
            child: Text('حدث خطأ ما'),
          ); // Something went wrong
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddMemberDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Member member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showEditDialog(context, member),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      member.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _StatusBadge(status: member.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'البداية: ${dateFormat.format(member.startDate)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.event_busy, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'النهاية: ${dateFormat.format(member.endDate)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المبلغ: ${member.paymentAmount} ج.م',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _showEditDialog(context, member),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () =>
                            _showDeleteConfirmation(context, member),
                      ),
                    ],
                  ),
                ],
              ),
              if (member.notes.isNotEmpty) ...[
                const Divider(),
                Text(
                  'ملاحظات: ${member.notes}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
              if (member.isExpired || member.isExpiringSoon) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showRenewalDialog(context, member),
                    icon: const Icon(Icons.refresh),
                    label: const Text('تجديد الاشتراك'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف المشترك'),
        content: Text('هل أنت متأكد من حذف ${member.fullName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<MemberBloc>().add(DeleteMemberEvent(member.id));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المشترك بنجاح')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (context) => AddMemberDialog(member: member),
    );
  }

  void _showRenewalDialog(BuildContext context, Member member) {
    final paymentController = TextEditingController(
      text: member.paymentAmount.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تجديد الاشتراك',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'تجديد لـ ${member.fullName}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: paymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'المبلغ الجديد',
                prefixIcon: const Icon(Icons.payments_outlined),
                suffixText: 'ج.م',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'اختر مدة التجديد:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRenewalOption(context, member, 0.5, paymentController),
            _buildRenewalOption(context, member, 1.0, paymentController),
            _buildRenewalOption(context, member, 3.0, paymentController),
            _buildRenewalOption(context, member, 6.0, paymentController),
          ],
        ),
      ),
    );
  }

  Widget _buildRenewalOption(
    BuildContext context,
    Member member,
    double months,
    TextEditingController paymentController,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(months == 0.5 ? 'نصف شهر (15 يوم)' : '$months شهر'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          final newEndDate =
              (member.endDate.isBefore(DateTime.now())
                      ? DateTime.now()
                      : member.endDate)
                  .add(Duration(days: (months * 30).toInt()));

          final updatedMember = Member(
            id: member.id,
            fullName: member.fullName,
            startDate: member.startDate,
            endDate: newEndDate,
            status: MemberStatus.active,
            paymentAmount:
                double.tryParse(paymentController.text) ?? member.paymentAmount,
            notes: member.notes,
          );
          context.read<MemberBloc>().add(UpdateMemberEvent(updatedMember));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تجديد الاشتراك بنجاح')),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MemberStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        border: Border.all(color: status.color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
