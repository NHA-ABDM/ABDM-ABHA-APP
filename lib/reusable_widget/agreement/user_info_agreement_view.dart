import 'package:abha/app/registration/controller/reg_form_controller.dart';
import 'package:abha/export_packages.dart';

class UserInfoAgrementWidget extends StatefulWidget {
  const UserInfoAgrementWidget({super.key});

  @override
  State<UserInfoAgrementWidget> createState() => _UserInfoAgrementWidgetState();
}

class _UserInfoAgrementWidgetState extends State<UserInfoAgrementWidget> {
late RegistrationFormController _registrationFormController;
  @override
  void initState() {
    _registrationFormController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocalizationHandler.of().userInformationAgreement,
          style: CustomTextStyle.headlineSmall(context)?.apply(
            color: AppColors.colorGreyDark4,
            heightDelta: 0.5,
          ),
          maxLines: 2,
          softWrap: true,
          textAlign: TextAlign.center,
        ).marginOnly(left: Dimen.d_30, right: Dimen.d_30).alignAtCenter(),
        SingleChildScrollView(
          child: Text(
            LocalizationHandler.of().userAgreementDetails,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorGreyDark4,
              heightDelta: 0.5,
            ),
            textAlign: TextAlign.justify,
          ),
        )
            .paddingSymmetric(
              horizontal: Dimen.d_30,
              vertical: Dimen.d_10,
            )
            .sizedBox(height: context.height * 0.6),
        textToSpeechWidget().alignAtCenterRight().paddingSymmetric(
          horizontal: Dimen.d_30,
        ),
        TextButtonOrange.mobile(
          text: LocalizationHandler.of().ok.toUpperCase(),
          onPressed: () {
            _registrationFormController.stopSpeech();
            context.navigateBack();
          },
        ).marginSymmetric(
          vertical: Dimen.d_25,
          horizontal: Dimen.d_50,
        ),
      ],
    );
  }

  Widget textToSpeechWidget() {
    return GetBuilder<RegistrationFormController>(
      builder: (_) {
        return GestureDetector(
          onTap: () async{
            if (_registrationFormController.isAudioPlaying) {
              //stop the text to speech
              _registrationFormController.stopSpeech();
            } else {
              //start the text to speech
              await _registrationFormController
                  .startSpeech(LocalizationHandler.of().userAgreementDetails);
            }
            _registrationFormController.functionHandler(
              isUpdateUi: true,
            );
          },
          child: CustomSvgImageView(
            _registrationFormController.isAudioPlaying
                ? ImageLocalAssets.soundOnIcon
                : ImageLocalAssets.soundOffIcon,
            width: Dimen.d_30,
            height: Dimen.d_30,
          ),
        );
      },
    );
  }
}
