class Sorting {
  String? sortName;
  String? sortKey;

  Sorting({this.sortName, this.sortKey});

  static List<Sorting> sortingData = [
    Sorting(sortKey: 'new', sortName: 'New'),
    Sorting(sortKey: 'old', sortName: 'Old'),
    Sorting(sortKey: 'alpha_asc', sortName: 'Name (A-Z)'),
    Sorting(sortKey: 'alpha_desc', sortName: 'Name (Z-A)'),
    Sorting(sortKey: 'low_to_high', sortName: 'Price (Low to High)'),
    Sorting(sortKey: 'high_to_low', sortName: 'Price (High to Low)'),
  ];
}
