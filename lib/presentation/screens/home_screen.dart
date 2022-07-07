// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(id: 0, name: 'typography', isFinished: false),
    Task(id: 1, name: 'layout', isFinished: false, subTasks: [
      SubTasks(id: 2, name: 'box modal', isFinished: false),
      SubTasks(id: 3, name: 'grids and containers', isFinished: true),
      SubTasks(id: 4, name: 'implicit grid', isFinished: true),
      SubTasks(id: 5, name: 'negative spaces', isFinished: false),
      SubTasks(id: 6, name: 'alignment', isFinished: true),
    ]),
    Task(id: 7, name: 'color', isFinished: false),
    Task(id: 8, name: 'style', isFinished: false),
    Task(id: 9, name: 'get started', isFinished: true),
  ];

  final TextEditingController _textEditingController = TextEditingController();
  bool _isAdding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAdding = !_isAdding;
            _textEditingController.clear();
          });
        },
        child: _isAdding ? Icon(Icons.cancel) : Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 27),
                child: Text(
                  'tasked',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isAdding)
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 27),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  title: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    controller: _textEditingController,
                    onEditingComplete: () {
                      final String text = _textEditingController.text;
                      if (text.isNotEmpty) {
                        setState(() {
                          tasks.add(Task(
                            name: text,
                            isFinished: false,
                          ));
                          _isAdding = false;
                        });
                        _textEditingController.clear();
                      }
                    },
                  ),
                ),
              ListView.builder(
                  itemCount: tasks.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              setState(() {
                                if (task.subTasks != null) {
                                  task.isSelected = !task.isSelected;
                                }
                              });
                            });
                          },
                          tileColor: task.isSelected
                              ? Color(0xffEEEEEE)
                              : Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 19),
                          leading: IconButton(
                            onPressed: () {
                              setState(() {
                                task.isFinished = !task.isFinished;
                                if (task.subTasks!.any(
                                    (element) => element.isFinished == false)) {
                                  for (var element in task.subTasks!) {
                                    element.isFinished = true;
                                  }
                                } else {
                                  for (var element in task.subTasks!) {
                                    element.isFinished = false;
                                  }
                                }

                                // if (task.subTasks == null) {
                                //   task.isFinished = !task.isFinished;
                                // } else {
                                //   var faund = task.subTasks!.any(
                                //     (element) => element.isFinished == false,
                                //   );
                                //   print(faund);
                                //   if (!faund) {
                                //     task.isFinished = !task.isFinished;
                                //   }
                                // }
                              });
                            },
                            icon: task.isFinished
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    ))
                                : Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                          ),
                          title: Text(
                            task.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: task.isFinished
                                  ? Color(0xff555555)
                                  : Colors.black,
                              decoration: task.isFinished
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        if (task.subTasks != null && task.isSelected == true)
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: task.subTasks!.length,
                              itemBuilder: (context, index) {
                                var subTask = task.subTasks![index];
                                return ListTile(
                                  tileColor: Color(0xffEEEEEE),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 56),
                                  leading: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (!task.isFinished) {
                                          subTask.isFinished =
                                              !subTask.isFinished;
                                          var faund = task.subTasks!.any(
                                            (element) =>
                                                element.isFinished == false,
                                          );

                                          print(faund);
                                          if (!faund) {
                                            task.isFinished = !task.isFinished;
                                          }
                                        } else {
                                          task.isFinished = !task.isFinished;
                                          subTask.isFinished =
                                              !subTask.isFinished;
                                        }
                                      });
                                    },
                                    icon: subTask.isFinished
                                        ? Icon(Icons.done)
                                        : Icon(Icons.circle_outlined),
                                  ),
                                  title: Text(
                                    subTask.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: subTask.isFinished
                                          ? Color(0xff555555)
                                          : Colors.black,
                                      decoration: subTask.isFinished
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                );
                              }),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
