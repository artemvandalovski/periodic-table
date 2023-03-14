import "dart:convert";
import 'data/PeriodicTableJSON.json.dart';
import 'models/tableau.dart';

void main() {
  print("Bonjour faire les modification pour accomplir le travail");

  // Pour faire la conversion du JSON dans une map
  final Map<String, dynamic> jsonMap = jsonDecode(jsonTablePer);

  print("Le data de base est dans jsonMap ${jsonMap.runtimeType}");

  print(jsonMap["elements"].runtimeType);
  // Par example vous pouvez voir tous les noms avec
  /*
  (jsonMap["elements"] as List<dynamic>).forEach((element) {
    print("Nom: ${element['name']}");
  });
  */

  // Creation du tableau
  final tableau = TableauPeriodique(jsonMap);
  // Affichage du nombre d'éléments
  print(tableau.length);
  // Devrait afficher Strontium
  var monElement = tableau.getElement("Sr");
  print(monElement);
  print(monElement.poids);
  // Doit produire une exception
  // Ajouter du code pour récupérer l'exception ElementInexistant et afficher un message que l'élément ne fut pas trouvé
  try {
    print(tableau.getElement("Dt"));
  } on ElementInexistant {
    print("J'ai intercepte une erreur");
  }

  // Affiche les éléments trouvé par la famille Curie
  print(tableau.getElementFromCreator("Curie"));

  var hydrogene = tableau.getElement("H");
  var oxygene = tableau.getElement("O");
  var eau2 = hydrogene + oxygene + hydrogene;
  print(eau2); // HOH
  eau2.nom = "EAU";
  print(eau2); // eau:[HOH] ou eau:[HOH]

  //
  final bigTest =
      tableau.creeMolecule(equation: "H2ONaClC6H12O6NaOH", nom: "Bigone");
  final sel = tableau.creeMolecule(equation: "NaCl", nom: "Sel");
  final eau = tableau.creeMolecule(equation: "H2O", nom: "Eau");
  final hyd_sod =
      tableau.creeMolecule(equation: "NaOH", nom: "Dryoxyde de sodium");
  final glucose = tableau.creeMolecule(equation: "C6H12O6", nom: "Glucose");

  var eau3 = hydrogene * 2 + oxygene;
  print(eau3); // H2O ou OH2

  print("""
  Le poids d'une molécule de $glucose est : ${glucose.poids} pour une formule ${glucose}.

  C'est plus que la molécule $eau ou son poids est de ${eau.poids} et le poids de l'autre eau est aussi de ${eau2.poids}
  """);
}
