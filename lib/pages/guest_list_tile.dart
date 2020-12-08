import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class GuestListTile extends StatefulHookWidget {
  GuestListTile({@required this.key, @required this.guest})
      : assert(key != null && guest != null);

  final Key key;
  final GuestModel guest;

  @override
  _GuestListTileState createState() => _GuestListTileState();
}

class _GuestListTileState extends State<GuestListTile> {
  final Logger logger = getLogger();

  final TextEditingController _nameTextController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isNameClearVisible = false;

  BillStateNotifier billStateNotifier;

  @override
  void initState() {
    super.initState();
    _nameTextController.addListener(_toggleNameClearVisible);
    _nameTextController.text = (widget.guest == null) ? '' : widget.guest.name;

    _nameFocusNode.addListener(_editGuest);

    billStateNotifier = context.read(billStateNotifierProvider);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void _toggleNameClearVisible() {
    setState(() {
      _isNameClearVisible = _nameTextController.text.isNotEmpty;
    });
  }

  void _editGuest() {
    if (!_nameFocusNode.hasFocus) {
      _editGuestName(_nameTextController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _deleteGuest,
        ),
      ],
      child: ListTile(
        title: _buildNameTextField(widget.guest),
        // trailing: _buildEditButton(context, category),
      ),
    );
  }

  Widget _buildNameTextField(GuestModel guest) {
    return TextField(
      maxLength: 50,
      focusNode: _nameFocusNode,
      controller: _nameTextController,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.perm_identity,
            ),
          ),
          suffixIcon: !_isNameClearVisible
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    _nameTextController.clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                  )),
          labelText: 'Name',
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          filled: true,
          fillColor: Colors.white),
      onChanged: (String value) {
        // TODO
        print('changed');
      },
      onEditingComplete: () {
        // TODO
        print('complete');
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
    );
  }

  void _editGuestName(String name) {
    print('lost focus: $name');
    billStateNotifier.editGuest(
      GuestModel(uuid: widget.guest.uuid, name: name),
    );
  }

  void _deleteGuest() {
    billStateNotifier.removeGuest(
      widget.guest,
    );
  }
}
