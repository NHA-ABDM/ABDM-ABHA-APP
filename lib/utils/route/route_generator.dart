import 'package:abha/app/abha_card/view/main/abha_card_view.dart';
import 'package:abha/app/abha_number/view/main/abha_number_card_view.dart';
import 'package:abha/app/abha_number/view/main/abha_number_option_view.dart';
import 'package:abha/app/abha_number/view/main/abha_number_otp_view.dart';
import 'package:abha/app/abha_number/view/main/abha_number_phone_view.dart';
import 'package:abha/app/abha_number/view/main/abha_number_view.dart';
import 'package:abha/app/abha_number/view/main/forget/abha_number_forget_card_view.dart';
import 'package:abha/app/abha_number/view/main/forget/abha_number_forget_otp_view.dart';
import 'package:abha/app/abha_number/view/main/forget/abha_number_forget_via_aadhar_phone_view.dart';
import 'package:abha/app/abha_number/view/main/forget/abha_number_forget_view.dart';
import 'package:abha/app/about_us/about_us_view.dart';
import 'package:abha/app/app_intro/app_intro_controller.dart';
import 'package:abha/app/app_intro/view/main/app_intro_view.dart';
import 'package:abha/app/consents/view/main/consent_artefacts_details_view.dart';
import 'package:abha/app/consents/view/main/consent_details_view.dart';
import 'package:abha/app/consents/view/main/consent_edit_view.dart';
import 'package:abha/app/consents/view/main/consent_my_details_view.dart';
import 'package:abha/app/consents/view/main/consent_my_view.dart';
import 'package:abha/app/consents/view/main/consents_view.dart';
import 'package:abha/app/contact_us/contact_us_mobile_view.dart';
import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/dashboard/view/main/dashboard_view.dart';
import 'package:abha/app/discovery_linking/view/main/discover_hip_view.dart';
import 'package:abha/app/discovery_linking/view/main/discovery_linking_view.dart';
import 'package:abha/app/discovery_linking/view/main/link_hip_view.dart';
import 'package:abha/app/discovery_linking/view/main/link_otp_view.dart';
import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/app/health_locker/view/main/health_locker_authorization_request_view.dart';
import 'package:abha/app/health_locker/view/main/health_locker_auto_approve_data_access_view.dart';
import 'package:abha/app/health_locker/view/main/health_locker_edit_subscription_view.dart';
import 'package:abha/app/health_locker/view/main/health_locker_info_view.dart';
import 'package:abha/app/health_locker/view/main/health_locker_view.dart';
import 'package:abha/app/health_locker/view/main/health_loker_info_subitem_view.dart';
import 'package:abha/app/health_record/view/main/health_record_details_view.dart';
import 'package:abha/app/health_record/view/main/health_record_search_view.dart';
import 'package:abha/app/link_unlink/view/main/link_abha_number_view.dart';
import 'package:abha/app/link_unlink/view/main/link_unlink_confirm_view.dart';
import 'package:abha/app/link_unlink/view/main/link_unlink_otp_view.dart';
import 'package:abha/app/link_unlink/view/main/unlink_abha_number_view.dart';
import 'package:abha/app/link_unlink/view/main/unlink_validator_view.dart';
import 'package:abha/app/login/view/main/login_abha_address_view.dart';
import 'package:abha/app/login/view/main/login_abha_number_view.dart';
import 'package:abha/app/login/view/main/login_confirm_view.dart';
import 'package:abha/app/login/view/main/login_email_view.dart';
import 'package:abha/app/login/view/main/login_otp_view.dart';
import 'package:abha/app/login/view/main/login_phone_number_view.dart';
import 'package:abha/app/login/view/main/login_view.dart';
import 'package:abha/app/notification/view/main/notification_view.dart';
import 'package:abha/app/profile/view/main/profile_edit_view.dart';
import 'package:abha/app/profile/view/main/profile_view.dart';
import 'package:abha/app/qr_code_scanner/qr_code_scanner_view.dart';
import 'package:abha/app/registration/view/main/registration_abha_address_view.dart';
import 'package:abha/app/registration/view/main/registration_abha_confirm_view.dart';
import 'package:abha/app/registration/view/main/registration_abha_number_view.dart';
import 'package:abha/app/registration/view/main/registration_email_view.dart';
import 'package:abha/app/registration/view/main/registration_form_view.dart';
import 'package:abha/app/registration/view/main/registration_otp_view.dart';
import 'package:abha/app/registration/view/main/registration_phone_view.dart';
import 'package:abha/app/registration/view/main/registration_view.dart';
import 'package:abha/app/settings/view/main/settings_feedback_view.dart';
import 'package:abha/app/settings/view/main/settings_reset_password_confirm_view.dart';
import 'package:abha/app/settings/view/main/settings_reset_password_view.dart';
import 'package:abha/app/settings/view/main/settings_view.dart';
import 'package:abha/app/share_profile/share_profile_view.dart';
import 'package:abha/app/splash/splash_view.dart';
import 'package:abha/app/support/view/main/support_view.dart';
import 'package:abha/app/switch_account/view/main/switch_account_view.dart';
import 'package:abha/app/token/view/token_history_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/localization/localization_view.dart';
import 'package:abha/permission/permission_consent_view.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/webview/custom_webview.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:abha/utils/route/route_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class RouteGenerator {
  static bool _isLogin = false;

  static CustomTransitionPage buildPageWithDefaultTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return (kIsWeb)
            ? FadeTransition(opacity: animation, child: child)
            : SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
      },
    );
  }

  static GoRoute customGoRoute({
    required String path,
    String? name,
    GoRouterPageBuilder? pageBuilder,
    List<RouteBase>? subRoutes,
    FutureOr<String?>? redirect,
    bool isParam = false,
    bool isQueryParam = false,
  }) {
    return GoRoute(
      name: name,
      path: path,
      pageBuilder: pageBuilder,
      routes: subRoutes ?? [],
      redirect: (context, state) {
        return isParam
            ? state.params.isEmpty
                ? redirect
                : null
            : isQueryParam
                ? state.queryParams.isEmpty
                    ? redirect
                    : null
                : state.extra == null
                    ? redirect
                    : null;
      },
    );
  }

  static List<RouteBase> _getLoginSubRoutes() {
    List<RouteBase> routeData = [
      customGoRoute(
        path: RouteName.loginAbhaAddress,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LoginAbhaAddressView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.loginMobile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LoginPhoneNumberView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.loginAbhaNumber,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LoginAbhaNumberView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.loginEmail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LoginEmailView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.loginOtp,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LoginOtpView(arguments: state.extra as Map),
          );
        },
        redirect: _preLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.loginConfirm,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LoginConfirmView(arguments: state.extra as Map),
          );
        },
        redirect: _preLoginRedirect(),
      ),
    ];
    return routeData;
  }

  static List<RouteBase> _getRegisterSubRoutes() {
    List<RouteBase> routeData = [
      customGoRoute(
        path: RouteName.registrationAbha,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const RegistrationAbhaNumberView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.registrationAbhaAddress,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: RegistrationAbhaAddressView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _preLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.registrationMobile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const RegistrationPhoneView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.registrationEmail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const RegistrationEmailView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.registrationOtp,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: RegistrationOtpView(arguments: state.extra as Map),
          );
        },
        redirect: _preLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.registrationAbhaConfirm,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: RegistrationAbhaConfirmView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _preLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.registrationForm,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: RegistrationFormView(arguments: state.extra as Map),
          );
        },
        redirect: _preLoginRedirect(),
      ),
    ];
    return routeData;
  }

  static List<RouteBase> _getConsentSubRoutes() {
    List<RouteBase> routeData = [
      customGoRoute(
        path: RouteName.consentDetails,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ConsentDetailsView(arguments: state.extra as Map),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.consentEdit,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const ConsentEditView(),
          );
        },
      ),
      customGoRoute(
        path: RouteName.consentDetailsMine,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ConsentMyDetailsView(arguments: state.extra as Map),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.consentArtefactsDetail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ConsentArtefactsDetailsView(
              arguments: state.extra as Map,
            ),
          );
        },
      ),
    ];
    return routeData;
  }

  static List<RouteBase> _getHealthLockerSubRoutes() {
    List<RouteBase> routeData = [
      customGoRoute(
        path: RouteName.healthLockerInfo,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthLockerInfoView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.healthLockerInfoSubItem,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthLockerInfoSubItemView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.healthLockerAutoAccess,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthLockerAutoApproveDataAccessView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.healthLockerAuthorizationRequest,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthLockerAuthorizationRequestView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RouteName.healthLockerEditSubscription,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthLockerEditSubscriptionView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
    ];
    return routeData;
  }

  GoRouter router = GoRouter(
    navigatorKey: navKey,
    initialLocation: RoutePath.routeDefault,
    debugLogDiagnostics: true,
    observers: [
      RouteObserverCustom(),
    ],
    routes: [
      customGoRoute(
        path: RoutePath.routeAboutUs,
        name: RouteName.aboutUs,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AboutUsView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeAppIntro,
        name: RouteName.appIntro,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AppIntroView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeAbhaCard,
        name: RouteName.abhaCard,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AbhaCardView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeAbhaNumber,
        name: RouteName.abhaNumber,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AbhaNumberView(),
          );
        },
        subRoutes: [
          customGoRoute(
            path: RouteName.abhaNumberOption,
            name: RouteName.abhaNumberOption,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AbhaNumberOptionView(),
              );
            },
          ),
          customGoRoute(
            path: RouteName.abhaNumberOtp,
            name: RouteName.abhaNumberOtp,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AbhaNumberOtpView(),
              );
            },
          ),
          customGoRoute(
            path: RouteName.abhaNumberMobile,
            name: RouteName.abhaNumberMobile,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AbhaNumberPhoneView(),
              );
            },
          ),
          customGoRoute(
            path: RouteName.abhaNumberCard,
            name: RouteName.abhaNumberCard,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AbhaNumberCardView(),
              );
            },
          ),
        ],
      ),
      customGoRoute(
        path: RoutePath.routeAbhaNumberForget,
        name: RouteName.abhaNumberForget,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AbhaNumberForgetView(),
          );
        },
        subRoutes: [
          customGoRoute(
            path: RouteName.abhaNumberForgetViaAadhaarMobile,
            name: RouteName.abhaNumberForgetViaAadhaarMobile,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: AbhaNumberForgetViaAadharPhoneView(
                  arguments: state.extra == null ? {} : state.extra as Map,
                ),
              );
            },
          ),
          customGoRoute(
            path: RouteName.abhaNumberForgetOtp,
            name: RouteName.abhaNumberForgetOtp,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: AbhaNumberForgetOtpView(
                  arguments: state.extra == null ? {} : state.extra as Map,
                ),
              );
            },
          ),
          customGoRoute(
            path: RouteName.abhaNumberForgetCardDetail,
            name: RouteName.abhaNumberForgetCardDetail,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AbhaNumberForgetCardView(),
              );
            },
          ),
        ],
      ),

      customGoRoute(
        path: RoutePath.routeContactUs,
        name: RouteName.contactUs,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const ContactUsMobileView(),
          );
        },
      ),

      /// TEST: to handle browser back when navigate from notification, make a param route and pass _navigateFrom parameter to match when back
      customGoRoute(
        path: RoutePath.routeConsent,
        name: RouteName.consent,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ConsentsView(
              arguments: state.extra == null ? {} : state.extra as Map,
            ),
          );
        },
        subRoutes: _getConsentSubRoutes(),
      ),

      customGoRoute(
        path: kIsWeb
            ? '${RoutePath.routeConsentsMine}/:${RouteParam.consentIdParamKey}'
            : RoutePath.routeConsentsMine,
        name: RouteName.consentMine,
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map arguments = kIsWeb
              ? {
                  IntentConstant.data:
                      state.params[RouteParam.consentIdParamKey]
                }
              : state.extra as Map;
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ConsentMyView(arguments: arguments),
          );
        },
        redirect: _postLoginRedirect(),
        isParam: kIsWeb ? true : false,
      ),

      customGoRoute(
        path: RoutePath.routeDashboard,
        name: RouteName.dashboard,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: DashboardView(
              arguments: state.extra == null ? {} : state.extra as Map,
            ),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeDashboardTokenHistory,
        name: RouteName.dashboardTokenHistory,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const TokenHistoryView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeHealthRecordDetail,
        name: RouteName.healthRecordDetail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthRecordDetailView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RoutePath.routeHealthRecordSearch,
        name: RouteName.healthRecordSearch,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const HealthRecordSearchView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeHealthLocker,
        name: RouteName.healthLocker,
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map arguments = state.extra == null ? {} : state.extra as Map;
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HealthLockerView(
              arguments: arguments,
            ),
          );
        },
        subRoutes: _getHealthLockerSubRoutes(),
      ),

      customGoRoute(
        path: RoutePath.routeLogin,
        name: RouteName.login,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LoginView(),
          );
        },
        subRoutes: _getLoginSubRoutes(),
      ),

      customGoRoute(
        path: RoutePath.routeLinkFacility,
        name: RouteName.linkFacility,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LinkedFacilityView(),
          );
        },
        subRoutes: [
          customGoRoute(
            path: RouteName.discoveryLinking,
            name: RouteName.discoveryLinking,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const DiscoveryLinkingView(),
              );
            },
            subRoutes: [
              customGoRoute(
                path: RouteName.discoverHip,
                name: RouteName.discoverHip,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: DiscoverHipView(
                      arguments: state.extra as ProviderModel,
                    ),
                  );
                },
                subRoutes: [
                  customGoRoute(
                    path: RouteName.linkingHip,
                    name: RouteName.linkingHip,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return buildPageWithDefaultTransition(
                        context: context,
                        state: state,
                        child: LinkHipView(
                          arguments: state.extra as Map,
                        ),
                      );
                    },
                    subRoutes: [
                      customGoRoute(
                        path: RouteName.linkingOtpHip,
                        name: RouteName.linkingOtpHip,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          return buildPageWithDefaultTransition(
                            context: context,
                            state: state,
                            child: LinkOtpView(
                              arguments: state.extra as Map,
                            ),
                          );
                        },
                        redirect: _postLoginRedirect(),
                      ),
                    ],
                    redirect: _postLoginRedirect(),
                  ),
                ],
                redirect: _postLoginRedirect(),
              ),
            ],
          ),
        ],
      ),

      customGoRoute(
        path: RoutePath.routeLinkAbhaNumber,
        name: RouteName.linkAbhaNumber,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LinkAbhaNumberView(),
          );
        },
      ),
      customGoRoute(
        path: RoutePath.routeLinkUnlinkOtpView,
        name: RouteName.linkUnlinkOtpView,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LinkUnlinkOtpView(
              arguments: state.extra as Map,
            ),
          );
        },
        redirect: _postLoginRedirect(),
      ),
      customGoRoute(
        path: RoutePath.routeLinkUnlinkConfirmView,
        name: RouteName.linkUnlinkConfirmView,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LinkUnlinkConfirmView(),
          );
        },
      ),
      customGoRoute(
        path: RoutePath.routeLocalization,
        name: RouteName.localization,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const LocalizationView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeNotification,
        name: RouteName.notification,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const NotificationView(),
          );
        },
      ),
      customGoRoute(
        path: RoutePath.routePermissionConsent,
        name: RouteName.permissionApproval,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const PermissionConsentView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeQrCodeScanner,
        name: RouteName.qrCodeScanner,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const QrCodeScannerView(),
          );
        },
      ),

      customGoRoute(
        path: RoutePath.routeRegistration,
        name: RouteName.registration,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const RegistrationView(),
          );
        },
        subRoutes: _getRegisterSubRoutes(),
      ),

      if (!kIsWeb && RoutePath.routeDashboard != RoutePath.routeDefault)
        customGoRoute(
          path: RoutePath.routeSplash,
          name: RouteName.splash,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const SplashView(),
            );
          },
        ),
      // ex. of query param
      customGoRoute(
        path: kIsWeb
            ? RoutePath.routeShareProfileWeb
            : RoutePath.routeShareProfile,
        name: kIsWeb ? RouteName.shareProfileWeb : RouteName.shareProfile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map arguments = kIsWeb
              ? {
                  IntentConstant.hipId:
                      state.queryParams[RouteQueryParam.hipIdKey] ?? '',
                  IntentConstant.counterId:
                      state.queryParams[RouteQueryParam.counterIdKey] ?? '',
                }
              : state.extra as Map;
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ShareProfileView(arguments: arguments),
          );
        },
        redirect: _postLoginRedirect(),
        isQueryParam: kIsWeb ? true : false,
      ),
      customGoRoute(
        path: RoutePath.routeAccount,
        name: RouteName.account,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const SettingsView(),
          );
        },
        subRoutes: [
          customGoRoute(
            path: RouteName.profileView,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ProfileView(),
              );
            },
          ),
          customGoRoute(
            path: RouteName.profileEdit,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ProfileEditView(),
              );
            },
          ),
          customGoRoute(
            path: RouteName.switchAccount,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SwitchAccountView(),
              );
            },
          ),
          customGoRoute(
            path: RouteName.settingsResetPassword,
            name: RouteName.settingsResetPassword,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SettingsResetPasswordView(),
              );
            },
            subRoutes: [
              customGoRoute(
                path: RouteName.settingsResetPasswordResult,
                name: RouteName.settingsResetPasswordResult,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const SettingsResetPasswordConfirmView(),
                  );
                },
              ),
            ],
          ),
          customGoRoute(
            path: RouteName.submitFeedback,
            name: RouteName.submitFeedback,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SettingsFeedBackView(),
              );
            },
          ),
        ],
      ),
      customGoRoute(
        path: RoutePath.routeUnlinkAbhaNumber,
        name: RouteName.unlinkAbhaNumber,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const UnLinkAbhaNumberView(),
          );
        },
      ),
      customGoRoute(
        path: RoutePath.routeUnlinkAbhaNumberValidator,
        name: RouteName.unlinkAbhaNumberValidator,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const UnLinkValidatorView(),
          );
        },
      ),

      // ex. of param
      customGoRoute(
        path: '${RoutePath.routeUhi}/:${RouteParam.uhiIdParamKey}',
        name: RouteName.uhi,
        pageBuilder: (BuildContext context, GoRouterState state) {
          var arguments = {
            IntentConstant.uhiId: state.params[RouteParam.uhiIdParamKey],
          };
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ShareProfileView(arguments: arguments),
          );
        },
        redirect: _preLoginRedirect(),
        isParam: true,
      ),

      customGoRoute(
        path: RoutePath.routeWebView,
        name: RouteName.webView,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: CustomWebView(arguments: state.extra as Map),
          );
        },
        redirect: _postLoginRedirect(),
      ),

      customGoRoute(
        path: RoutePath.routeSupport,
        name: RouteName.support,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const SupportView(),
          );
        },
      ),
    ],
    // this will run before page loads
    redirect: (context, state) async =>
        kIsWeb ? await _handleRedirects(context, state) : null,
    errorBuilder: (context, state) => CustomErrorView(
      status: Status.error,
      errorMessageTitle: state.error.toString(),
      onRetryPressed: () {
        String routePath =
            _isLogin ? _postLoginRedirect() : _preLoginRedirect();
        context.go(routePath);
      },
    ),
  );

  static Future<String?> _handleRedirects(
    BuildContext context,
    GoRouterState state,
  ) async {
    String subLocation = state.subloc;
    abhaLog.w(subLocation);
    _isLogin = abhaSingleton.getAppData.getLogin();

    return (!kIsWeb && subLocation == RoutePath.routeSplash) ||
            (kIsWeb && !_isLogin && subLocation == RoutePath.routeSplash) ||
            (subLocation.contains(RouteName.uhi)) ||
            (subLocation == RoutePath.routeShareProfileWeb) ||
            (!_isLogin && subLocation == RoutePath.routeAppIntro) ||
            (_isLogin && subLocation == RoutePath.routeDashboard) ||
            (_isLogin && subLocation == RoutePath.routeSupport) ||
            (_isLogin && subLocation == RoutePath.routeAbhaNumber)
        ? null
        : !_isLogin &&
                _isPreLoginControllerScreens(subLocation) &&
                !Get.isRegistered<AppIntroController>()
            ? _preLoginRedirect()
            : (!_isLogin && !_isPreLoginScreens(subLocation))
                ? _preLoginRedirect()
                : (_isLogin &&
                        (!Get.isRegistered<DashboardController>() ||
                            _isPreLoginScreens(subLocation)))
                    ? _postLoginRedirect()
                    : (_isLogin &&
                            !Get.isRegistered<ConsentController>() &&
                            subLocation.contains(RouteName.consentMine))
                        ? _postLoginRedirect()
                        : null;
  }

  static String _preLoginRedirect() {
    return RoutePath.routeAppIntro;
  }

  static String _postLoginRedirect() {
    return RoutePath.routeDashboard;
  }

  static bool _isPreLoginScreens(String subLocation) {
    if (subLocation == RoutePath.routeSplash ||
        subLocation == RoutePath.routePermissionConsent ||
        subLocation == RoutePath.routeAppIntro ||
        subLocation == RoutePath.routeSupport ||
        _isPreLoginControllerScreens(subLocation)) {
      return true;
    }
    return false;
  }

  static bool _isPreLoginControllerScreens(String subLocation) {
    if (subLocation.contains('login') ||
        subLocation.contains('registration') ||
        subLocation.contains('abhaNumber')) {
      return true;
    }
    return false;
  }
}

