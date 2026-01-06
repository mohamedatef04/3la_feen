import 'dart:async';

import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/decode_polykine.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';

import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_places_items.dart/get_places_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/location_widgets/location_popup_header.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/location_widgets/choose_on_map_button.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/location_widgets/places_list.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/location_widgets/use_my_current_location_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideLocationPopup extends StatefulWidget {
  const RideLocationPopup({
    super.key,
  });

  @override
  State<RideLocationPopup> createState() => _RideLocationPopupState();
}

class _RideLocationPopupState extends State<RideLocationPopup> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  FocusNode fromFocusNode = FocusNode();
  FocusNode toFocusNode = FocusNode();
  Timer? _timer;
  double? fromLat;
  double? fromLng;
  double? toLat;
  double? toLng;
  LatLng? myCurrentLocation;

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() {
    final cubit = context.read<TrackMyLocationCubit>();
    cubit.getCurrentLocation((locationData) {
      if (mounted) {
        setState(() {
          myCurrentLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              spacing: 20.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocationPopupHeader(),
                Stack(
                  children: [
                    Column(
                      children: [
                        CustomTextFormField(
                          focusNode: fromFocusNode,
                          controller: fromController,
                          autofocus: true,
                          hintText: AppStrings.from,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          prefixIcon: Icon(
                            Icons.trip_origin,
                            color: Colors.green,
                            size: 20.sp,
                          ),
                          onChanged: (value) {
                            _timer?.cancel();
                            _timer = Timer(
                              const Duration(milliseconds: 500),
                              () {
                                context.read<GetPlacesCubit>().searchPlaces(
                                  value,
                                );
                              },
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppStrings.fromValidator;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12.h),
                        CustomTextFormField(
                          focusNode: toFocusNode,
                          controller: toController,
                          hintText: AppStrings.to,

                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.sp,
                          ),
                          onChanged: (value) {
                            _timer?.cancel();
                            _timer = Timer(
                              const Duration(milliseconds: 500),
                              () {
                                context.read<GetPlacesCubit>().searchPlaces(
                                  value,
                                );
                              },
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppStrings.toValidator;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    // Vertical Connecting Line
                    Positioned(
                      right: 25.w, // Aligned with the icons
                      top: 40.h,
                      bottom: 40.h,
                      child: Container(
                        width: 1.5.w,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ],
                ),

                ChooseOnMapButton(
                  onTap: () {},
                ),
                BlocListener<TrackMyLocationCubit, TrackMyLocationState>(
                  listener: (context, state) {
                    if (state is TrackMyLocationFailure) {
                      showCustomSnackBar(context, state.errorMessage);
                    }
                  },
                  child: UseMyCurrentLocationWidget(
                    onTap: () {
                      if (myCurrentLocation != null) {
                        setState(() {
                          fromController.text = 'الموقع الحالي';
                          fromLat = myCurrentLocation!.latitude;
                          fromLng = myCurrentLocation!.longitude;
                        });
                      } else {
                        showCustomSnackBar(
                          context,
                          'جاري تحديد موقعك، يرجى الانتظار...',
                        );
                        _initLocationTracking();
                      }
                    },
                  ),
                ),
                BlocConsumer<GetRouteCubit, GetRouteState>(
                  listener: (context, state) {
                    if (state is GetRouteSuccess) {
                      if (state.route.routes == null ||
                          state.route.routes!.isEmpty) {
                        showCustomSnackBar(context, 'No route found');
                        return;
                      }
                      final geometry = state.route.routes![0].geometry ?? '';
                      if (geometry.isEmpty) return;

                      List<LatLng> routePoints = decodePolyline(geometry);
                      context.read<DrawPolylineCubit>().drawRoute(
                        routePoints,
                      );

                      context.pop();
                    } else if (state is GetRouteFailure) {
                      showCustomSnackBar(context, state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child: CustomButtonWidget(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (fromLat != null &&
                                fromLng != null &&
                                toLat != null &&
                                toLng != null) {
                              context.read<GetRouteCubit>().getRoute(
                                startLat: fromLat!,
                                startLng: fromLng!,
                                endLat: toLat!,
                                endLng: toLng!,
                                startLocation: fromController.text,
                                endLocation: toController.text,
                              );
                            }
                          } else {
                            autovalidateMode = AutovalidateMode.always;
                            setState(() {});
                          }
                        },
                        child: state is GetRouteLoading
                            ? CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : Text('بحث', style: AppTextStyles.bold14(context)),
                      ),
                    );
                  },
                ),

                Expanded(
                  child: PlacesList(
                    onTap: (place) {
                      if (fromFocusNode.hasFocus) {
                        fromController.text = place.displayName ?? '';
                        fromLat = double.parse(place.lat ?? '');
                        fromLng = double.parse(place.lon ?? '');
                      } else if (toFocusNode.hasFocus) {
                        toController.text = place.displayName ?? '';
                        toLat = double.parse(place.lat ?? '');
                        toLng = double.parse(place.lon ?? '');
                      }
                      context.read<GetPlacesCubit>().reset();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
