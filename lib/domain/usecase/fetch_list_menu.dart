import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/menu_entity.dart';
import 'package:kas_autocare_user/domain/repositories/repositories_domain.dart';

class FetchListMenu {
  final RepositoriesDomain repositoriesDomain;

  FetchListMenu(this.repositoriesDomain);

  Future<Either<String, List<MenuEntity>>> fetchListMenut() {
    return repositoriesDomain.getListMenu();
  }
}
