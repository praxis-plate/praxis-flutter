import 'package:equatable/equatable.dart';

class UpdateBookmarkModel extends Equatable {
  final int id;
  final int? pageNumber;
  final String? note;

  const UpdateBookmarkModel({required this.id, this.pageNumber, this.note});

  @override
  List<Object?> get props => [id, pageNumber, note];

  @override
  bool get stringify => true;
}
