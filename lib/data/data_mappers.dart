import 'package:ventrata_challenge/data/dtos/login_dto.dart';
import 'package:ventrata_challenge/data/dtos/product_dto.dart';
import 'package:ventrata_challenge/data/dtos/user_dto.dart';
import 'package:ventrata_challenge/domain/login/entities/login_model.dart';
import 'package:ventrata_challenge/domain/products/entities/product_model.dart';
import 'package:ventrata_challenge/domain/user/entities/user_model.dart';

extension LoginDTOExtension on LoginDTO {
  LoginModel toModel() => LoginModel(
        id: id,
        token: token,
      );
}

extension UserDTOExtension on UserDTO {
  UserModel toModel() => UserModel(
        id: id,
        username: username ?? "",
        email: email ?? "",
        firstName: firstName ?? "",
        lastName: lastName ?? "",
        gender: gender ?? "",
        image: image,
      );
}

extension ProductDTOExtension on ProductDTO {
  ProductModel toModel() => ProductModel(
        id: id,
        title: title ?? '',
        brand: brand ?? '',
        description: description ?? '',
        price: price,
        thumbnail: thumbnail,
      );
}
