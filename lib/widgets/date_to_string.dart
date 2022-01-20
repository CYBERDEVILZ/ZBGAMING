class DateToString {
  String dateToString(DateTime date) {
    return "${date.day} ${date.month == 1 ? 'January' : date.month == 2 ? 'February' : date.month == 3 ? 'March' : date.month == 4 ? 'April' : date.month == 5 ? 'May' : date.month == 6 ? 'June' : date.month == 7 ? 'July' : date.month == 8 ? 'August' : date.month == 9 ? 'September' : date.month == 10 ? 'October' : date.month == 11 ? 'November' : date.month == 12 ? 'December' : null}, ${date.year}";
  }
}
