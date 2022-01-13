import 'package:flutter/material.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({Key? key, required this.matchType}) : super(key: key);

  final String matchType;

  @override
  State<CreateMatch> createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final _formKey = GlobalKey<FormState>();

  final DateTime selectedDate = DateTime.now();

  String dateFiller = "Pick a Date";

  @override
  Widget build(BuildContext context) {
    String currentYear = selectedDate.toString().split("-")[0];
    String currentMonth = selectedDate.toString().split("-")[1];
    String currentDay = selectedDate.toString().split("-")[2].split(" ")[0];
    String matchStartDay = (int.parse(currentDay) + 2).toString();
    DateTime matchTime = DateTime.parse(currentYear + currentMonth + matchStartDay);

    // select date function
    // void selectDate() async {
    //   DateTime? pickedDate = await showDatePicker(
    //     context: context,
    //     initialDate: matchTime,
    //     firstDate: matchTime,
    //     lastDate: DateTime(2100),
    //   );
    //   if (pickedDate != null) {
    //     matchTime = pickedDate;
    //   }
    //   dateFiller = matchTime.toString();
    //   setState(() {});
    // }

    // Text Controllers
    TextEditingController matchNameController = TextEditingController();

    // Tournament Entry
    TextFormField matchName = TextFormField(
      controller: matchNameController,
      decoration: const InputDecoration(
        labelText: "Tournament Name",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.align_horizontal_left),
      ),
      validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
    );

    // Date Picker
    InputDatePickerFormField pickDate = InputDatePickerFormField(firstDate: matchTime, lastDate: DateTime(2100));

    // Dropdowns
    DropdownButtonFormField solo = DropdownButtonFormField(
        items: const [DropdownMenuItem(child: Text("yo")), DropdownMenuItem(child: Text("hello"))],
        onChanged: (value) {});

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Fill Details"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // match name
                    Padding(padding: const EdgeInsets.all(10.0), child: matchName),

                    // check boxes

                    // select date
                    Padding(padding: const EdgeInsets.all(10.0), child: pickDate),
                    solo,
                  ],
                ))),
      ),
    );
  }
}
