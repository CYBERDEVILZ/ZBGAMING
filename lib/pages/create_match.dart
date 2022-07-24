import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/utils/apistring.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({Key? key, required this.matchType, required this.eligible}) : super(key: key);

  final String matchType;
  final bool eligible;

  @override
  // ignore: no_logic_in_create_state
  State<CreateMatch> createState() => _CreateMatchState(matchType, eligible);
}

class _CreateMatchState extends State<CreateMatch> {
  _CreateMatchState(this.matchType, this.eligible);

  final String matchType;
  final bool eligible;

  final _formKey = GlobalKey<FormState>();
  DateTime? date;
  bool isLoading = false;

  TextEditingController matchNameController = TextEditingController();

  void validate() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      // get values from form
      String organizerName = matchNameController.text;
      bool solo = context.read<DetailProvider>()._dropdownvalue1 == "Solo" ? true : false;
      bool match = context.read<DetailProvider>()._dropdownvalue2 == "Match" ? true : false;
      int skill = context.read<DetailProvider>()._dropdownvalue3 == "No Skill Level Required"
          ? 0
          : context.read<DetailProvider>()._dropdownvalue3 == "Intermediate and above"
              ? 1
              : context.read<DetailProvider>()._dropdownvalue3 == "Only Professionals"
                  ? 2
                  : -1;
      int fee = context.read<DetailProvider>()._dropdownvalue4 == "Free"
          ? 0
          : context.read<DetailProvider>()._dropdownvalue4 == "\u20b9 100"
              ? 1
              : context.read<DetailProvider>()._dropdownvalue4 == "\u20b9 500"
                  ? 2
                  : context.read<DetailProvider>()._dropdownvalue4 == "\u20b9 1000"
                      ? 3
                      : context.read<DetailProvider>()._dropdownvalue4 == "\u20b9 5000"
                          ? 4
                          : -1;
      DateTime datepicked = context.read<DetailProvider>().date!;

      await get(Uri.parse(ApiEndpoints.baseUrl +
              ApiEndpoints.createMatch +
              "?date=$datepicked&uid=${FirebaseAuth.instance.currentUser!.uid}&fee=$fee&match=$match&name=$organizerName&skill=$skill&solo=$solo&matchType=$matchType"))
          .then((value) {
        if (value.statusCode == 200) {
          if (value.body == "Success") {
            Fluttertoast.showToast(msg: "Success");
            Navigator.pop(context);
            Navigator.pop(context);
          }
          Fluttertoast.showToast(msg: value.body);
        } else {
          Fluttertoast.showToast(msg: "Something went wrong");
        }
      }).catchError((onError) {
        Fluttertoast.showToast(msg: "Something went wrong");
      });
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Tournament Entry
    TextFormField matchName = TextFormField(
      controller: matchNameController,
      decoration: const InputDecoration(
        labelText: "Tournament Name",
        hintText: "Make Sure It's Awesome!",
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
                      const SizedBox(height: 40),

                      // match name
                      matchName,

                      const SizedBox(height: 30),

                      // dropdowns

                      // solo or team
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: const Text("Select Player Type",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            margin: const EdgeInsets.only(bottom: 10)),
                      ),
                      const DropDownSolo(),

                      const SizedBox(height: 40),

                      // Match or tournament
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: const Text("Select Match Type",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            margin: const EdgeInsets.only(bottom: 10)),
                      ),
                      const DropDownMatch(),

                      const SizedBox(height: 40),

                      // Skill level or not
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: const Text("Select Minimum Skill Level",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            margin: const EdgeInsets.only(bottom: 10)),
                      ),
                      const DropDownSkill(),

                      const SizedBox(height: 40),

                      // Match or tournament
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: const Text("Registration Fee",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            margin: const EdgeInsets.only(bottom: 10)),
                      ),
                      DropDownReward(
                        isEligible: eligible,
                      ),

                      const SizedBox(height: 50),

                      // select date
                      const PickDate(),

                      const SizedBox(height: 20),

                      // submit button
                      ElevatedButton(
                        onPressed: () {
                          validate();
                        },
                        child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Submit"),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(const Size(150, 50))),
                      )
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
    // select date function
    void selectDate() async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 2)),
          firstDate: DateTime.now().add(const Duration(days: 2)),
          lastDate: DateTime(2100));
      context.read<DetailProvider>().setDate(pickedDate);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
        child: InputDatePickerFormField(
          firstDate: DateTime.now().add(const Duration(days: 2)),
          lastDate: DateTime(2100),
          fieldLabelText: "Enter Date or Pick from Calendar",
          errorFormatText: "Invalid Date Format (mm/dd/yyyy)",
          errorInvalidText: "Schedule matches atleast 2 days from now",
          initialDate: context.watch<DetailProvider>().date,
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
  DateTime? _date;
  String _dropdownvalue1 = "Solo";
  String _dropdownvalue2 = "Match";
  String _dropdownvalue3 = "No Skill Level Required";
  String _dropdownvalue4 = "Free";

  DateTime? get date => _date;
  String get dropdownvalue1 => _dropdownvalue1;
  String get dropdownvalue2 => _dropdownvalue2;
  String get dropdownvalue3 => _dropdownvalue3;
  String get dropdownvalue4 => _dropdownvalue4;

  void setDate(DateTime? value) {
    _date = value;
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
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
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}

class DropDownSkill extends StatelessWidget {
  const DropDownSkill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>["No Skill Level Required", "Intermediate and above", "Only Professionals"]
          .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (String? value) {
        context.read<DetailProvider>().setdropdownvalue3(value!);
      },
      value: context.read<DetailProvider>().dropdownvalue3,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}

class DropDownReward extends StatelessWidget {
  const DropDownReward({Key? key, required this.isEligible}) : super(key: key);

  final bool isEligible;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: <String>["Free", "\u20b9 100", "\u20b9 500", "\u20b9 1000", "\u20b9 5000"]
          .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (String? value) {
        context.read<DetailProvider>().setdropdownvalue4(value!);
      },
      value: context.read<DetailProvider>().dropdownvalue4,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      validator: (value) {
        if (!isEligible && (value.toString() == "\u20b9 1000" || value.toString() == "\u20b9 5000")) {
          return "You don't have required Organizer level";
        }
        return null;
      },
    );
  }
}
