import 'package:flutter/material.dart';
import 'package:test_app/models/branch.dart';

class CreateBranchDialog extends StatefulWidget {
  final List<Branch> branchList;
  final VoidCallback onRefresh;
  CreateBranchDialog({this.branchList, this.onRefresh});
  @override
  _CreateBranchDialogState createState() => _CreateBranchDialogState();
}

class _CreateBranchDialogState extends State<CreateBranchDialog> {
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Создать список',
        style: TextStyle(fontSize: 16),
      ),
      children: [
        Container(
          height: 10,
        ),
        Container(
          child: TextField(
            maxLength: 30,
            onEditingComplete: () => _complete(),
            controller: _titleController,
            decoration: InputDecoration(
                hintText: 'Введите название списка', isDense: true),
          ),
        ),
        Container(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: Text(
                'Отмена',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'Создать',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () => _complete(),
            ),
          ],
        ),
      ],
    );
  }

  _complete() {
    var lastTaskId = widget.branchList.isEmpty ? 0 : widget.branchList.last.id;
    widget.branchList.add(
      Branch(++lastTaskId, _titleController.text),
    );
    widget.onRefresh();
    Navigator.pop(context);
  }
}
