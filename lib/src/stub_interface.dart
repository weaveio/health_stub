part of health;

/// An abstract class for health values.
abstract class HealthValue {
  Map<String, dynamic> toJson();
}

class HealthFactoryStub {
  HealthFactory({bool useHealthConnectIfAvailable = false}) {}
  Future<bool> requestAuthorization(
      List<HealthDataType> types, {
        List<HealthDataAccess>? permissions,
      }) async {
    return false;
  }

  Future<List<HealthDataPoint>> getHealthDataFromTypes(
      DateTime startTime, DateTime endTime, List<HealthDataType> types) async {
    return [];
  }
}

/// A [HealthValue] object for workouts
///
/// Parameters:
/// * [workoutActivityType] - the type of workout
/// * [totalEnergyBurned] - the total energy burned during the workout
/// * [totalEnergyBurnedUnit] - the unit of the total energy burned
/// * [totalDistance] - the total distance of the workout
/// * [totalDistanceUnit] - the unit of the total distance
class WorkoutHealthValue extends HealthValue {
  HealthWorkoutActivityType _workoutActivityType;
  int? _totalEnergyBurned;
  HealthDataUnit? _totalEnergyBurnedUnit;
  int? _totalDistance;
  HealthDataUnit? _totalDistanceUnit;

  WorkoutHealthValue(
      this._workoutActivityType,
      this._totalEnergyBurned,
      this._totalEnergyBurnedUnit,
      this._totalDistance,
      this._totalDistanceUnit);

  /// The type of the workout.
  HealthWorkoutActivityType get workoutActivityType => _workoutActivityType;

  /// The total energy burned during the workout.
  /// Might not be available for all workouts.
  int? get totalEnergyBurned => _totalEnergyBurned;

  /// The unit of the total energy burned during the workout.
  /// Might not be available for all workouts.
  HealthDataUnit? get totalEnergyBurnedUnit => _totalEnergyBurnedUnit;

  /// The total distance covered during the workout.
  /// Might not be available for all workouts.
  int? get totalDistance => _totalDistance;

  /// The unit of the total distance covered during the workout.
  /// Might not be available for all workouts.
  HealthDataUnit? get totalDistanceUnit => _totalDistanceUnit;

  factory WorkoutHealthValue.fromJson(json) {
    return WorkoutHealthValue(
        HealthWorkoutActivityType.values.firstWhere(
              (element) => element.name == json['workoutActivityType'],
          orElse: () => HealthWorkoutActivityType.OTHER,
        ),
        json['totalEnergyBurned'] != null
            ? (json['totalEnergyBurned'] as num).toInt()
            : null,
        json['totalEnergyBurnedUnit'] != null
            ? HealthDataUnit.values.firstWhere(
                (element) => element.name == json['totalEnergyBurnedUnit'])
            : null,
        json['totalDistance'] != null
            ? (json['totalDistance'] as num).toInt()
            : null,
        json['totalDistanceUnit'] != null
            ? HealthDataUnit.values.firstWhere(
                (element) => element.name == json['totalDistanceUnit'])
            : null);
  }

  @override
  Map<String, dynamic> toJson() => {
    'workoutActivityType': _workoutActivityType.name,
    'totalEnergyBurned': _totalEnergyBurned,
    'totalEnergyBurnedUnit': _totalEnergyBurnedUnit?.name,
    'totalDistance': _totalDistance,
    'totalDistanceUnit': _totalDistanceUnit?.name,
  };

  @override
  String toString() {
    return "";
  }

  @override
  bool operator ==(Object o) {
    return o is WorkoutHealthValue &&
        this.workoutActivityType == o.workoutActivityType &&
        this.totalEnergyBurned == o.totalEnergyBurned &&
        this.totalEnergyBurnedUnit == o.totalEnergyBurnedUnit &&
        this.totalDistance == o.totalDistance &&
        this.totalDistanceUnit == o.totalDistanceUnit;
  }

  @override
  int get hashCode => Object.hash(workoutActivityType, totalEnergyBurned,
      totalEnergyBurnedUnit, totalDistance, totalDistanceUnit);
}

