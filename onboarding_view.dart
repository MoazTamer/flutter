import 'package:first/domain/models.dart';
import 'package:first/presentation/onboarding/viewModel/onboarding_view_model.dart';
import 'package:first/presentation/resources/assets-manager.dart';
import 'package:first/presentation/resources/color_manager.dart';
import 'package:first/presentation/resources/constants_manager.dart';
import 'package:first/presentation/resources/routes_manager.dart';
import 'package:first/presentation/resources/strings_manager.dart';
import 'package:first/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingView extends StatefulWidget{
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {


  final PageController _pageController = PageController();
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  void bind(){
    _viewModel.start();
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _viewModel.outputSliderViewObject,
      builder: (context, snapshot){
        return _getContentWidget(snapshot.data);
      }
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject){
    if (sliderViewObject == null){
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: ColorManager.white,
          statusBarBrightness: Brightness.dark),
      ),
        body: const Center(child: Text(AppStrings.noRouteFound)),
      );
    }
    else {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: ColorManager.white,
            statusBarBrightness: Brightness.dark),
      ),
      body: PageView.builder(
          controller: _pageController,
          itemCount: sliderViewObject.numOfSliders,
          onPageChanged: (index){
            _viewModel.onPageChanged(index);
          },
          itemBuilder: (context, index){
            return OnBoardingPage(sliderViewObject.sliderObject);
          }),
      bottomSheet: Container(
        color: ColorManager.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(AppStrings.skip,textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium,)
              ),
            ),
            _getBottomSheetWidget(sliderViewObject),
          ],
        ),
      ),
    );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject){
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Arrow
          Padding(padding: const EdgeInsets.all(AppPadding.p14),
          child: GestureDetector(
            child: SizedBox(
              width: AppSize.s24,
              height: AppSize.s24,
              child: SvgPicture.asset(ImageAssets.leftArrowIc),
            ),
            onTap: () {
              // go to previous slide
              _pageController.animateToPage(
                  _viewModel.goPrevious(),
                  duration: const Duration(milliseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut);
            },
            ),
          ),
          // Circle Indicator
          Row(
            children: [
              for (int i=0 ; i<sliderViewObject.numOfSliders ; i++)
                Padding(padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject.currentIndex),
                ),
            ],
          ),
          // Right Arrow
          Padding(padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                width: AppSize.s24,
                height: AppSize.s24,
                child: SvgPicture.asset(ImageAssets.rightArrowIc),
              ),
              onTap: () {
                // Next Page
                _pageController.animateToPage(_viewModel.goNext(),
                    duration: const Duration(milliseconds: AppConstants.sliderAnimationTime),
                    curve: Curves.bounceInOut);
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc);
    }
  }
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget{
  final SliderObject _sliderObject;
  const OnBoardingPage(this._sliderObject,{super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppSize.s60),
        SvgPicture.asset(_sliderObject.image),
      ],
    );
  }

}