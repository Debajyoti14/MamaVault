class AppUrl {
  static var baseUrl =
      "https://6uhblhr9j5.execute-api.eu-north-1.amazonaws.com/dev";

  static var getTimeline = "$baseUrl/get-timeline";
  static var getSharableLink = "$baseUrl/get-shareable-link";
  static var deleteDocsLink = "$baseUrl/delete-docs";
  static var deleteSharableLink = "$baseUrl/delete-shared-doc";
  static var addEmergencyMobileNo = "$baseUrl/add-emergency-mobile-number";
  static var deleteEmergencyMobileNo = "$baseUrl/update-verification-status";
  static var sendPanicRequest = "$baseUrl/panic";
}