/// A [HealthValue] object for audiograms
///
/// Parameters:
/// * [frequencies] - array of frequencies of the test
/// * [leftEarSensitivities] threshold in decibel for the left ear
/// * [rightEarSensitivities] threshold in decibel for the left ear
class AudiogramHealthValue extends HealthValue {
  List<num> _frequencies;
  List<num> _leftEarSensitivities;
  List<num> _rightEarSensitivities;

  AudiogramHealthValue(this._frequencies, this._leftEarSensitivities,
      this._rightEarSensitivities);

  /// Array of frequencies of the test.
  List<num> get frequencies => _frequencies;

  /// Threshold in decibel for the left ear.
  List<num> get leftEarSensitivities => _leftEarSensitivities;

  /// Threshold in decibel for the right ear.
  List<num> get rightEarSensitivities => _rightEarSensitivities;

  @override
  String toString() {
    return """frequencies: ${frequencies.toString()},
    left ear sensitivities: ${leftEarSensitivities.toString()},
    right ear sensitivities: ${rightEarSensitivities.toString()}""";
  }

  factory AudiogramHealthValue.fromJson(json) {
    return AudiogramHealthValue(
        List<num>.from(json['frequencies']),
        List<num>.from(json['leftEarSensitivities']),
        List<num>.from(json['rightEarSensitivities']));
  }

  Map<String, dynamic> toJson() => {
    'frequencies': frequencies.toString(),
    'leftEarSensitivities': leftEarSensitivities.toString(),
    'rightEarSensitivities': rightEarSensitivities.toString(),
  };

  @override
  bool operator ==(Object o) {
    return false;
  }

  @override
  int get hashCode =>
      Object.hash(frequencies, leftEarSensitivities, rightEarSensitivities);
}


class NumericHealthValue extends HealthValue {
  num _numericValue;

  NumericHealthValue(this._numericValue);

  /// A [num] value for the [HealthDataPoint].
  num get numericValue => _numericValue;

  @override
  String toString() {
    return numericValue.toString();
  }

  /// Parses a json object to [NumericHealthValue]
  factory NumericHealthValue.fromJson(json) {
    return NumericHealthValue(num.parse(json['numericValue']));
  }

  Map<String, dynamic> toJson() => {
    'numericValue': numericValue.toString(),
  };

  @override
  bool operator ==(Object o) {
    return o is NumericHealthValue && this._numericValue == o.numericValue;
  }

  @override
  int get hashCode => numericValue.hashCode;
}

/// A list of supported platforms.
enum PlatformType { IOS, ANDROID }

enum HealthDataType {
  ACTIVE_ENERGY_BURNED,
  AUDIOGRAM,
  BASAL_ENERGY_BURNED,
  BLOOD_GLUCOSE,
  BLOOD_OXYGEN,
  BLOOD_PRESSURE_DIASTOLIC,
  BLOOD_PRESSURE_SYSTOLIC,
  BODY_FAT_PERCENTAGE,
  BODY_MASS_INDEX,
  BODY_TEMPERATURE,
  DIETARY_CARBS_CONSUMED,
  DIETARY_ENERGY_CONSUMED,
  DIETARY_FATS_CONSUMED,
  DIETARY_PROTEIN_CONSUMED,
  FORCED_EXPIRATORY_VOLUME,
  HEART_RATE,
  HEART_RATE_VARIABILITY_SDNN,
  HEIGHT,
  RESTING_HEART_RATE,
  RESPIRATORY_RATE,
  PERIPHERAL_PERFUSION_INDEX,
  STEPS,
  WAIST_CIRCUMFERENCE,
  WALKING_HEART_RATE,
  WEIGHT,
  DISTANCE_WALKING_RUNNING,
  FLIGHTS_CLIMBED,
  MOVE_MINUTES,
  DISTANCE_DELTA,
  MINDFULNESS,
  WATER,
  SLEEP_IN_BED,
  SLEEP_ASLEEP,
  SLEEP_AWAKE,
  SLEEP_LIGHT,
  SLEEP_DEEP,
  SLEEP_REM,
  SLEEP_OUT_OF_BED,
  SLEEP_SESSION,
  SLEEP_CORE,
  SLEEP_UNSPECIFIED,
  EXERCISE_TIME,
  WORKOUT,
  HEADACHE_NOT_PRESENT,
  HEADACHE_MILD,
  HEADACHE_MODERATE,
  HEADACHE_SEVERE,
  HEADACHE_UNSPECIFIED,
  VO2MAX,

