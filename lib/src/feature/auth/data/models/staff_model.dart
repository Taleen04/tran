class Staff {
  final int id;
  final String name;
  final String phone;
  final String employeeType;
  final String rating;
  final bool isOnline;

  Staff({
    required this.id,
    required this.name,
    required this.phone,
    required this.employeeType,
    required this.rating,
    required this.isOnline,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      employeeType: json['employee_type'],
      rating: json['rating'],
      isOnline: json['is_online'],
);
}
 
}

