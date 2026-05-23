import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/features.dart';
import 'package:praxis/s.dart';

class NavigationShellInitializer extends StatefulWidget {
  final Widget child;

  const NavigationShellInitializer({super.key, required this.child});

  @override
  State<NavigationShellInitializer> createState() =>
      _NavigationShellInitializerState();
}

class _NavigationShellInitializerState
    extends State<NavigationShellInitializer> {
  late final MainBloc _mainBloc;
  late final LearningBloc _learningBloc;

  @override
  void initState() {
    super.initState();

    final userId = UserScope.of(context, listen: false).id;
    _mainBloc = GetIt.I<MainBloc>()..add(MainLoadCoursesEvent(userId: userId));
    _learningBloc = GetIt.I<LearningBloc>()
      ..add(LearningLoadEvent(userId: userId));

    context.read<UserStatisticsBloc>().add(
      UserStatisticsLoadEvent(userId: userId),
    );
  }

  @override
  void dispose() {
    _mainBloc.close();
    _learningBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _mainBloc),
        BlocProvider.value(value: _learningBloc),
      ],
      child: BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
        listener: (context, state) {
          if (state is CoursePurchasingLoadSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).coursePurchaseSuccess),
                backgroundColor: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CoursePurchasingLoadErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.code.localizedMessage(context)),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is CoursePurchasingInsufficientBalanceState) {
            final s = S.of(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  s.coursePurchaseInsufficientBalanceMessage(
                    state.requiredMoney,
                    state.availableMoney,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: widget.child,
      ),
    );
  }
}