  // Heart Rate events (specific to Apple Watch)
  HIGH_HEART_RATE_EVENT,
  LOW_HEART_RATE_EVENT,
  IRREGULAR_HEART_RATE_EVENT,
  ELECTRODERMAL_ACTIVITY,
  ELECTROCARDIOGRAM,
}

/// Access types for Health Data.
enum HealthDataAccess {
  READ,
  WRITE,
  READ_WRITE,
}

/// List of data types available on iOS
const List<HealthDataType> _dataTypeKeysIOS = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.AUDIOGRAM,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.DIETARY_CARBS_CONSUMED,
  HealthDataType.DIETARY_ENERGY_CONSUMED,
  HealthDataType.DIETARY_FATS_CONSUMED,
  HealthDataType.DIETARY_PROTEIN_CONSUMED,
  HealthDataType.ELECTRODERMAL_ACTIVITY,
  HealthDataType.FORCED_EXPIRATORY_VOLUME,
  HealthDataType.HEART_RATE,
  HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  HealthDataType.HEIGHT,
  HealthDataType.HIGH_HEART_RATE_EVENT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  HealthDataType.LOW_HEART_RATE_EVENT,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.RESPIRATORY_RATE,
  HealthDataType.PERIPHERAL_PERFUSION_INDEX,
  HealthDataType.STEPS,
  HealthDataType.WAIST_CIRCUMFERENCE,
  HealthDataType.WALKING_HEART_RATE,
  HealthDataType.WEIGHT,
  HealthDataType.FLIGHTS_CLIMBED,
  HealthDataType.DISTANCE_WALKING_RUNNING,
  HealthDataType.MINDFULNESS,
  HealthDataType.SLEEP_IN_BED,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_DEEP,
  HealthDataType.SLEEP_CORE,
  HealthDataType.SLEEP_UNSPECIFIED,
  HealthDataType.SLEEP_REM,
  HealthDataType.WATER,
  HealthDataType.EXERCISE_TIME,
  HealthDataType.WORKOUT,
  HealthDataType.HEADACHE_NOT_PRESENT,
  HealthDataType.HEADACHE_MILD,
  HealthDataType.HEADACHE_MODERATE,
  HealthDataType.HEADACHE_SEVERE,
  HealthDataType.HEADACHE_UNSPECIFIED,
  HealthDataType.ELECTROCARDIOGRAM,
  HealthDataType.VO2MAX,
];

/// List of data types available on Android
const List<HealthDataType> _dataTypeKeysAndroid = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.HEART_RATE,
  HealthDataType.HEIGHT,
  HealthDataType.STEPS,
  HealthDataType.WEIGHT,
  HealthDataType.MOVE_MINUTES,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.SLEEP_DEEP,
  HealthDataType.SLEEP_LIGHT,
  HealthDataType.SLEEP_REM,
  HealthDataType.SLEEP_OUT_OF_BED,
  HealthDataType.SLEEP_SESSION,
  HealthDataType.WATER,
  HealthDataType.WORKOUT,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.FLIGHTS_CLIMBED,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.RESPIRATORY_RATE,
  HealthDataType.VO2MAX,
];

