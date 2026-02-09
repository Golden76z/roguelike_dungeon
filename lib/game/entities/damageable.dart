/// Implemented by components that can receive damage (e.g. enemies in Ch6).
abstract class Damageable {
  void takeDamage(double amount);
  bool get isAlive;
}
