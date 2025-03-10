// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:trainner_app/providers/user_provider.dart';
import 'package:trainner_app/resources/firestore_methods.dart';
import 'package:trainner_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:trainner_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkoutAddScreen extends StatefulWidget {
  const WorkoutAddScreen({Key? key}) : super(key: key);

  @override
  _WorkoutAddScreenState createState() => _WorkoutAddScreenState();
}

class _WorkoutAddScreenState extends State<WorkoutAddScreen> {
  bool isLoading = false;

  final TextEditingController _exNameController = TextEditingController();
  final TextEditingController _exWeightController = TextEditingController();
  final TextEditingController _exRepsController = TextEditingController();
  final TextEditingController _exSetsController = TextEditingController();
  final TextEditingController _exDateController = TextEditingController();

  void saveExercise(String uid) async {
    try {
      String res = await FireStoreMethods().addExercise(
        uid,
        _exNameController.text,
        _exWeightController.text,
        _exRepsController.text,
        _exSetsController.text,
        _exDateController.text,
      );
      Navigator.pop(context);

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Inserted Exercise Successfully !!!!',
        );
      } else {
        // Handle failure
      }
    } catch (err) {
      // Handle error
    }
  }

  @override
  void dispose() {
    super.dispose();
    _exNameController.dispose();
    _exWeightController.dispose();
    _exSetsController.dispose();
    _exRepsController.dispose();
    _exDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add a New Exercise',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _exNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(label: Text('Exercise Name')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _exWeightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text('Weight')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _exRepsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text('Reps Count')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _exSetsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text('Sets Count')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _exDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Select Date" //label text of field
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        _exDateController.text = formattedDate;
                      });
                    } else {
                      print("Nenhuma data selecionada");
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => saveExercise(userProvider.getUser.uid),
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.cyan),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