/// Maps a [HealthDataType] to a [HealthDataUnit].
const Map<HealthDataType, HealthDataUnit> _dataTypeToUnit = {
  HealthDataType.ACTIVE_ENERGY_BURNED: HealthDataUnit.KILOCALORIE,
  HealthDataType.AUDIOGRAM: HealthDataUnit.DECIBEL_HEARING_LEVEL,
  HealthDataType.BASAL_ENERGY_BURNED: HealthDataUnit.KILOCALORIE,
  HealthDataType.BLOOD_GLUCOSE: HealthDataUnit.MILLIGRAM_PER_DECILITER,
  HealthDataType.BLOOD_OXYGEN: HealthDataUnit.PERCENT,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BODY_FAT_PERCENTAGE: HealthDataUnit.PERCENT,
  HealthDataType.BODY_MASS_INDEX: HealthDataUnit.NO_UNIT,
  HealthDataType.BODY_TEMPERATURE: HealthDataUnit.DEGREE_CELSIUS,
  HealthDataType.DIETARY_CARBS_CONSUMED: HealthDataUnit.GRAM,
  HealthDataType.DIETARY_ENERGY_CONSUMED: HealthDataUnit.KILOCALORIE,
  HealthDataType.DIETARY_FATS_CONSUMED: HealthDataUnit.GRAM,
  HealthDataType.DIETARY_PROTEIN_CONSUMED: HealthDataUnit.GRAM,
  HealthDataType.ELECTRODERMAL_ACTIVITY: HealthDataUnit.SIEMEN,
  HealthDataType.FORCED_EXPIRATORY_VOLUME: HealthDataUnit.LITER,
  HealthDataType.HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.RESPIRATORY_RATE: HealthDataUnit.RESPIRATIONS_PER_MINUTE,
  HealthDataType.PERIPHERAL_PERFUSION_INDEX: HealthDataUnit.PERCENT,
  HealthDataType.HEIGHT: HealthDataUnit.METER,
  HealthDataType.RESTING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.STEPS: HealthDataUnit.COUNT,
  HealthDataType.WAIST_CIRCUMFERENCE: HealthDataUnit.METER,
  HealthDataType.WALKING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.WEIGHT: HealthDataUnit.KILOGRAM,
  HealthDataType.DISTANCE_WALKING_RUNNING: HealthDataUnit.METER,
  HealthDataType.FLIGHTS_CLIMBED: HealthDataUnit.COUNT,
  HealthDataType.MOVE_MINUTES: HealthDataUnit.MINUTE,
  HealthDataType.DISTANCE_DELTA: HealthDataUnit.METER,
  HealthDataType.VO2MAX: HealthDataUnit.VO2MAX_UNIT,


  HealthDataType.WATER: HealthDataUnit.LITER,
  HealthDataType.SLEEP_IN_BED: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_ASLEEP: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_AWAKE: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_DEEP: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_CORE: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_UNSPECIFIED: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_REM: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_OUT_OF_BED: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_LIGHT: HealthDataUnit.MINUTE,
  HealthDataType.SLEEP_SESSION: HealthDataUnit.MINUTE,

  HealthDataType.MINDFULNESS: HealthDataUnit.MINUTE,
  HealthDataType.EXERCISE_TIME: HealthDataUnit.MINUTE,
  HealthDataType.WORKOUT: HealthDataUnit.NO_UNIT,

  HealthDataType.HEADACHE_NOT_PRESENT: HealthDataUnit.MINUTE,
  HealthDataType.HEADACHE_MILD: HealthDataUnit.MINUTE,
  HealthDataType.HEADACHE_MODERATE: HealthDataUnit.MINUTE,
  HealthDataType.HEADACHE_SEVERE: HealthDataUnit.MINUTE,
  HealthDataType.HEADACHE_UNSPECIFIED: HealthDataUnit.MINUTE,

  // Heart Rate events (specific to Apple Watch)
  HealthDataType.HIGH_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.LOW_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.HEART_RATE_VARIABILITY_SDNN: HealthDataUnit.MILLISECOND,
  HealthDataType.ELECTROCARDIOGRAM: HealthDataUnit.VOLT,
};

const PlatformTypeJsonValue = {
  PlatformType.IOS: 'ios',
  PlatformType.ANDROID: 'android',
};

/// List of all [HealthDataUnit]s.
enum HealthDataUnit {
  // Mass units
  GRAM,
  KILOGRAM,
  OUNCE,
  POUND,
  STONE,
  // MOLE_UNIT_WITH_MOLAR_MASS, // requires molar mass input - not supported yet
  // MOLE_UNIT_WITH_PREFIX_MOLAR_MASS, // requires molar mass & prefix input - not supported yet

  // Length units
  METER,
  INCH,
  FOOT,
  YARD,
  MILE,

