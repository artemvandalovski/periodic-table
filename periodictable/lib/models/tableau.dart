import 'element.dart';
import 'molecule.dart';

class ElementInexistant implements Exception {}

class MultipleElementMatch implements Exception {}

class TableauPeriodique {
  // List d'elements
  late final List<MonElement> _tableauPeriodique;

  TableauPeriodique(Map<String, dynamic> tableauEnJson) {
    // Cree la liste
    //print("Debut de mon tableau");

    _tableauPeriodique = (tableauEnJson["elements"] as List<dynamic>)
        .map((e) => MonElement(e))
        .toList();
  }

  int get length {
    return _tableauPeriodique.length;
  }

  List<MonElement> getElements() {
    return _tableauPeriodique;
  }

  MonElement getElement(String symbol) {
    final _element = _tableauPeriodique
        .where((element) => element.symbol == symbol)
        .toList();

    if (_element.length == 0) {
      throw ElementInexistant();
    }

    if (_element.length > 1) {
      throw MultipleElementMatch();
    }

    // Ici on devrait avec notre element.
    return _element[0];
  }

  List<MonElement> getElementFromCreator(String name) {
    return _tableauPeriodique
        .where((element) => element.discoveredBy.contains(name))
        .toList();
  }

  List<String> _splitEquation(String equation) {
    // Retourne un tableau separant chaque items de l'equation
    final List<String> _parseEquation = [];

    for (final char in equation.split('')) {
      // Si nombre on ajoute sauf si le dernier element de la liste est un nombre
      if (int.tryParse(char) != null) {
        if (int.tryParse(_parseEquation[_parseEquation.length - 1]) != null) {
          // Le dernier element est un chiffre
          _parseEquation[_parseEquation.length - 1] += char;
        } else {
          _parseEquation.add(char);
        }
      } else if (char.toUpperCase() == char) {
        // Si Majuscule on ajoute
        _parseEquation.add(char);
        continue;
      } else {
        // Si minuscule on ajoute au dernier element de la list
        _parseEquation[_parseEquation.length - 1] += char;
      }
    }

    return _parseEquation;
  }

  Molecule creeMolecule({required String equation, required String nom}) {
    var parsedEquation = _splitEquation(equation);

    final List<MonElement> _elements = [];

    for (final item in parsedEquation) {
      var parsedAsNum = int.tryParse(item);
      if (parsedAsNum != null) {
        // On a un chiffre a copier
        final _elementACopier =
            getElement(_elements[_elements.length - 1].symbol);
        _elements.addAll(
            List.generate(parsedAsNum - 1, (_) => _elementACopier).toList());
      } else {
        _elements.add(getElement(item));
      }
    }

    return Molecule(_elements);
  }
}
