import 'package:dmj_task/config/routes/routes.dart';
import 'package:dmj_task/features/home/persentation/widget/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class CardItem extends StatelessWidget {
  final String taskId;
  final String status;
  final String data;
  final String time;
  final String statusValue;
  final String title;
  final String description;
  const CardItem({
    super.key,
    required this.status,
    required this.data,
    required this.title,
    required this.description,
    required this.time,
    required this.statusValue,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        color: Colors.orange,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: ProgressIndicatorWidget(
                value: double.parse(statusValue),
              ),
              subtitle: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Routes.updateTask, arguments: {
                    'date': data.toString(),
                    'describtion': description,
                    'status': status,
                    'title': title,
                    "time": time.toString(),
                    "taskId": taskId,
                    "statusValue": statusValue,
                  });
                },
                icon: const Icon(Icons.edit),
                color: Colors.white,
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    'Status : $status',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _setColor(status),
                      fontSize: 12.0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Time : $time',
                    // 'Time : ${time.hour} : ${time.minute} ${time.period.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Date : $data',
                    // 'Date : ${DateFormat("yyyy-MM-dd").format(data)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Color _setColor(String status) {
    switch (status) {
      case 'TODO':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Complete':
        return Colors.green;
      default:
        return Colors.white;
    }
  }
}
