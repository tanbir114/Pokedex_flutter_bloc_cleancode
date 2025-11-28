import 'move_detail_model.dart';
import 'move_version_detail_model.dart';

class PokemonLearnedMove {
  final String moveName;
  final String moveUrl;
  final List<MoveVersionDetail> versionDetails;
  final MoveDetailModel? detail;

  PokemonLearnedMove({
    required this.moveName,
    required this.moveUrl,
    required this.versionDetails,
    this.detail,
  });

  String get formattedMoveName {
    if (moveName.isEmpty) return 'N/A';
    String formatted = moveName.replaceAll('-', ' ');
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}