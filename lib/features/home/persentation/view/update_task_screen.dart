import 'package:dmj_task/core/shared/toast_state.dart';
import 'package:dmj_task/core/utils/extension.dart';
import 'package:dmj_task/core/widget/button_widget.dart';
import 'package:dmj_task/core/widget/custome_dropdown.dart';
import 'package:dmj_task/core/widget/text_field_widget.dart';
import 'package:dmj_task/features/home/logic/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpdateTaskScreen extends StatefulWidget {
  final String title;
  final String describtion;
  final String time;
  final String date;
  final String status;
  final String statusValue;
  final String taskId;

  const UpdateTaskScreen({
    super.key,
    required this.title,
    required this.describtion,
    required this.time,
    required this.date,
    required this.status,
    required this.taskId,
    required this.statusValue,
  });

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _taskDateController;
  late TextEditingController _taskTimeController;
  late GlobalKey<FormState> _formState;
  // List of states
  final List<String> states = ["TODO", "In Progress", "Complete"];

  // Selected state & value
  String? selectedState;
  late String statusValue;
  @override
  void initState() {
    super.initState();
    //! Controller
    _taskTitleController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _taskDateController = TextEditingController();
    _taskTimeController = TextEditingController();
    _formState = GlobalKey<FormState>();
    //! Values
    _taskTitleController.text = widget.title;
    _taskDescriptionController.text = widget.describtion;
    // date
    String storedDate = widget.date;
    DateTime parsedDate = DateTime.parse(storedDate);
    _taskDateController.text = DateFormat("yyyy-MM-dd").format(parsedDate);
    // time
    String storedTime = widget.date;
    DateTime parsedTime = DateTime.parse(storedTime);
    _taskTimeController.text = DateFormat("hh:mm a").format(parsedTime);
    // _taskTimeController.text = widget.time;
    // "${widget.time.hour} : ${widget.time.minute} ${widget.time.period.name}";
    selectedState = widget.status;
    statusValue = widget.statusValue;
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
          'Update Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formState,
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
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                    ).then((value) => _taskDateController.text =
                        DateFormat("yyyy-MM-dd").format(value!).toString());
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
                    ).then((value) => _taskTimeController.text =
                        value!.format(context).toString());
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
                    if (value.isEmpty) return "Please enter your Description";
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
                      print(statusValue);
                    });
                  },
                  selectedState: selectedState ?? "",
                  states: states,
                  titleField: "Status",
                ),
                30.ph,
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state is UpdateTaskSuccess) {
                      toastSuccess(message: state.massege);
                      Navigator.pop(context);
                    } else if (state is UpdateTaskError) {
                      toastError(message: state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is UpdateTaskLoading) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      ).center;
                    } else {
                      return ButtonWidget(
                        onPressed: () {
                          if (_formState.currentState!.validate()) {
                            context.read<HomeCubit>().updateTaskCubit(
                                  taskId: widget.taskId,
                                  title: _taskTitleController.text,
                                  describtion: _taskDescriptionController.text,
                                  status: selectedState.toString(),
                                  statusValue: statusValue,
                                );
                          } else {
                            toastWarning(message: "Please Check Your Field");
                          }
                        },
                        txt: "Update Task",
                        backgroundColor: Colors.orange,
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
    super.dispose();
  }
}
