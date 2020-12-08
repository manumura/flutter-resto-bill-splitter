import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/pages/guest_list_tile.dart';
import 'package:restobillsplitter/state/providers.dart';

class GuestListScreen extends HookWidget {
  static const String routeName = '/guest_list';

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final List<GuestModel> guests = bill.guests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guests'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          _buildAddGuestButton(context),
        ],
      ),
      body: guests.isEmpty
          ? const Center(
              child: Text('Please add a guest'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final GuestModel guest = guests[index];
                return GuestListTile(
                    key: ValueKey<String>(guest.uuid), guest: guest);
              },
              itemCount: guests.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
            ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   elevation: 1.0,
      //   notchMargin: 1.0,
      //   child: Text('Bottom'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _addGuest(context),
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildAddGuestButton(BuildContext context) {
    return TextButton.icon(
      label: const Text('ADD'),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            } else {
              return Colors.white;
            }
          },
        ),
      ),
      onPressed: () => _addGuest(context),
    );
  }

  void _addGuest(BuildContext context) {
    final BillStateNotifier billStateNotifier =
        context.read(billStateNotifierProvider);
    billStateNotifier.addGuest();
  }
}
