abstract class URLS{
  static final String baseUrl = "https://forestrack-core.herokuapp.com/api";

  static final String userLoginUrl = baseUrl + "/auth/login";
  static final String userLoginCheckUrl = baseUrl + "/volunteer/get/";


  static final String getAllProjectsUrl = baseUrl + "/opportunity/approved";
  static final String getProjectUrl = baseUrl + "/opportunity/getOpportunity/";
  static final String applyProjectUrl = baseUrl + "/volunteer/opportunity/apply";
  static final String cancelProjectUrl = baseUrl + "/volunteer/opportunity/cancel";
  static final String makeFavProjectUrl = baseUrl + "/volunteer/opportunity/makeFavourite";
  static final String getAllFavProjectsUrl = baseUrl + "/volunteer/opportunity/favourites/";
  static final String getAllAppliedProjectsUrl = baseUrl + "/volunteer/opportunity/applied/";


  static final String getAllSendReportsUrl = baseUrl + '/reports/get/';
  static final String getSendReportUrl = baseUrl + "/reports/get/";
  static final String createReportUrl = baseUrl + "/reports/create";
}