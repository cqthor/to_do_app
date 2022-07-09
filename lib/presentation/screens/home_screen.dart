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
  final TextEditingController _taskEditingController = TextEditingController();
  bool _isAdding = false;
  bool _isEditing = false;
  bool isAdding1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isAdding == false &&
                _isEditing == false &&
                isAdding1 == false) {
              _isAdding = true;
              _textEditingController.clear();
            } else if (_isEditing == true &&
                _isAdding == false &&
                isAdding1 == false) {
              _isEditing = false;
              for (var element in tasks) {
                element.isEditing = false;
              }
            } else if (isAdding1 && !_isAdding && !_isEditing) {
              isAdding1 = false;

              for (var element in tasks) {
                if (element.isAdding == true) {
                  element.isSelected = false;
                }
                element.isAdding = false;
              }

              _textEditingController.clear();
            } else {
              _isAdding = false;
              _isEditing = false;
            }
          });
        },
        child: _isAdding || _isEditing || isAdding1
            ? const Icon(
                Icons.close,
                size: 30,
              )
            : const Icon(
                Icons.add,
                size: 30,
              ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 27),
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
                    decoration: const InputDecoration(border: InputBorder.none),
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    controller: _textEditingController,
                    onEditingComplete: () {
                      final String text = _textEditingController.text.trim();
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Container(
                      color: task.isSelected
                          ? const Color(0xffEEEEEE)
                          : Colors.white,
                      child: Column(
                        children: [
                          Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 27),
                                child: Icon(Icons.delete),
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                setState(() {
                                  task.isSelected = false;
                                  var deletedItem = tasks.removeAt(index);
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Deleted \"Task title - ${deletedItem.name}\""),
                                        action: SnackBarAction(
                                          label: "UNDO",
                                          onPressed: () {
                                            setState(() => tasks.insert(
                                                index, deletedItem));
                                          },
                                        ),
                                      ),
                                    );
                                });
                              }
                            },
                            key: ObjectKey(task),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  if (!_isEditing) {
                                    if (tasks.every((element) =>
                                            element.isEditing == false) &&
                                        task.isFinished == false) {
                                      task.isEditing = true;
                                      _isEditing = true;
                                      _taskEditingController.text = task.name;
                                    }
                                  }
                                });
                              },
                              trailing: task.subTasks != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              task.isSelected =
                                                  !task.isSelected;
                                            });
                                          },
                                          icon: task.isSelected
                                              ? const Icon(Icons.arrow_drop_up)
                                              : const Icon(
                                                  Icons.arrow_drop_down),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (!isAdding1 &&
                                                  !_isAdding &&
                                                  !_isEditing) {
                                                task.isAdding = !task.isAdding;
                                                isAdding1 = true;
                                                task.isSelected = true;
                                              } else if (task.isAdding) {
                                                task.isAdding = false;
                                                isAdding1 = false;
                                                task.isSelected = false;
                                              }
                                            });
                                          },
                                          icon: task.isAdding
                                              ? const Icon(Icons.close)
                                              : const Icon(Icons.add),
                                        ),
                                      ],
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (!isAdding1 &&
                                              !_isAdding &&
                                              !_isEditing) {
                                            task.isAdding = !task.isAdding;
                                            isAdding1 = true;
                                            task.isSelected = true;
                                          } else if (task.isAdding) {
                                            task.isAdding = false;
                                            isAdding1 = false;
                                            task.isSelected = false;
                                          }
                                        });
                                      },
                                      icon: task.isAdding
                                          ? const Icon(Icons.close)
                                          : const Icon(Icons.add),
                                    ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 19, vertical: 0),
                              leading: IconButton(
                                onPressed: () {
                                  setState(() {
                                    task.isFinished = !task.isFinished;
                                    if (task.subTasks != null) {
                                      if (task.subTasks!.any((element) =>
                                          element.isFinished == false)) {
                                        for (var element in task.subTasks!) {
                                          element.isFinished = true;
                                        }
                                      } else {
                                        for (var element in task.subTasks!) {
                                          element.isFinished = false;
                                        }
                                      }
                                    }
                                  });
                                },
                                icon: task.isFinished
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ))
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                              ),
                              title: task.isEditing && _isEditing
                                  ? TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: task.name,
                                      ),
                                      autofocus: true,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      controller: _taskEditingController,
                                      onEditingComplete: () {
                                        final String text =
                                            _taskEditingController.text.trim();
                                        setState(() {
                                          if (text.isNotEmpty) {
                                            task.name = text;
                                          }
                                          task.isEditing = false;
                                          _isEditing = false;
                                        });
                                      },
                                    )
                                  : Text(
                                      task.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: task.isFinished
                                            ? const Color(0xff555555)
                                            : Colors.black,
                                        decoration: task.isFinished
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                            ),
                          ),
                          if (task.isAdding &&
                              isAdding1 &&
                              !_isEditing &&
                              !_isAdding)
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 56),
                              leading: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.circle_outlined)),
                              title: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                autofocus: true,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                controller: _textEditingController,
                                onEditingComplete: () {
                                  final String text =
                                      _textEditingController.text.trim();
                                  if (text.isNotEmpty) {
                                    setState(() {
                                      if (task.subTasks != null) {
                                        task.subTasks!.add(SubTasks(
                                          name: text,
                                          isFinished: false,
                                        ));
                                      } else {
                                        task.subTasks = [
                                          SubTasks(
                                            name: text,
                                            isFinished: false,
                                          )
                                        ];
                                      }
                                      task.isFinished = false;
                                      task.isAdding = false;
                                      isAdding1 = false;
                                    });
                                    _textEditingController.clear();
                                  }
                                },
                              ),
                            ),
                          if (task.subTasks != null && task.isSelected == true)
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: task.subTasks!.length,
                                itemBuilder: (context, index) {
                                  var subTask = task.subTasks![index];
                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 31),
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                    onDismissed: (DismissDirection direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        setState(() {
                                          var deletedItem =
                                              task.subTasks!.removeAt(index);

                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Deleted \"Task title - ${deletedItem.name}\""),
                                                action: SnackBarAction(
                                                  label: "UNDO",
                                                  onPressed: () {
                                                    setState(() {
                                                      if (task.subTasks !=
                                                          null) {
                                                        task.subTasks!.insert(
                                                            index, deletedItem);
                                                      } else {
                                                        task.subTasks = [
                                                          deletedItem
                                                        ];
                                                        if (!deletedItem
                                                            .isFinished) {
                                                          task.isFinished =
                                                              false;
                                                        }

                                                        task.isSelected = true;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          if (!task.isFinished) {
                                            var faund = task.subTasks!.any(
                                              (element) =>
                                                  element.isFinished == false,
                                            );
                                            if (!faund) {
                                              task.isFinished =
                                                  !task.isFinished;
                                            }
                                          }
                                          if (task.subTasks!.isEmpty) {
                                            task.isSelected = false;
                                            task.subTasks = null;
                                          }
                                        });
                                      }
                                    },
                                    key: ObjectKey(subTask),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          if (!_isEditing) {
                                            if (task.subTasks!.every(
                                                    (element) =>
                                                        element.isEditing ==
                                                        false) &&
                                                subTask.isFinished == false) {
                                              subTask.isEditing = true;
                                              _isEditing = true;
                                              _taskEditingController.text =
                                                  subTask.name;
                                            }
                                          }
                                        });
                                      },
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 56),
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
                                              // print(faund);
                                              if (!faund) {
                                                task.isFinished =
                                                    !task.isFinished;
                                              }
                                            } else {
                                              task.isFinished =
                                                  !task.isFinished;
                                              subTask.isFinished =
                                                  !subTask.isFinished;
                                            }
                                          });
                                        },
                                        icon: subTask.isFinished
                                            ? const Icon(Icons.done)
                                            : const Icon(Icons.circle_outlined),
                                      ),
                                      title: subTask.isEditing && _isEditing
                                          ? TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: subTask.name,
                                              ),
                                              autofocus: true,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                              controller:
                                                  _taskEditingController,
                                              onEditingComplete: () {
                                                final String text =
                                                    _taskEditingController.text
                                                        .trim();
                                                setState(() {
                                                  if (text.isNotEmpty) {
                                                    subTask.name = text;
                                                  }
                                                  subTask.isEditing = false;
                                                  _isEditing = false;
                                                });
                                              },
                                            )
                                          : Text(
                                              subTask.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: subTask.isFinished
                                                    ? const Color(0xff555555)
                                                    : Colors.black,
                                                decoration: subTask.isFinished
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                            ),
                                    ),
                                  );
                                }),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
