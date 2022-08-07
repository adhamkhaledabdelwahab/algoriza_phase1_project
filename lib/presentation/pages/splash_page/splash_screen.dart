import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_states/app_states.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/board_screen.dart';
import 'package:algoriza_phase1_project/presentation/pages/splash_page/widgets/splash_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  final String _splashImagePath = "assets/images/splash_background.png";
  final double _splashScreenPadding = 35;
  final double _splashImageHeight = 300;

  final String _splashTitleText = "Manage and prioritize you tasks easily";
  final double _titleFontSize = 30;
  final FontWeight _titleFontWeight = FontWeight.bold;
  final Color _titleColor = Colors.black;

  final String _splashAppInfoText =
      "Increase your productivity by managing your personal "
      "and team task and do them based on the highest priority!";
  final double _subtitleFontSize = 18;
  final FontWeight _subtitleFontWeight = FontWeight.w500;
  final Color _subtitleColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppDatabaseTasksFetchedState) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const BoardScreen()));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(_splashScreenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _splashImagePath,
                  fit: BoxFit.cover,
                  height: _splashImageHeight,
                ),
                const SizedBox(
                  height: 30,
                ),
                SplashTextWidget(
                  fontWeight: _titleFontWeight,
                  color: _titleColor,
                  text: _splashTitleText,
                  fontSize: _titleFontSize,
                ),
                const SizedBox(
                  height: 30,
                ),
                SplashTextWidget(
                  fontWeight: _subtitleFontWeight,
                  color: _subtitleColor,
                  text: _splashAppInfoText,
                  fontSize: _subtitleFontSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
