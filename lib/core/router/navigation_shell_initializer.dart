import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/features.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationShellInitializer extends StatefulWidget {
  final Widget child;

  const NavigationShellInitializer({super.key, required this.child});

  @override
  State<NavigationShellInitializer> createState() =>
      _NavigationShellInitializerState();
}

class _NavigationShellInitializerState
    extends State<NavigationShellInitializer> {
  @override
  void initState() {
    super.initState();

    final userId = UserScope.of(context, listen: false).id;

    context.read<UserStatisticsBloc>().add(
      UserStatisticsLoadEvent(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursePurchasingBloc, CoursePurchasingState>(
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
              content: Text(state.error),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is CoursePurchasingInsufficientBalanceState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // TODO: Replace with localized string
              content: Text(
                'Недостаточно монет. Нужно: ${state.required}, '
                'Доступно: ${state.available}',
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: widget.child,
    );
  }
}
