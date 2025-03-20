import 'dart:math';
import 'package:dmj_task/core/notification/notification_helper.dart';
import 'package:dmj_task/core/shared/toast_state.dart';
import 'package:dmj_task/core/utils/extension.dart';
import 'package:dmj_task/core/widget/button_widget.dart';
import 'package:dmj_task/core/widget/custome_dropdown.dart';
import 'package:dmj_task/core/widget/text_field_widget.dart';
import 'package:dmj_task/features/home/data/model/add_task_model.dart';
import 'package:dmj_task/features/home/logic/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _taskDateController;
  late TextEditingController _taskTimeController;
  late GlobalKey<FormState> _formKey;
  int day = 0;
  int hour = 0;
  int minute = 0;
  // List of states
  final List<String> states = ["TODO", "In Progress", "Complete"];

  // Selected state
  String? selectedState;
  String statusValue = "";
  @override
  void initState() {
    super.initState();
    //! controller
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _taskDateController = TextEditingController();
    _taskTimeController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.ph,
                TextFieldWidget(
                  titleField: "Title",
                  hintField: "Title",
                  controller: _taskTitleController,
                  obscureText: false,
                  prefixIcon: const Icon(
                    Icons.title,
                    color: Colors.orange,
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Please enter your title";
                  },
                  onChanged: (value) {},
                ),
                20.ph,
                TextFieldWidget(
                  titleField: "Date",
                  hintField: "Date",
                  readOnly: true,
                  controller: _taskDateController,
                  obscureText: false,
                  prefixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    ).then((value) {
                      _taskDateController.text =
                          DateFormat("yyyy-MM-dd").format(value!).toString();
                      String dayValue = DateFormat('dd').format(value);
                      day = int.parse(dayValue);
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) return "Please enter your Date";
                  },
                  onChanged: (value) {},
                ),
                20.ph,
                TextFieldWidget(
                  titleField: "Time",
                  hintField: "Time",
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      _taskTimeController.text =
                          value!.format(context).toString();
                      String hourValue = value.hour.toString();
                      String minuteValue = value.minute.toString();

                      hour = int.parse(hourValue);
                      minute = int.parse(minuteValue);
                    });
                  },
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: Colors.orange,
                  ),
                  controller: _taskTimeController,
                  obscureText: false,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter your Time";
                  },
                  onChanged: (value) {},
                ),
                20.ph,
                TextFieldWidget(
                  titleField: "Description",
                  hintField: "Description",
                  prefixIcon: const Icon(
                    Icons.description,
                    color: Colors.orange,
                  ),
                  controller: _taskDescriptionController,
                  obscureText: false,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter your Describtion";
                  },
                  onChanged: (value) {},
                ),
                20.ph,
                CustomeDropdown(
                  onChanged: (p0) {
                    setState(() {
                      selectedState = p0;
                      switch (selectedState) {
                        case "TODO":
                          statusValue = "0.33";
                          break;
                        case "In Progress":
                          statusValue = "0.66";
                          break;
                        case "Complete":
                          statusValue = "1";
                          break;
                        default:
                      }
                    });
                  },
                  selectedState: selectedState ?? "",
                  states: states,
                  titleField: "Status",
                ),
                30.ph,
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state is AddTaskSuccess) {
                      toastSuccess(message: state.message);
                      DateTime selectedTime = DateTime.now().add(Duration(
                        days: day,
                        hours: hour,
                        minutes: minute,
                      ));
                      NotificationHelper()
                          .scheduleNotification(
                        _taskTitleController.text,
                        _taskDescriptionController.text,
                        selectedTime,
                      )
                          .then((value) {
                        if (selectedTime.isBefore(DateTime.now())) {
                          DateTime attentionNotification =
                              selectedTime.add(Duration(
                            minutes: max(0, minute - 30),
                            hours:
                                (selectedTime.hour == hour) ? hour : hour - 1,
                          ));
                          NotificationHelper().scheduleNotification(
                            "Attention",
                            "New Task Tracking Coming Soon !",
                            attentionNotification,
                          );
                        }
                      });
                      Navigator.pop(context);
                    } else if (state is AddTaskError) {
                      toastError(message: state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is AddTaskLoading) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      ).center;
                    } else {
                      return ButtonWidget(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<HomeCubit>()
                                .addTaskCubit(
                                    addTaskModel: AddTaskModel(
                                  "",
                                  _taskTitleController.text,
                                  _taskDescriptionController.text,
                                  selectedState.toString(),
                                  statusValue,
                                  _taskTimeController.text,
                                  _taskDateController.text,
                                ))
                                .then((value) {});
                          } else {
                            toastWarning(message: "Please Check Your Field");
                          }
                        },
                        txt: "Add Task",
                        backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
                      );
                    }
                  },
                )
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _taskDateController.dispose();
    _taskTimeController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
