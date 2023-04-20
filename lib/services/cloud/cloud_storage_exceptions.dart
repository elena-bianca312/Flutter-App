class CloudStorageException implements Exception {
  CloudStorageException();
}

// C in CRUD
class CouldNotCreateNoteException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateNoteException extends CloudStorageException {}

// D` in CRUD
class CouldNotDeleteNoteException extends CloudStorageException {}
