import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.dark),
      home: Scaffold(
        body: Welcome(),
      ),
    );
  }
  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.workSansTextTheme(baseTheme.textTheme),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hello!',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image(
              image: AssetImage('images/logo.png'),
              width: 200,
              height: 200,
            ),
          ),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade700,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade900.withOpacity(0.5),
                  blurRadius: 4,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Text(
              'Do you wish to keep track of your grades and overall GPA? This calculator helps you to calculate your cumulative GPA so you can manage your academic goals better.',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Calculator()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                "YES, LET'S GO!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final TextEditingController _moduleController = TextEditingController();
  final TextEditingController _creditsController = TextEditingController();
  final _gradeList = ['A', 'B', 'C', 'D', 'F'];
  var _selectedGrade = "";

  List<Module> modules = [];
  double cumulativeGPA = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ModuleInputForm(
              onModuleAdded: (Module module) {
                setState(() {
                  modules.add(module);
                  cumulativeGPA = calculateCumulativeGPA();
                  updateCumulativeGPA();
                });
              },
            ),
            Text(
              'Cumulative GPA: ${cumulativeGPA.toStringAsFixed(3)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModuleListScreen(modules: modules),
                  ),
                ).then((_) {
                  // Update cumulative GPA when returning from ModuleListScreen
                  updateCumulativeGPA();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: const Text(
                  'VIEW ALL MODULES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCumulativeGPA() {
    cumulativeGPA = calculateCumulativeGPA();
  }

  double calculateCumulativeGPA() {
    double totalPoints = 0.0;
    double totalCredits = 0.0;

    for (var module in modules) {
      totalPoints += module.creditUnits * module.gradePoints;
      totalCredits += module.creditUnits;
    }

    return totalPoints / totalCredits;
  }
}

class ModuleInputForm extends StatefulWidget {
  final Function onModuleAdded;

  ModuleInputForm({required this.onModuleAdded});

  @override
  _ModuleInputFormState createState() => _ModuleInputFormState();
}

class _ModuleInputFormState extends State<ModuleInputForm> {
  final TextEditingController titleController = TextEditingController();
  String selectedGrade = 'A';
  String creditUnits = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Calculate my GPA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        TextField(
          controller: titleController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Module title',
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField(
          value: selectedGrade,
          onChanged: (String? newValue) {
            setState(() {
              selectedGrade = newValue!;
            });
          },
          items: ['A', 'B', 'C', 'D'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.grey,
          ),
          dropdownColor: Colors.grey.shade900,
          decoration: const InputDecoration(
            labelText: 'Grade attained',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              creditUnits = value;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Module credit units',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && double.tryParse(creditUnits) != null) {
              Module module = Module(
                title: titleController.text,
                grade: selectedGrade,
                creditUnits: double.parse(creditUnits),
              );
              widget.onModuleAdded(module);
              titleController.clear();
              creditUnits = '';
              selectedGrade = 'A';
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text("Please fill in all fields."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text(
              'ENTER',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ModuleListScreen extends StatefulWidget {
  final List<Module> modules;

  ModuleListScreen({required this.modules});

  @override
  State<ModuleListScreen> createState() => _ModuleListScreenState();
}

class _ModuleListScreenState extends State<ModuleListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Modules'),
      ),
      body: ListView.builder(
        itemCount: widget.modules.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.modules[index].title),
            subtitle: Text('Grade: ${widget.modules[index].grade}, Credit Units: ${widget.modules[index].creditUnits}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditModuleScreen(
                          module: widget.modules[index],
                          onModuleEdited: (Module editedModule) {
                            setState(() {
                              widget.modules[index] = editedModule;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.modules.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Module {
  String title;
  String grade;
  double creditUnits;

  Module({required this.title, required this.grade, required this.creditUnits});

  double get gradePoints {
    switch (grade) {
      case 'A': return 4.0;
      case 'B': return 3.0;
      case 'C': return 2.0;
      case 'D': return 1.0;
      default: return 0.0;
    }
  }
}

class EditModuleScreen extends StatefulWidget {
  final Module module;
  final Function onModuleEdited;

  EditModuleScreen({required this.module, required this.onModuleEdited});

  @override
  State<EditModuleScreen> createState() => _EditModuleScreenState();
}

class _EditModuleScreenState extends State<EditModuleScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late String selectedGrade;
  late String creditUnits;

  // Validation functions
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title.';
    }
    return null;
  }

  String? validateCreditUnits(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter credit units.';
    }
    double? parsedValue = double.tryParse(value);
    if (parsedValue == null || parsedValue <= 0) {
      return 'Please enter a valid number of credit units.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.module.title);
    selectedGrade = widget.module.grade;
    creditUnits = widget.module.creditUnits.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Module'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Module title',
                ),
                validator: validateTitle,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: selectedGrade,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGrade = newValue!;
                  });
                },
                items: ['A', 'B', 'C', 'D'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.grey,
                ),
                dropdownColor: Colors.grey.shade900,
                decoration: const InputDecoration(
                  labelText: 'Grade attained',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    creditUnits = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Module credit units',
                ),
                validator: validateCreditUnits,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Explicitly trigger validation
          if (_formKey.currentState?.validate() == true) {
            // Validation passed, update the module details
            Module editedModule = Module(
              title: titleController.text,
              grade: selectedGrade,
              creditUnits: double.parse(creditUnits),
            );
            widget.onModuleEdited(editedModule);
            Navigator.pop(context); // Close the edit screen
          } else {
            // Validation failed, show a message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please correct the errors in the form.'),
              ),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}