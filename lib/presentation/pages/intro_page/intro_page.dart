import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_text_style.dart';
import '../../../data/datasource/local/intro_data.dart';
import '../../cubit/intro_cubit.dart';
import '../../cubit/splash_cubit.dart';
import '../../widget/widget.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IntroCubit(),
      child: BlocListener<SplashCubit, SplashStatus>(
        listener: (context, state) {
          if (state == SplashStatus.login) {
            context.go('/login');
          }
        },
        child: const _IntroView(),
      ),
    );
  }
}

class _IntroView extends StatefulWidget {
  const _IntroView();

  @override
  State<_IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<_IntroView> {
  int _carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroCubit, int>(
      builder: (context, currentIndex) {
        final page = pages[currentIndex];

        return Scaffold(
          body: Stack(
            children: [
              _imageIntro(currentIndex, page, context),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 8, color: Colors.black26),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: Column(
                          key: ValueKey("text-$currentIndex"),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  page['title'],
                                  variant: TextVariant.heading6,
                                  weight: TextWeight.bold,
                                ),
                              ],
                            ),
                            const AppGap.height(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: AppText(
                                    maxLines: 5,
                                    page['desc'],
                                    variant: TextVariant.body2,
                                    weight: TextWeight.regular,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          if (currentIndex != 0) ...[
                            Expanded(
                              child: AppElevatedButton(
                                text: "Kembali",
                                onPressed: () {
                                  context.read<IntroCubit>().prevPage();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],

                          Expanded(
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.elasticOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,

                                width: currentIndex != 0
                                    ? double.infinity * 0.8
                                    : double.infinity,
                                child: AppElevatedButton(
                                  text: currentIndex == pages.length - 1
                                      ? "Mulai"
                                      : "Lanjut",
                                  onPressed: () async {
                                    if (currentIndex == pages.length - 1) {
                                      context.read<SplashCubit>().finishIntro();
                                    } else {
                                      context.read<IntroCubit>().nextPage();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Positioned _imageIntro(
    int currentIndex,
    Map<String, dynamic> page,
    BuildContext context,
  ) {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: currentIndex == 1
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider.builder(
                    itemCount: (page["image"] as List).length,
                    itemBuilder: (context, i, realIndex) {
                      return Image.asset(
                        page["image"][i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      onPageChanged: (i, reason) {
                        setState(() => _carouselIndex = i);
                      },
                    ),
                  ),

                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.380,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (page["image"] as List).length,
                        (dotIndex) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _carouselIndex == dotIndex ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _carouselIndex == dotIndex
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: Image.asset(
                    page["image"],
                    key: ValueKey(page["image"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }
}
