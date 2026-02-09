/// Persists and loads save data (4 slots, meta + run state).
/// Stub for Chapter 12; will implement local storage and schema.
class SaveService {
  SaveService();

  /// Whether any save exists for the given slot (1..4).
  Future<bool> hasSave(int slot) async => false;

  /// Load save for slot; throws if none. Stub returns null for now.
  Future<Map<String, dynamic>?> load(int slot) async => null;

  /// Save current state to slot (1..4). Stub no-op.
  Future<void> save(int slot, Map<String, dynamic> data) async {}
}
