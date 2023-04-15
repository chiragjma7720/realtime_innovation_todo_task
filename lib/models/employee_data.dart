class EmployeeData {
  late String name, role, fromDate, toDate;
  int? id;

  EmployeeData({
    required this.name,
    required this.role,
    required this.fromDate,
    required this.toDate,
  });

  EmployeeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['role'] = role;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    return data;
  }

  @override
  String toString() {
    return 'EmployeeData{name: $name, role: $role, fromDate: $fromDate, toDate: $toDate, id: $id}';
  }
}
