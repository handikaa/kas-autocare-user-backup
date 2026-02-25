import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/inject/depedency_injection.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../cubit/notification/get_list_notification_cubit.dart';
import '../../cubit/notification/read_list_notification_cubit.dart';
import '../../widget/widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late GetListNotificationCubit _getListNotificationCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListNotificationCubit = sl<GetListNotificationCubit>()..getListNotif();
  }

  @override
  void dispose() {
    _getListNotificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _getListNotificationCubit),
        BlocProvider(create: (_) => sl<ReadListNotificationCubit>()),
      ],
      child: BlocListener<GetListNotificationCubit, GetListNotificationState>(
        listenWhen: (previous, current) => current is GetListNotifSuccess,
        listener: (context, state) {
          final success = state as GetListNotifSuccess;

          final notifIds = success.data
              .where((e) => e.isRead == 0)
              .map((e) => e.id)
              .whereType<int>() // aman kalau id nullable
              .toList();

          if (notifIds.isNotEmpty) {
            context.read<ReadListNotificationCubit>().readListNotif(notifIds);
          }
        },
        child: BlocBuilder<GetListNotificationCubit, GetListNotificationState>(
          builder: (context, state) {
            if (state is GetListNotifLoading) {
              return ContainerScreen(
                title: 'Notifikasi',
                scrollable: true,
                body: const [Center(child: CircularProgressIndicator())],
              );
            } else if (state is GetListNotifError) {
              return ContainerScreen(
                title: 'Notifikasi',
                scrollable: true,
                body: [
                  Center(
                    child: AppText(
                      'Terjadi Kesalahan ${state.message}',
                      maxLines: 4,
                      variant: TextVariant.body2,
                      weight: TextWeight.bold,
                      color: AppColors.light.error,
                    ),
                  ),
                ],
              );
            } else if (state is GetListNotifSuccess) {
              return ContainerScreen(
                title: 'Notifikasi',
                scrollable: true,
                body: [NotificationCard(data: state.data)],
              );
            }

            return ContainerScreen(
              title: 'Notifikasi',
              scrollable: true,
              body: [
                Center(
                  child: Column(
                    children: [
                      AppText(
                        'Terjadi Kesalahan',
                        variant: TextVariant.body2,
                        weight: TextWeight.bold,
                        color: AppColors.light.error,
                      ),
                      AppGap.height(12),
                      AppElevatedButton(
                        text: "Kembali Ke Home",
                        onPressed: () => context.pushNamed('/dashboard'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final List<NotificationEntity> data;

  const NotificationCard({super.key, required this.data});

  String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.year} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text("Tidak ada notifikasi."));

    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];
        return _notifItem(context, item);
      }),
    );
  }

  Widget _notifItem(BuildContext context, NotificationEntity item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.isRead == 0
            ? Color.fromRGBO(205, 230, 255, 0.7)
            : AppColors.common.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.light.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.notifications_active_sharp, color: Colors.green),
          ),
          AppGap.width(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.title ?? "",
                  variant: TextVariant.body2,
                  weight: TextWeight.bold,
                ),
                AppGap.height(6),
                AppText(
                  align: TextAlign.left,
                  maxLines: 4,
                  item.message ?? "",
                  variant: TextVariant.body3,
                  weight: TextWeight.medium,
                ),

                SizedBox(height: 6),
                Text(
                  formatDate(item.createdAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
