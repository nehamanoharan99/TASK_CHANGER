import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todoapp/task_splash.dart';

class TaskChanger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TASK CHANGER',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: taskHomePage(),
    );
  }
}

class taskHomePage extends StatefulWidget {
  @override
  _taskHomePageState createState() => _taskHomePageState();
}

class _taskHomePageState extends State<taskHomePage> {
  List<String> taskList = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTaskList();
  }

  Future<void> saveTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('taskList', jsonEncode(taskList));
  }

  Future<void> loadTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskListString = prefs.getString('taskList');
    if (taskListString != null) {
      setState(() {
        taskList = List<String>.from(jsonDecode(taskListString));
      });
    }
  }

  void addTaskItem() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        taskList.add(taskController.text);
      });
      taskController.clear();
      saveTaskList();
    }
  }

  void removeTaskItem(int index) {
    setState(() {
      taskList.removeAt(index);
    });
    saveTaskList();
  }

  void updateTaskItem(int index, String updatedText) {
    setState(() {
      taskList[index] = updatedText;
    });
    saveTaskList();
  }

  void showDialogBox(int index) {
    TextEditingController updateController = TextEditingController();
    updateController.text = taskList[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('EDIT TASK'),
          content: TextField(
            controller: updateController,
            decoration: InputDecoration(hintText: 'EDIT YOUR TASK'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (updateController.text.isNotEmpty) {
                  updateTaskItem(index, updateController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('EDIT'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TASK LIST"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            hintText: 'Add Task',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: addTaskItem,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          child: Text("Add"),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.blue.withOpacity(0.9),
                          child: ListTile(
                            title: Text(
                              taskList[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () => showDialogBox(index),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => removeTaskItem(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ),
                );
              },
              backgroundColor: Color.fromARGB(255, 26, 168, 80),
              child: Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
