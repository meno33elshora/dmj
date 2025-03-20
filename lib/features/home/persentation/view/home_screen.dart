import 'package:dmj_task/config/local_data/flutter_secure_storage.dart';
import 'package:dmj_task/config/routes/routes.dart';
import 'package:dmj_task/core/shared/toast_state.dart';
import 'package:dmj_task/core/utils/extension.dart';
import 'package:dmj_task/core/widget/animation_widget.dart';
import 'package:dmj_task/features/auth/logic/auth_cubit.dart';
import 'package:dmj_task/features/home/data/model/add_task_model.dart';
import 'package:dmj_task/features/home/logic/home_cubit.dart';
import 'package:dmj_task/features/home/persentation/widget/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hello 👋',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is SignOutSuccess) {
                toastSuccess(message: state.message);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.login, (route) => false);
                await FlutterSecureHelper.instance.removeObject(
                  "login",
                );
              } else if (state is SignOutError) {
                toastError(message: state.error);
              }
            },
            builder: (context, state) {
              if (state is SignOutLoading) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                ).center;
              } else {
                return IconButton(
                  onPressed: () {
                    context.read<AuthCubit>().signOut();
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.orange,
                  ),
                );
              }
            },
          )
        ],
      ),
      body: StreamBuilder<List<AddTaskModel>>(
        stream: context.read<HomeCubit>().getTaskCubit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            )); // Handle error
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              "No tasks available",
              style: TextStyle(color: Colors.white),
            )).center; // Handle empty state
          }

          final tasks = snapshot.data!;

          return ListView.builder(
              itemCount: tasks.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.redAccent,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            20.pw,
                            const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        context
                            .read<HomeCubit>()
                            .deleteTaskCubit(taskId: task.taskId);
                      }
                    },
                    child: AnimateWidgetItem(
                        indexPositionItem: index,
                        verticalOffset: -100,
                        item: CardItem(
                          taskId: task.taskId,
                          data: task.date,
                          statusValue: task.statusValue,
                          description: task.describtion,
                          status: task.status,
                          title: task.title,
                          time: task.time,
                        )));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add_task_rounded,
          color: Colors.orange,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.addTask,
          );
        },
      ),
    );
  }
}
