class Category {
  static const ALL = "ALL";
  static const FICTION = "F";
  static const ARTS = "A";
  static const NEWS = "N";
  static const BUSINESS = "B";
  static const SPORTS = "S";
  static const SCIENCE = "M";
  static const TECHNOLOGY = "T";
  static const all = ["ALL", "F", "A", "N", "B", "S", "M", "T"];

  static String getCategoryName(String categoryCode) {
    switch(categoryCode) {
      case "ALL": return "All";
      case "F": return "Fiction";
      case "A": return "Arts/Culture";
      case "N": return "News";
      case "B": return "Business";
      case "S": return "Sports";
      case "M": return "Science/Med";
      case "T": return "Technology";
      case "ADDED": return "Added";
    }
  }

}