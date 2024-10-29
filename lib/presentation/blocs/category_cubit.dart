import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState>{
  late final SpecialistRepository _specialistRepository;

  CategoryCubit(): super(CategoryInitial()) {
    _specialistRepository = locator.get<SpecialistRepository>();
  }

  getCategories() async {
    emit(GetCategoriesLoading());
    final either = await _specialistRepository.getSpecialists();
    either.fold(
      (failure) => emit(GetCategoriesFailure(failure.message)), 
      (categories) => emit(GetCategoriesSuccess(categories)));
  }
}

abstract class CategoryState extends Equatable {

  @override
  List<Object?> get props => [];
}
class CategoryInitial extends CategoryState {}
class GetCategoryLoading extends CategoryState {}
class GetCategorySuccess extends CategoryState {
  final SpecialistModel category;
  GetCategorySuccess(this.category);

  @override
  List<Object?> get props => [category];
}
class GetCategoryFailure extends CategoryState {
  final dynamic message;
  GetCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetCategoriesLoading extends CategoryState {}
class GetCategoriesSuccess extends CategoryState {
  late final List<SpecialistModel> specialists;
  GetCategoriesSuccess(this.specialists);

  @override
  List<Object?> get props => [specialists];
}
class GetCategoriesFailure extends CategoryState {
  final dynamic message;
  GetCategoriesFailure(this.message);

  @override
  List<Object?> get props => [message];
}