  // Volume units
  LITER,
  MILLILITER,
  FLUID_OUNCE_US,
  FLUID_OUNCE_IMPERIAL,
  CUP_US,
  CUP_IMPERIAL,
  PINT_US,
  PINT_IMPERIAL,

  // Pressure units
  PASCAL,
  MILLIMETER_OF_MERCURY,
  INCHES_OF_MERCURY,
  CENTIMETER_OF_WATER,
  ATMOSPHERE,
  DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL,

  // Time units
  SECOND,
  MILLISECOND,
  MINUTE,
  HOUR,
  DAY,

  // Energy units
  JOULE,
  KILOCALORIE,
  LARGE_CALORIE,
  SMALL_CALORIE,

  // Temperature units
  DEGREE_CELSIUS,
  DEGREE_FAHRENHEIT,
  KELVIN,

  // Hearing units
  DECIBEL_HEARING_LEVEL,

  // Frequency units
  HERTZ,

  // Electrical conductance units
  SIEMEN,

  // Potential units
  VOLT,

  // Pharmacology units
  INTERNATIONAL_UNIT,

  // Scalar units
  COUNT,
  PERCENT,

  // Other units
  BEATS_PER_MINUTE,
  RESPIRATIONS_PER_MINUTE,
  MILLIGRAM_PER_DECILITER,
  VO2MAX_UNIT,
  UNKNOWN_UNIT,
  NO_UNIT,
}

/// List of [HealthWorkoutActivityType]s.
/// Commented for which platform they are supported
enum HealthWorkoutActivityType {
  // Both
  ARCHERY,
  BADMINTON,
  BASEBALL,
  BASKETBALL,
  BIKING, // This also entails the iOS version where it is called CYCLING
  BOXING,
  CRICKET,
  CURLING,
  ELLIPTICAL,
  FENCING,
  AMERICAN_FOOTBALL,
  AUSTRALIAN_FOOTBALL,
  SOCCER,
  GOLF,
  GYMNASTICS,
  HANDBALL,
  HIGH_INTENSITY_INTERVAL_TRAINING,
  HIKING,
  HOCKEY,
  SKATING,
  JUMP_ROPE,
  KICKBOXING,
  MARTIAL_ARTS,
  PILATES,
  RACQUETBALL,
  ROWING,
  RUGBY,
  RUNNING,
  SAILING,
  CROSS_COUNTRY_SKIING,
  DOWNHILL_SKIING,
  SNOWBOARDING,
  SOFTBALL,
  SQUASH,
  STAIR_CLIMBING,
  SWIMMING,
  TABLE_TENNIS,
  TENNIS,
  VOLLEYBALL,
  WALKING,
  WATER_POLO,
  YOGA,

  // iOS only
  BOWLING,
  CROSS_TRAINING,
  TRACK_AND_FIELD,
  DISC_SPORTS,
  LACROSSE,
  PREPARATION_AND_RECOVERY,
  FLEXIBILITY,
  COOLDOWN,
  WHEELCHAIR_WALK_PACE,
  WHEELCHAIR_RUN_PACE,
  HAND_CYCLING,
  CORE_TRAINING,
  FUNCTIONAL_STRENGTH_TRAINING,
  TRADITIONAL_STRENGTH_TRAINING,
  MIXED_CARDIO,
  STAIRS,
  STEP_TRAINING,
  FITNESS_GAMING,
  BARRE,
  CARDIO_DANCE,
  SOCIAL_DANCE,
  MIND_AND_BODY,
  PICKLEBALL,
  CLIMBING,
  EQUESTRIAN_SPORTS,
  FISHING,
  HUNTING,
  PLAY,
  SNOW_SPORTS,
  PADDLE_SPORTS,
  SURFING_SPORTS,
  WATER_FITNESS,
  WATER_SPORTS,
  TAI_CHI,
  WRESTLING,

