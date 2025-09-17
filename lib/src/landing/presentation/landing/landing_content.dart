import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

import 'landing_email_form.dart';
import '../../../common/widgets/petri_dish/petri_dish.dart';

class LandingContent extends StatelessWidget {
  const LandingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showPetriDishes = screenWidth > 800;
    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        spacing: 32,
        children: [
          Flexible(
            fit: FlexFit.loose,
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
                LandingEmailForm(),
              ],
            ),
          ),
          if (showPetriDishes)
            Flexible(
              fit: FlexFit.loose,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                  final dishCount = crossAxisCount * crossAxisCount;

                  return GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(64),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 48,
                      mainAxisSpacing: 48,
                    ),
                    itemCount: dishCount,
                    itemBuilder: (context, i) {
                      return PetriDish(larvaeCount: Random().nextInt(2) + 1);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
