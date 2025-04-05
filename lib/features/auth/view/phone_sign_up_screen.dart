import 'package:codium/features/auth/widgets/next_button.dart';
import 'package:codium/features/auth/widgets/phone_field.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class PhoneSignUpScreen extends StatefulWidget {
  const PhoneSignUpScreen({super.key});

  @override
  State<PhoneSignUpScreen> createState() => _PhoneSignUpScreenState();
}

class _PhoneSignUpScreenState extends State<PhoneSignUpScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).appTitle,
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 5,
              ),
              Text(
                S.of(context).displaySignUp,
                style: theme.textTheme.displaySmall,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      S.of(context).labelPhoneNumber,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: PhoneField(
                          hintText: '+7',
                          controller: controller,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: NextButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 26,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(
                flex: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