// customGoRoute(
//   path: RoutePath.routeConsentPin,
//   name: RouteName.consentPin,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: ConsentPinView(
//         arguments: state.extra as Map,
//       ),
//     );
//   },
//   // redirect: _postLoginRedirect()
// ),
// customGoRoute(
//   path: RoutePath.routeConsentPinCreateReset,
//   name: RouteName.consentPinCreateReset,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: ConsentPinCreateResetView(
//         arguments: state.extra as Map,
//       ),
//     );
//   },
//   // redirect: _postLoginRedirect()
// ),
// customGoRoute(
//   path: RoutePath.routeConsentConfirmPin,
//   name: RouteName.consentConfirmPin,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: ConsentPinCreateResetConfirmView(
//         arguments: state.extra as Map,
//       ),
//     );
//   },
//   // redirect: _postLoginRedirect()
// ),

// customGoRoute(
//   path: RoutePath.routeConsentPinCreateResetSuccessful,
//   name: RouteName.consentPinCreateResetSuccess,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: const ConsentPinCreateResetSuccessView(),
//     );
//   },
// ),
// customGoRoute(
//   path: RoutePath.routeConsentValidateOtp,
//   name: RouteName.consentValidateOtp,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: ConsentPinOtpView(arguments: state.extra as Map),
//     );
//   },
//   // redirect: _postLoginRedirect()
// ),

// customGoRoute(
//   path: RoutePath.routeProfileUpdateEmail,
//   name: RouteName.profileUpdateEmail,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: const ProfileEmailUpdateView(),
//     );
//   },
// ),
// customGoRoute(
//   path: RoutePath.routeProfileUpdateMobile,
//   name: RouteName.profileUpdateMobile,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: const ProfileMobileUpdateView(),
//     );
//   },
// ),

// customGoRoute(
//   path: RoutePath.routeProfileValidateOtp,
//   name: RouteName.profileValidateOtp,
//   pageBuilder: (BuildContext context, GoRouterState state) {
//     return buildPageWithDefaultTransition(
//       context: context,
//       state: state,
//       child: ProfileOtpView(arguments: state.extra as Map),
//     );
//   },
//   redirect: _postLoginRedirect(),
// ),
