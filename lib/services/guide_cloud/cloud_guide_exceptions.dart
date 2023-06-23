class CloudGuideException implements Exception {
  CloudGuideException();
}

class InvalidIndexException extends CloudGuideException {}
class GuideNotFoundException extends CloudGuideException {}