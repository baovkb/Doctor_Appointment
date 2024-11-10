import 'dart:async';

import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/presentation/blocs/schedule_search_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/available_schedule_cart.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:doctor_appointment/presentation/widgets/small_gray_button.dart';
import 'package:doctor_appointment/presentation/widgets/small_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final Color _searchBarColor;
  late final Color _mainTextColor;
  late final Color _secondaryTextColor;
  late final Color _resultBgColor;
  late final TextEditingController _inputSearchController;
  late final Color _hintSearchColor;
  late final ScheduleSearchCubit _availableScheduleCubit;
  late final BaseButton _bookButton;
  String keyword = '';
  Timer? _debounceSearch;

  @override
  void initState() {
    super.initState();

    _inputSearchController = TextEditingController();
    _availableScheduleCubit = Provider.of<ScheduleSearchCubit>(context, listen: false);

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _searchBarColor = AppColors.whiteColor;
      _mainTextColor = AppColors.blackColor;
      _hintSearchColor = AppColors.gray1;
      _resultBgColor = AppColors.whiteColor;
      _bookButton = SmallPrimaryButton(child: Text(AppStrings.bookAppoimentAction));
    } else {
      _searchBarColor = AppColors.darkFg;
      _mainTextColor = AppColors.darkWhite;
      _hintSearchColor = AppColors.gray2;
      _resultBgColor = AppColors.darkBg;
      _bookButton = SmallGrayButton(child: Text(AppStrings.bookAppoimentAction));
    }
    _secondaryTextColor = AppColors.gray2;
  }

  @override
  void dispose() {
    _inputSearchController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: _searchBarColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppIcons.search, color: _mainTextColor,),
                    SizedBox(width: 16,),
                    Expanded(
                      child: TextField(
                        style: AppTextStyles.bodyMedium,
                        controller: _inputSearchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: AppStrings.searchHint,
                          hintStyle: AppTextStyles.bodyMedium!.copyWith(color: _hintSearchColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                          )
                        ),
                        onChanged: _onChanged,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _inputSearchController.clear();
                        _onChanged('');
                      } ,
                      child: Image.asset(AppIcons.close, color: _mainTextColor,))
                  ],
                ),
              ),
              _buildResult(context),
            ],
          ),
        ),
      ),
    );
  }

  void _onChanged(value) {
    if (_debounceSearch?.isActive??false) {
      _debounceSearch?.cancel();
    }

    _debounceSearch = Timer(Duration(milliseconds: 500), () {
      String tmpKw = value.trim().toLowerCase();
      if (tmpKw.compareTo(keyword) == 0) return;

      keyword = tmpKw;
      _availableScheduleCubit.getAvailabelSchedulesByKeyWord(keyword);
    });
  }

  BlocBuilder _buildResult(BuildContext context) {
   return BlocBuilder<ScheduleSearchCubit, GetAvailableScheduleByKeywordState>(
    builder: (_, state) {
      if (state is GetAvailableSchedulesByKeywordSuccess) {
        if (state.doctorList.length == 0) {
          return SizedBox();
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          color: _resultBgColor,
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(bottom: 32, top: 24, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.result, style: AppTextStyles.h3Bold!.copyWith(color: _mainTextColor),),
              SizedBox(height: 16,),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                    return AvailableScheduleCart(
                      bgColor: _searchBarColor, 
                      mainTextColor: _mainTextColor, 
                      secondaryTextColor: _secondaryTextColor, 
                      button: _bookButton, 
                      doctor: state.doctorList[index], 
                      schedule: state.scheduleList[index], 
                      location: state.locationList[index], 
                      specialist: state.specialistList[index],
                      onCardTap: (doctor, location, schedule, specialist) {
                        Navigator.pushNamed(context, RouteName.DOCTOR_INFO_PAGE, arguments: {
                          'doctor': state.doctorList[index],
                          'specialist': state.specialistList[index],
                          'location': state.locationList[index],
                          'schedule': state.scheduleList[index]
                        });
                      });
                }, 
                separatorBuilder: (context, index) => SizedBox(height: 16,), 
                itemCount: state.doctorList.length)
            ],
          ),
        );
      } else return SizedBox(); 
    },
   );
  }
}