class CloudEarthquakePlanException implements Exception {
  CloudEarthquakePlanException();
}

class InvalidIndexException extends CloudEarthquakePlanException {}
class EarthquakePlanNotFoundException extends CloudEarthquakePlanException {}