import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/models/task.dart';

class StepList extends StatefulWidget {
  final Task task;
  final Color color;
  final Function onCreate;
  final Function onDelete;
  final VoidCallback onRefresh;
  final Function onComplete;
  final Function onSaveDescription;
  StepList(this.task, this.color, {this.onCreate, this.onDelete, this.onRefresh, this.onComplete, this.onSaveDescription});
  @override
  _StepListState createState() => _StepListState();
}

class _StepListState extends State<StepList> {
  TextEditingController _stepController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isText = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Создано: ${DateFormat('dd.MM.yyyy').format(widget.task.createDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          for (int index = 0; index < widget.task.steps.length; index++) _stepTile(index, widget.task),
          Padding(
            padding: EdgeInsets.all(10),
            child: _addStepButton(),
          ),
          Divider(
            indent: 25,
            endIndent: 25,
            height: 1,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: _descriptionField(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stepController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _addStepButton() {
    if (!isText) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isText = true;
          });
        },
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.blue,
            ),
            Container(
              width: 10,
            ),
            Text(
              'Добавить шаг',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      );
    } else {
      return Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Зачем?';
            }
            return null;
          },
          autofocus: true,
          controller: _stepController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
          onEditingComplete: () {
            if (_formKey.currentState.validate()) {
              widget.onCreate(_stepController.text);
              _stepController.text = '';
              FocusScope.of(context).unfocus();
              widget.onRefresh();
            }
          },
        ),
      );
    }
  }

  Widget _descriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: null,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        widget.onSaveDescription(_descriptionController.text);
        FocusScope.of(context).unfocus();
        widget.onRefresh();
      },
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: 'Заметки по задаче...',
        labelStyle: TextStyle(
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _stepTile(index, task) {
    return Row(
      children: [
        Checkbox(
          value: widget.task.steps[index].isComplete,
          activeColor: widget.color,
          onChanged: (value) {
            widget.onComplete(index);
            widget.onRefresh();
          },
        ),
        Expanded(
          child: Text(
            task.steps[index].title,
            maxLines: null,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey[700],
            ),
            onPressed: () {
              widget.onDelete(index);
              widget.onRefresh();
            },
          ),
        ),
      ],
    );
  }
}
