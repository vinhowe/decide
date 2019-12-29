import 'package:built_value/built_value.dart';

part 'decision_option.g.dart';

abstract class DecisionOption implements Built<DecisionOption, DecisionOptionBuilder> {
  String get description;

  String get id;

  DecisionOption._();

  factory DecisionOption([void Function(DecisionOptionBuilder b) updates]) = _$DecisionOption;
}
