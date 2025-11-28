import 'package:flutter/material.dart';
import '../../../data/models/move_version_detail_model.dart';
import '../../../data/models/pokemon_learned_move_model.dart';
import '../type_badge.dart';

class MovesTable extends StatefulWidget {
  final List<PokemonLearnedMove> moves;
  final List<String> availableVersionGroups;
  final Color color;

  const MovesTable({
    Key? key,
    required this.moves,
    required this.availableVersionGroups,
    required this.color,
  }) : super(key: key);

  @override
  State<MovesTable> createState() => _MovesTableState();
}

class _MovesTableState extends State<MovesTable> {
  String? _selectedVersionGroup;
  String _currentMethod = 'level-up'; // Default method

  static const Map<String, String> _versionAbbreviations = {
    'red-blue': 'RB',
    'yellow': 'Y',
    'gold-silver': 'GS',
    'crystal': 'Cry',
    'ruby-sapphire': 'RS',
    'emerald': 'EM',
    'firered-leafgreen': 'FRLG',
    'diamond-pearl': 'DP',
    'platinum': 'PT',
    'heartgold-soulsilver': 'HGSS',
    'black-white': 'BW',
    'black-2-white-2': 'B2W2',
    'x-y': 'XY',
    'omega-ruby-alpha-sapphire': 'ORAS',
    'sun-moon': 'SM',
    'ultra-sun-ultra-moon': 'USUM',
    'lets-go-pikachu-lets-go-eevee': 'LGPE',
    'sword-shield': 'SWSH',
    'brilliant-diamond-and-shining-pearl': 'BDSP',
    'legends-arceus': 'LA',
    'scarlet-violet': 'SV',
  };

  @override
  void initState() {
    super.initState();
    if (widget.availableVersionGroups.isNotEmpty) {
      _selectedVersionGroup =
          widget.availableVersionGroups.contains('scarlet-violet')
          ? 'scarlet-violet'
          : widget.availableVersionGroups.last;
    }
  }

  String getAbbreviation(String versionKey) {
    return _versionAbbreviations[versionKey] ?? versionKey.toUpperCase();
  }

  String getFullName(String versionKey) {
    return versionKey
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String formatMethod(String method) {
    if (method == 'level-up') return 'Level Up';
    if (method == 'tutor' || method == 'move-tutor') return 'Tutor';
    return method
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String formatPower(int? power) {
    return power == null ? '-' : power.toString();
  }

  List<PokemonLearnedMove> get _filteredMoves {
    if (_selectedVersionGroup == null) return [];

    final List<PokemonLearnedMove> results = [];
    final Set<String> availableMethods = {};

    for (var move in widget.moves) {
      MoveVersionDetail? detail;
      try {
        detail = move.versionDetails.firstWhere(
          (d) => (d).versionGroup == _selectedVersionGroup,
        );
      } catch (_) {
        detail = null;
      }

      if (detail != null) {
        availableMethods.add(detail.learningMethod);

        if (detail.learningMethod == _currentMethod) {
          results.add(move);
        }
      }
    }

    if (!availableMethods.contains(_currentMethod) &&
        availableMethods.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentMethod = availableMethods.contains('level-up')
              ? 'level-up'
              : availableMethods.first;
        });
      });
      return [];
    }

    if (_currentMethod == 'level-up') {
      results.sort((a, b) {
        final detailA = a.versionDetails.firstWhere(
          (d) =>
              (d).versionGroup == _selectedVersionGroup!,
        );
        final detailB = b.versionDetails.firstWhere(
          (d) =>
              (d).versionGroup == _selectedVersionGroup!,
        );
        return detailA.levelLearned.compareTo(detailB.levelLearned);
      });
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final currentMoves = _filteredMoves;

    final availableMethodsInVersion = widget.moves
        .expand((move) => move.versionDetails)
        .where(
          (detail) =>
              (detail).versionGroup ==
              _selectedVersionGroup,
        )
        .map((detail) => (detail).learningMethod)
        .toSet()
        .toList();

    const List<String> customOrder = [
      'level-up',
      'tutor',
      'egg',
      'machine',
      'move-tutor',
    ];
    availableMethodsInVersion.sort((a, b) {
      int indexA = customOrder.indexOf(a);
      int indexB = customOrder.indexOf(b);

      if (indexA == -1 && indexB == -1) {
        return a.compareTo(b);
      } else if (indexA == -1) {
        return 1;
      } else if (indexB == -1) {
        return -1;
      } else {
        return indexA.compareTo(indexB);
      }
    });

    if (_selectedVersionGroup == null) {
      return const Center(
        child: Text("No move data available for any version."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SMALLER DROPDOWN CONTAINER
              // DROPDOWN CONTAINER - Fixed width to prevent overflow but wider selection
              Container(
                constraints: BoxConstraints(
                  minWidth: 100, // Minimum width to prevent overflow
                  maxWidth: 120, // Maximum width to not take too much space
                ),
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVersionGroup,
                    isDense: true,
                    iconSize: 20,
                    hint: Text(
                      'Game',
                      style: TextStyle(color: widget.color, fontSize: 12),
                    ),
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: widget.color),
                    selectedItemBuilder: (context) {
                      return widget.availableVersionGroups.map((version) {
                        return Container(
                          width: 80, // Fixed width for selected item
                          child: Text(
                            getAbbreviation(version),
                            style: TextStyle(
                              color: widget.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList();
                    },
                    items: widget.availableVersionGroups.map((version) {
                      return DropdownMenuItem(
                        value: version,
                        child: Container(
                          width: 450, // WIDER selection menu items
                          child: Text(
                            '${getFullName(version)} (${getAbbreviation(version)})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedVersionGroup = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Learning Method Chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: availableMethodsInVersion.map((method) {
                      bool isSelected = method == _currentMethod;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(formatMethod(method)),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: widget.color.withOpacity(0.15),
                          backgroundColor: isSelected
                              ? Colors.transparent
                              : Colors.white,
                          side: isSelected
                              ? BorderSide.none
                              : BorderSide(
                                  color: widget.color.withOpacity(0.7),
                                  width: 1,
                                ),
                          labelStyle: TextStyle(
                            color: isSelected ? widget.color : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _currentMethod = method;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Moves Table Display
        Expanded(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10,
                    horizontalMargin: 0,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 40,
                    columns: [
                      if (_currentMethod == 'level-up')
                        DataColumn(
                          label: Text(
                            'Level',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      DataColumn(
                        label: Text(
                          'Move Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Power',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Damage Class',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    rows: currentMoves.map((move) {
                      final detail = move.versionDetails.firstWhere(
                        (d) =>
                            (d).versionGroup ==
                                _selectedVersionGroup &&
                            d.learningMethod == _currentMethod,
                      );

                      return DataRow(
                        cells: [
                          if (_currentMethod == 'level-up')
                            DataCell(
                              Text(
                                detail.levelLearned.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          DataCell(
                            Text(
                              move.formattedMoveName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                formatPower(move.detail?.power),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            move.detail != null
                                ? TypeBadge(type: move.detail!.moveType)
                                : const Text('-'),
                          ),
                          DataCell(
                            move.detail != null
                                ? Text(
                                    move.detail!.formattedDamageClass,
                                    style: TextStyle(
                                      color: widget.color.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  )
                                : const Text('-'),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
