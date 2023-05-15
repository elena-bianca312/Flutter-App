class CloudShelterException implements Exception {
  CloudShelterException();
}

// C in CRUD
class CouldNotCreateShelterException extends CloudShelterException {}

// R in CRUD
class CouldNotGetAllSheltersException extends CloudShelterException {}

// U in CRUD
class CouldNotUpdateShelterException extends CloudShelterException {}

// D` in CRUD
class CouldNotDeleteShelterException extends CloudShelterException {}

class CouldNotGetCurrentShelterException extends CloudShelterException {}

class CouldNotLikeShelterException extends CloudShelterException {}

class CouldNotDislikeShelterException extends CloudShelterException {}

class CouldNotGetShelterLikesException extends CloudShelterException {}

class  CouldNotCheckIfLikedException extends CloudShelterException {}

class  CouldNotCheckIfDislikedException extends CloudShelterException {}

class CouldNotAddReviewException extends CloudShelterException {}

class CouldNotGetReviewsException extends CloudShelterException {}

class CouldNotDeleteReviewException extends CloudShelterException {}

class CouldNotUpdateReviewException extends CloudShelterException {}

class CouldNotAddFreeBedException extends CloudShelterException {}