  // Android only
  AEROBICS,
  BIATHLON,
  BIKING_HAND,
  BIKING_MOUNTAIN,
  BIKING_ROAD,
  BIKING_SPINNING,
  BIKING_STATIONARY,
  BIKING_UTILITY,
  CALISTHENICS,
  CIRCUIT_TRAINING,
  CROSS_FIT,
  DANCING,
  DIVING,
  ELEVATOR,
  ERGOMETER,
  ESCALATOR,
  FRISBEE_DISC,
  GARDENING,
  GUIDED_BREATHING,
  HORSEBACK_RIDING,
  HOUSEWORK,
  INTERVAL_TRAINING,
  IN_VEHICLE,
  ICE_SKATING,
  KAYAKING,
  KETTLEBELL_TRAINING,
  KICK_SCOOTER,
  KITE_SURFING,
  MEDITATION,
  MIXED_MARTIAL_ARTS,
  P90X,
  PARAGLIDING,
  POLO,
  ROCK_CLIMBING, // on iOS this is the same as CLIMBING
  ROWING_MACHINE,
  RUNNING_JOGGING, // on iOS this is the same as RUNNING
  RUNNING_SAND, // on iOS this is the same as RUNNING
  RUNNING_TREADMILL, // on iOS this is the same as RUNNING
  SCUBA_DIVING,
  SKATING_CROSS, // on iOS this is the same as SKATING
  SKATING_INDOOR, // on iOS this is the same as SKATING
  SKATING_INLINE, // on iOS this is the same as SKATING
  SKIING,
  SKIING_BACK_COUNTRY,
  SKIING_KITE,
  SKIING_ROLLER,
  SLEDDING,
  SNOWMOBILE,
  SNOWSHOEING,
  STAIR_CLIMBING_MACHINE,
  STANDUP_PADDLEBOARDING,
  STILL,
  STRENGTH_TRAINING,
  SURFING,
  SWIMMING_OPEN_WATER,
  SWIMMING_POOL,
  TEAM_SPORTS,
  TILTING,
  VOLLEYBALL_BEACH,
  VOLLEYBALL_INDOOR,
  WAKEBOARDING,
  WALKING_FITNESS,
  WALKING_NORDIC,
  WALKING_STROLLER,
  WALKING_TREADMILL,
  WEIGHTLIFTING,
  WHEELCHAIR,
  WINDSURFING,
  ZUMBA,

  //
  OTHER,
}

/// Classifications for ECG readings.
enum ElectrocardiogramClassification {
  NOT_SET,
  SINUS_RHYTHM,
  ATRIAL_FIBRILLATION,
  INCONCLUSIVE_LOW_HEART_RATE,
  INCONCLUSIVE_HIGH_HEART_RATE,
  INCONCLUSIVE_POOR_READING,
  INCONCLUSIVE_OTHER,
  UNRECOGNIZED,
}

/// Extension to assign numbers to [ElectrocardiogramClassification]s
extension ElectrocardiogramClassificationValue
on ElectrocardiogramClassification {
  int get value {
    switch (this) {
      case ElectrocardiogramClassification.NOT_SET:
        return 0;
      case ElectrocardiogramClassification.SINUS_RHYTHM:
        return 1;
      case ElectrocardiogramClassification.ATRIAL_FIBRILLATION:
        return 2;
      case ElectrocardiogramClassification.INCONCLUSIVE_LOW_HEART_RATE:
        return 3;
      case ElectrocardiogramClassification.INCONCLUSIVE_HIGH_HEART_RATE:
        return 4;
      case ElectrocardiogramClassification.INCONCLUSIVE_POOR_READING:
        return 5;
      case ElectrocardiogramClassification.INCONCLUSIVE_OTHER:
        return 6;
      case ElectrocardiogramClassification.UNRECOGNIZED:
        return 100;
    }
  }
}


class HealthDataPoint {
  HealthValue _value;
  HealthDataType _type;
  HealthDataUnit _unit;
  DateTime _dateFrom;
  DateTime _dateTo;
  PlatformType _platform;
  String _deviceId;
  String _sourceId;
  String _sourceName;

