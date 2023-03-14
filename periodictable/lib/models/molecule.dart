import 'element.dart';

class OperationImpossible implements Exception {}

class Molecule {
  late final List<MonElement> _elements;
  String _name = '';

  Molecule(List<MonElement> elements) : this._elements = elements;

  void set nom(String name) {
    _name = name;
  }

  List<MonElement> get elements {
    return [..._elements];
  }

  num get poids {
    return _elements.fold(
        0, (previousValue, element) => element.poids + previousValue);
  }

  Molecule operator +(Object comp) {
    if (comp is Molecule) {
      return Molecule([...this._elements, ...(comp).elements]);
    } else if (comp is MonElement) {
      return Molecule([...this._elements, comp]);
    } else {
      throw OperationImpossible();
    }
  }

  String equation() {
    String _equation = '';
    final _elementCopy = [..._elements];
    _elementCopy.sort();
    String _lastElementSymbol = '';
    num _multiplier = 1;

    for (final item in _elementCopy) {
      if (item.symbol != _lastElementSymbol) {
        // On a une nouvelle sequence
        if (_lastElementSymbol != '') {
          // On avait un symbol en traitement
          _equation += _lastElementSymbol;
          if (_multiplier > 1) {
            _equation += _multiplier.toString();
          }
        }
        // Remet a 0 le multiplicateur
        _multiplier = 1;
      } else {
        _multiplier += 1;
      }

      _lastElementSymbol = item.symbol;
    }
    _equation += _lastElementSymbol;
    if (_multiplier > 1) {
      _equation += _multiplier.toString();
    }

    return _equation;
  }

  // return _elements.map((e) => e.symbol).join('+');

  @override
  String toString() {
    if (_name != '') {
      return "$_name:[${equation()}]";
    } else {
      return equation();
    }
  }
}
