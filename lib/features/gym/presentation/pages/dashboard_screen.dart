// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_bloc.dart';
import '../bloc/member_state.dart';
import '../../domain/entities/member.dart';
import 'member_list_screen.dart';
import '../widgets/animated_stat_card.dart';
import '../../../../core/theme/theme_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'فتنس جيم',
          style: TextStyle(fontWeight: FontWeight.bold),
        ), // Fitness Digital Gym
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeBloc>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          if (state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          int total = 0;
          int active = 0;
          int expired = 0;
          int expiringSoon = 0;
          List<Member> alertedMembers = [];

          if (state is MemberLoaded) {
            total = state.members.length;
            for (var m in state.members) {
              if (m.isExpired) {
                expired++;
                alertedMembers.add(m);
              } else if (m.isExpiringSoon) {
                expiringSoon++;
                alertedMembers.add(m);
              } else {
                active++;
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Hero(
                  tag: 'app_logo',
                  child: Material(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedStatCard(
                  title: 'إجمالي الأعضاء', // Total Members
                  count: total.toString(),
                  icon: Icons.people,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'نشط', // Active
                        count: active.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'منتهي', // Expired
                        count: expired.toString(),
                        icon: Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedStatCard(
                  title: 'ينتهي قريباً', // Expiring Soon
                  count: expiringSoon.toString(),
                  icon: Icons.timer,
                  color: Colors.orange,
                ),
                const SizedBox(height: 32),
                if (alertedMembers.isNotEmpty) ...[
                  const Text(
                    'تنبيهات الانتهاء', // Expiration Alerts
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...alertedMembers
                      .take(3)
                      .map(
                        (m) => Card(
                          color: m.status.color.withOpacity(0.05),
                          child: ListTile(
                            title: Text(m.fullName),
                            subtitle: Text(m.status.label),
                            trailing: const Icon(
                              Icons.warning,
                              color: Colors.amber,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MemberListScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  const SizedBox(height: 16),
                ],
                Hero(
                  tag: 'manage_btn',
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MemberListScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('إدارة المشتركين'), // Manage Subscribers
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
