import 'molecule.dart';

class MonElement implements Comparable<MonElement> {
  // Attributs d'un element
  late final String name;
  late final String summary;
  late final String category;
  late final String phase;
  late final int number;
  late final num atomicMass;
  late final String discoveredBy;
  late final num melt;
  late final num boil;
  late final String symbol;
  late final List<num> shells;
  late final String cpkHex;
  late final int xpos, ypos;

  MonElement(Map<String, dynamic> elementJson) {
    // Recoit l'element a creer
    name = elementJson['name'];
    summary = elementJson['summary'];
    category = elementJson['category'];
    phase = elementJson['phase'];
    number = elementJson['number'];
    atomicMass = elementJson['atomic_mass'] ?? 0;
    discoveredBy = elementJson['discovered_by'] ?? '';
    melt = elementJson['melt'] ?? 0;
    boil = elementJson['boil'] ?? 0;
    symbol = elementJson['symbol'];
    shells = (elementJson['shells'] as List<dynamic>).cast();
    cpkHex = elementJson['cpk-hex'] ?? '';
    xpos = elementJson['xpos'] ?? 0;
    ypos = elementJson['ypos'] ?? 0;
    //print("Created Element $name with $shells shells");
  }

  @override
  int compareTo(MonElement autre) {
    return this.symbol.compareTo(autre.symbol);
  }

  @override
  String toString() {
    return name;
  }

  num get poids {
    return atomicMass;
  }

  Molecule operator +(MonElement element) => Molecule([this, element]);

  Molecule operator *(int multiplicateur) =>
      Molecule(List.generate(multiplicateur, (_) => this).toList());
  // List.generate(multiplicateur, (_) => this).toList());
}
