import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/shared/app_bar.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/dish_list_tile.dart';

class DishListScreen extends ConsumerStatefulWidget {
  const DishListScreen({super.key});

  static const String routeName = '/dish_list';

  @override
  ConsumerState<DishListScreen> createState() => _DishListScreenState();
}

class _DishListScreenState extends ConsumerState<DishListScreen> {
  ScrollController? _scrollController;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      final bool isFabVisible =
          _scrollController!.position.userScrollDirection ==
              ScrollDirection.forward;
      if (_isFabVisible != isFabVisible) {
        setState(() => _isFabVisible = isFabVisible);
      }
    });
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BillModel bill = ref.watch(billStateNotifierProvider);
    final List<DishModel> dishes = bill.dishes;

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: const CustomAppBar(
        title: Text('Dishes'),
      ),
      body: dishes.isEmpty
          ? const Center(
              child: Text('Please add a dish first'),
            )
          : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final DishModel dish = dishes[index];
                return DishListTile(
                  key: ValueKey<String>(dish.uuid),
                  dish: dish,
                );
              },
              itemCount: dishes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 2.0,
              ),
            ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isFabVisible ? 1 : 0,
        child: FloatingActionButton(
          onPressed: () => _addDish(context),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _addDish(BuildContext context) {
    final BillStateNotifier billStateNotifier =
        ref.read(billStateNotifierProvider.notifier);
    billStateNotifier.addDish();
  }
}