  HealthDataPoint(
      this._value,
      this._type,
      this._unit,
      this._dateFrom,
      this._dateTo,
      this._platform,
      this._deviceId,
      this._sourceId,
      this._sourceName) {
    // set the value to minutes rather than the category
    // returned by the native API
    if (type == HealthDataType.MINDFULNESS ||
        type == HealthDataType.HEADACHE_UNSPECIFIED ||
        type == HealthDataType.HEADACHE_NOT_PRESENT ||
        type == HealthDataType.HEADACHE_MILD ||
        type == HealthDataType.HEADACHE_MODERATE ||
        type == HealthDataType.HEADACHE_SEVERE ||
        type == HealthDataType.SLEEP_IN_BED ||
        type == HealthDataType.SLEEP_ASLEEP ||
        type == HealthDataType.SLEEP_AWAKE ||
        type == HealthDataType.SLEEP_DEEP ||
        type == HealthDataType.SLEEP_LIGHT ||
        type == HealthDataType.SLEEP_REM ||
        type == HealthDataType.SLEEP_UNSPECIFIED ||
        type == HealthDataType.SLEEP_CORE) {
      this._value = _convertMinutes();
    }
  }



  /// Converts dateTo - dateFrom to minutes.
  NumericHealthValue _convertMinutes() {
    int ms = dateTo.millisecondsSinceEpoch - dateFrom.millisecondsSinceEpoch;
    return NumericHealthValue(ms / (1000 * 60));
  }

  /// Converts a json object to the [HealthDataPoint]
  factory HealthDataPoint.fromJson(json) {
    HealthValue healthValue;
    if (json['data_type'] == 'AUDIOGRAM') {
      healthValue = AudiogramHealthValue.fromJson(json['value']);
    } else if (json['data_type'] == 'WORKOUT') {
      healthValue = WorkoutHealthValue.fromJson(json['value']);
    } else {
      healthValue = NumericHealthValue.fromJson(json['value']);
    }

    return HealthDataPoint(
        healthValue,
        HealthDataType.values
            .firstWhere((element) => element.name == json['data_type']),
        HealthDataUnit.values
            .firstWhere((element) => element.name == json['unit']),
        DateTime.parse(json['date_from']),
        DateTime.parse(json['date_to']),
        PlatformTypeJsonValue.keys.toList()[PlatformTypeJsonValue.values
            .toList()
            .indexOf(json['platform_type'])],
        json['device_id'],
        json['source_id'],
        json['source_name']);
  }

  /// Converts the [HealthDataPoint] to a json object
  Map<String, dynamic> toJson() => {
    'value': value.toJson(),
    'data_type': type.name,
    'unit': unit.name,
    'date_from': dateFrom.toIso8601String(),
    'date_to': dateTo.toIso8601String(),
    'platform_type': PlatformTypeJsonValue[platform],
    'device_id': deviceId,
    'source_id': sourceId,
    'source_name': sourceName
  };

  @override
  String toString() => """${this.runtimeType} -
    value: ${value.toString()},
    unit: ${unit.name},
    dateFrom: $dateFrom,
    dateTo: $dateTo,
    dataType: ${type.name},
    platform: $platform,
    deviceId: $deviceId,
    sourceId: $sourceId,
    sourceName: $sourceName""";

  /// The quantity value of the data point
  HealthValue get value => _value;

  /// The start of the time interval
  DateTime get dateFrom => _dateFrom;

  /// The end of the time interval
  DateTime get dateTo => _dateTo;

  /// The type of the data point
  HealthDataType get type => _type;

  /// The unit of the data point
  HealthDataUnit get unit => _unit;

  /// The software platform of the data point
  PlatformType get platform => _platform;

  /// The data point type as a string
  String get typeString => _type.name;

  /// The data point unit as a string
  String get unitString => _unit.name;

  /// The id of the device from which the data point was fetched.
  String get deviceId => _deviceId;

  /// The id of the source from which the data point was fetched.
  String get sourceId => _sourceId;

  /// The name of the source from which the data point was fetched.
  String get sourceName => _sourceName;

  @override
  bool operator ==(Object o) {
    return o is HealthDataPoint &&
        this.value == o.value &&
        this.unit == o.unit &&
        this.dateFrom == o.dateFrom &&
        this.dateTo == o.dateTo &&
        this.type == o.type &&
        this.platform == o.platform &&
        this.deviceId == o.deviceId &&
        this.sourceId == o.sourceId &&
        this.sourceName == o.sourceName;
  }

  @override
  int get hashCode => Object.hash(value, unit, dateFrom, dateTo, type, platform,
      deviceId, sourceId, sourceName);
}
