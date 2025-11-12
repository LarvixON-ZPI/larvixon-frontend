import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish.dart';
import 'package:larvixon_frontend/src/landing/presentation/widgets/landing_email_form.dart';

class LandingContent extends StatelessWidget {
  const LandingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showPetriDishes = screenWidth > 800;
    return Row(
      spacing: 32,
      children: [
        Flexible(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                context.translate.larvixonHeader,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                context.translate.larvixonDescription,
                style: Theme.of(context).textTheme.headlineMedium!,
              ),
              const LandingEmailForm(),
            ],
          ),
        ),
        if (showPetriDishes)
          Flexible(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 400,
                ),
                child: const PetriDish(),
              ),
            ),
          ),
      ],
    );
  }
}
