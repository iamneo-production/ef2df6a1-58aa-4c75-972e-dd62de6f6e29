import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:neobank/util/create_stellar_account.dart';

class KYCForm extends StatefulWidget {
  const KYCForm({super.key});

  @override
  State<KYCForm> createState() => _KYCFormState();
}

List<String> states = [
  "Andhra Pradesh",
  "Arunachal Pradesh ",
  "Assam",
  "Bihar",
  "Chhattisgarh",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jammu and Kashmir",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Odisha",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal",
  "Andaman and Nicobar Islands",
  "Chandigarh",
  "Dadra and Nagar Haveli",
  "Daman and Diu",
  "Lakshadweep",
  "National Capital Territory of Delhi",
  "Puducherry"
];

class _KYCFormState extends State<KYCForm> {
  int cStep = 0;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _postCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = GroupController();

  String _state = states.first;

  final kycForm = GlobalKey<FormState>();
  final dateOfBirth = DateRangePickerController();
  final _nameValidator = RequiredValidator(errorText: "Field is required");
  void sendFile(
      {required path, required String uuid, required String docName}) async {
    File file = File(path);
    // Upload file
    await FirebaseStorage.instance.ref('$uuid/$docName').putFile(file);
  }

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  bool isUploadedAadhar = false;
  bool isUploadedPan = false;
  bool isUploadedSign = false;
  late String blkseed;
  void submitForm() async {
    await StellarFunctions.createStellarAccount().then((value) {
      setState(() {
        blkseed = value;
      });
    });
    KeyPair kp = KeyPair.fromSecretSeed(blkseed);
    FirebaseFirestore.instance.collection('customer').doc(uid).set({
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'phone_number': int.parse(_phoneController.text.toString()),
      'date_of_birth': dateOfBirth.selectedDate,
      'address_line_1': _address1Controller.text.trim(),
      'address_line_2': _address2Controller.text.trim(),
      'state': _state,
      'postal_code': int.parse(_postCodeController.text),
      'verfied_phone': false,
      'kyc_status': 'Pending',
      'secret_key': blkseed
    });
    FirebaseFirestore.instance.collection('account').doc(uid).set({
      'first_name': _firstNameController.text.trim(),
      'secret_key': blkseed,
      'account_id': kp.accountId,
      'balance': 1000.00,
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => KYCForm()));
  }

  List<Step> getSteps() => [
        Step(
          state: cStep > 0 ? StepState.complete : StepState.indexed,
          isActive: cStep >= 0,
          title: cStep == 0 ? Text('Basic Information') : Text(""),
          content: Column(
            children: [
              TextFormField(
                validator: _nameValidator,
                controller: _firstNameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'First Name',
                    fillColor: Colors.white,
                    filled: true),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: _nameValidator,
                controller: _lastNameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Last Name',
                    fillColor: Colors.white,
                    filled: true),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Select Date of Birth"),
              SizedBox(
                height: 5,
              ),
              SfDateRangePicker(
                minDate: DateTime(1930),
                maxDate: DateTime(DateTime.now().year - 16),
                allowViewNavigation: true,
                controller: dateOfBirth,
                selectionMode: DateRangePickerSelectionMode.single,
                confirmText: 'Confirm Date',
                showActionButtons: true,
                cancelText: 'Reset',
                onCancel: () => setState(() => dateOfBirth.selectedDate =
                    DateTime(DateTime.now().year - 16)),
              ),
              SimpleGroupedCheckbox<String>(
                controller: _genderController,
                itemsTitle: ["Male", "Female", "Other"],
                values: ['Male', "Female", "Other"],
                groupStyle: GroupStyle(
                    activeColor: Colors.deepPurpleAccent,
                    itemTitleStyle: TextStyle(fontSize: 13)),
                checkFirstElement: false,
              )
            ],
          ),
        ),
        Step(
            state: cStep > 1 ? StepState.complete : StepState.indexed,
            isActive: cStep >= 1,
            title: cStep == 1 ? Text('Address') : Text(""),
            content: Column(
              children: [
                TextFormField(
                  validator: _nameValidator,
                  controller: _address1Controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Address Line 1',
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: _nameValidator,
                  controller: _address2Controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Address Line 2',
                      fillColor: Colors.white,
                      filled: true),
                ),
                SizedBox(
                  height: 5,
                ),
                DropdownButton(
                    value: _state,
                    items: states.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: ((value) => setState(() {
                          _state = value!;
                        }))),
                TextFormField(
                  controller: _postCodeController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Postal Code',
                      fillColor: Colors.white,
                      filled: true),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Phone number',
                      fillColor: Colors.white,
                      filled: true),
                ),
              ],
            )),
        Step(
            title: cStep == 2 ? Text('Supporting Documents') : Text(""),
            content: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text("Upload Aadhar"),
                  onPressed: isUploadedAadhar
                      ? null
                      : () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: false,
                              allowedExtensions: ['pdf'],
                            );
                            if (result!.count == 0 || result == null)
                              throw new Exception("No file chosen");
                            sendFile(
                                path: result.files.single.path,
                                docName: 'Aadhar',
                                uuid: uid!);
                            setState(() {
                              isUploadedAadhar = true;
                            });
                          } catch (e) {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'An Error Occurred',
                                message: 'Please try Again',
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text("Upload Pan"),
                  onPressed: isUploadedPan
                      ? null
                      : () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: false,
                              allowedExtensions: ['pdf'],
                            );
                            if (result!.count == 0 || result == null)
                              throw new Exception("No file chosen");
                            sendFile(
                                path: result.files.single.path,
                                docName: 'PAN',
                                uuid: uid!);
                            setState(() {
                              isUploadedPan = true;
                            });
                          } catch (e) {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'An Error Occurred',
                                message: 'Please try Again',
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text("Upload Signature"),
                  onPressed: isUploadedSign
                      ? null
                      : () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: false,
                              allowedExtensions: ['pdf'],
                            );
                            if (result!.count == 0 || result == null)
                              throw new Exception("No file chosen");
                            sendFile(
                                path: result.files.single.path,
                                docName: 'Sign',
                                uuid: uid!);
                            setState(() {
                              isUploadedSign = true;
                            });
                          } catch (e) {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'An Error Occurred',
                                message: 'Please try Again',
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                )
              ],
            ))
      ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Know your Customer"),
        ),
        body: SizedBox.expand(
          child: Form(
            key: kycForm,
            child: Stepper(
              physics: BouncingScrollPhysics(),
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: cStep,
              onStepTapped: (step) => setState(() {
                cStep = step;
              }),
              onStepContinue: () {
                final isLastStep = cStep == getSteps().length - 1;
                if (isLastStep) {
                  if (!kycForm.currentState!.validate()) {
                    var snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Check all fields',
                        message: 'Please try Again',
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  submitForm();
                } else {
                  setState(() {
                    cStep += 1;
                  });
                }
              },
              onStepCancel: cStep == 0
                  ? null
                  : () => setState(() {
                        cStep -= 1;
                      }),
              controlsBuilder: (context, details) {
                final isLastStep = cStep == getSteps().length - 1;
                return Column(
                  children: [
                    if (cStep != 0)
                      ElevatedButton(
                          onPressed: details.onStepCancel, child: Text("Back")),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(isLastStep ? "Confirm" : "Next"))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
