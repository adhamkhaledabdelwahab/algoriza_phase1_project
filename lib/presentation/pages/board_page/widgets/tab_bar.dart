import 'package:algoriza_phase1_project/presentation/cubit/board_screen_cubit/board_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardTabBar extends StatelessWidget {
  const BoardTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCubit, BoardState>(
      builder: (BuildContext context, state) {
        return DefaultTabController(
          length: 4,
          child: TabBar(
            onTap: (index) {
              BoardCubit.get(context).changeSelectedTab(index, context);
            },
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: Colors.black,
            isScrollable: true,
            labelColor: Colors.black,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: 10,
            ),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            tabs: List.generate(
              BoardCubit.get(context).tabsCount,
              (index) => Tab(
                text: BoardCubit.get(context).tabsText[index],
              ),
            ),
          ),
        );
      },
    );
  }
}
