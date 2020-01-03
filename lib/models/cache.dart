import 'package:hive/hive.dart';

part 'cache.g.dart';

@HiveType()
class Cache extends HiveObject {
  @HiveField(0)
  bool deleted;
  @HiveField(1)
  bool updated;

  Cache({this.deleted, this.updated});
}
