String removeSiParameter(String url) {
  // Convert the URL to lowercase for case-insensitive comparison
  String lowerCaseUrl = url.toLowerCase();
  
  // Find the index of "?si=" or "&si="
  int siIndex = lowerCaseUrl.indexOf('?si=');
  if (siIndex == -1) {
    siIndex = lowerCaseUrl.indexOf('&si=');
  }

  // If "si=" is found, remove it and everything after it
  if (siIndex != -1) {
    return url.substring(0, siIndex);
  }
  
  // If "si=" is not found, return the original URL
  return url;
}
