class Sections {
  static Map<String, int> _sections = {
    "Friends": 2,
    "Family": 3,
  };

  static List<String> get sections => _sections.keys.toList();

  static addSection(String section){
    _sections[section] = _sections.length + 2;
  }

  static getIndex(String section) => _sections[section];

}
