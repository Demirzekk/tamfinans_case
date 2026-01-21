enum StateManagementType {
  getx("getx"),
  mobx("mobx"),
  bloc("bloc");

  final String name;
  const StateManagementType(this.name);
}

extension StateManagementTypeExtensionX on StateManagementType {
  String get displayName => name;
}
