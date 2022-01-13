import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({Key? key, required this.matchType}) : super(key: key);

  final String matchType;

  @override
  State<CreateMatch> createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final _formKey = GlobalKey<FormState>();

  DateTime? initvalue;

  void validate() {
    if (_formKey.currentState!.validate()) {
      print("done!");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // match name
                      matchName,

                      const SizedBox(height: 20),

                      // dropdowns
                      const DropDownSolo(),

                      const SizedBox(height: 20),
                      const DropDownMatch(),

                      const SizedBox(height: 20),
                      const DropDownSkill(),

                      const SizedBox(height: 20),
                      const DropDownReward(),

                      const SizedBox(height: 20),

                      // select date
                      const PickDate(),

                      // submit button
                      ElevatedButton(
                          onPressed: () {
                            validate();
                          },
                          child: const Text("Submit"))
                    ],
                  ),
                ))),
      ),
    );
  }
}

// Pick Date Widget
class PickDate extends StatelessWidget {
  const PickDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime.now();

    String currentYear = selectedDate.toString().split("-")[0];
    String currentMonth = selectedDate.toString().split("-")[1];
    String currentDay = selectedDate.toString().split("-")[2].split(" ")[0];
    String matchStartDay = (int.parse(currentDay) + 2).toString();
    DateTime matchTime = DateTime.parse(currentYear + currentMonth + matchStartDay);

    // select date function
    void selectDate() async {
      DateTime? pickedDate = await showDatePicker(
          context: context, initialDate: matchTime, firstDate: matchTime, lastDate: DateTime(2100));
      context.read<DetailProvider>().setDate(pickedDate);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
        child: InputDatePickerFormField(
          firstDate: matchTime,
          lastDate: DateTime(2100),
          fieldLabelText: "Enter Date or Pick from Calendar",
          errorFormatText: "Invalid Date Format (mm/dd/yyyy)",
          errorInvalidText: "Schedule matches atleast 2 days from now",
          initialDate: context.watch<DetailProvider>().initvalue,
        ),
      ),
      const SizedBox(width: 20),
      GestureDetector(
          onTap: () {
            selectDate();
          },
          child: const Icon(Icons.calendar_today))
    ]);
  }
}

// Details Provider
class DetailProvider with ChangeNotifier {
  DateTime? _initvalue;
  String _dropdownvalue1 = "Solo";
  String _dropdownvalue2 = "Match";
  String _dropdownvalue3 = "No Skill Level Required";
  String _dropdownvalue4 = "Rewards Available";

  DateTime? get initvalue => _initvalue;
  String get dropdownvalue1 => _dropdownvalue1;
  String get dropdownvalue2 => _dropdownvalue2;
  String get dropdownvalue3 => _dropdownvalue3;
  String get dropdownvalue4 => _dropdownvalue4;

  void setDate(DateTime? value) {
    _initvalue = value;
    notifyListeners();
  }

  void setdropdownvalue1(String value) {
    _dropdownvalue1 = value;
    notifyListeners();
  }

  void setdropdownvalue2(String value) {
    _dropdownvalue2 = value;
    notifyListeners();
  }

  void setdropdownvalue3(String value) {
    _dropdownvalue3 = value;
    notifyListeners();
  }

  void setdropdownvalue4(String value) {
    _dropdownvalue4 = value;
    notifyListeners();
  }
}

// DropDown Providers

class DropDownSolo extends StatelessWidget {
  const DropDownSolo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>["Solo", "Team"]
          .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (String? value) {
        context.read<DetailProvider>().setdropdownvalue1(value!);
      },
      value: context.read<DetailProvider>().dropdownvalue1,
    );
  }
}

class DropDownMatch extends StatelessWidget {
  const DropDownMatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>["Match", "Tournament"]
          .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (String? value) {
        context.read<DetailProvider>().setdropdownvalue2(value!);
      },
      value: context.read<DetailProvider>().dropdownvalue2,
    );
  }
}

class DropDownSkill extends StatelessWidget {
  const DropDownSkill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>["Skill Level Required", "No Skill Level Required"]
          .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (String? value) {
        context.read<DetailProvider>().setdropdownvalue3(value!);
      },
      value: context.read<DetailProvider>().dropdownvalue3,
    );
  }
}

class DropDownReward extends StatelessWidget {
  const DropDownReward({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>["Rewards Available", "Rewards Not Available"]
          .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (String? value) {
        context.read<DetailProvider>().setdropdownvalue4(value!);
      },
      value: context.read<DetailProvider>().dropdownvalue4,
    );
  }
}
