// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAiSettingCollection on Isar {
  IsarCollection<AiSetting> get aiSettings => this.collection();
}

const AiSettingSchema = CollectionSchema(
  name: r'AiSetting',
  id: 3497083897581029056,
  properties: {
    r'encryptedApiKey': PropertySchema(
      id: 0,
      name: r'encryptedApiKey',
      type: IsarType.string,
    ),
    r'providerId': PropertySchema(
      id: 1,
      name: r'providerId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _aiSettingEstimateSize,
  serialize: _aiSettingSerialize,
  deserialize: _aiSettingDeserialize,
  deserializeProp: _aiSettingDeserializeProp,
  idName: r'id',
  indexes: {
    r'providerId': IndexSchema(
      id: -1675978104265523206,
      name: r'providerId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'providerId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _aiSettingGetId,
  getLinks: _aiSettingGetLinks,
  attach: _aiSettingAttach,
  version: '3.3.2',
);

int _aiSettingEstimateSize(
  AiSetting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedApiKey.length * 3;
  bytesCount += 3 + object.providerId.length * 3;
  return bytesCount;
}

void _aiSettingSerialize(
  AiSetting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.encryptedApiKey);
  writer.writeString(offsets[1], object.providerId);
  writer.writeDateTime(offsets[2], object.updatedAt);
}

AiSetting _aiSettingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AiSetting();
  object.encryptedApiKey = reader.readString(offsets[0]);
  object.id = id;
  object.providerId = reader.readString(offsets[1]);
  object.updatedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _aiSettingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aiSettingGetId(AiSetting object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aiSettingGetLinks(AiSetting object) {
  return [];
}

void _aiSettingAttach(IsarCollection<dynamic> col, Id id, AiSetting object) {
  object.id = id;
}

extension AiSettingByIndex on IsarCollection<AiSetting> {
  Future<AiSetting?> getByProviderId(String providerId) {
    return getByIndex(r'providerId', [providerId]);
  }

  AiSetting? getByProviderIdSync(String providerId) {
    return getByIndexSync(r'providerId', [providerId]);
  }

  Future<bool> deleteByProviderId(String providerId) {
    return deleteByIndex(r'providerId', [providerId]);
  }

  bool deleteByProviderIdSync(String providerId) {
    return deleteByIndexSync(r'providerId', [providerId]);
  }

  Future<List<AiSetting?>> getAllByProviderId(List<String> providerIdValues) {
    final values = providerIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'providerId', values);
  }

  List<AiSetting?> getAllByProviderIdSync(List<String> providerIdValues) {
    final values = providerIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'providerId', values);
  }

  Future<int> deleteAllByProviderId(List<String> providerIdValues) {
    final values = providerIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'providerId', values);
  }

  int deleteAllByProviderIdSync(List<String> providerIdValues) {
    final values = providerIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'providerId', values);
  }

  Future<Id> putByProviderId(AiSetting object) {
    return putByIndex(r'providerId', object);
  }

  Id putByProviderIdSync(AiSetting object, {bool saveLinks = true}) {
    return putByIndexSync(r'providerId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByProviderId(List<AiSetting> objects) {
    return putAllByIndex(r'providerId', objects);
  }

  List<Id> putAllByProviderIdSync(List<AiSetting> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'providerId', objects, saveLinks: saveLinks);
  }
}

extension AiSettingQueryWhereSort
    on QueryBuilder<AiSetting, AiSetting, QWhere> {
  QueryBuilder<AiSetting, AiSetting, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AiSettingQueryWhere
    on QueryBuilder<AiSetting, AiSetting, QWhereClause> {
  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> providerIdEqualTo(
      String providerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'providerId',
        value: [providerId],
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterWhereClause> providerIdNotEqualTo(
      String providerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerId',
              lower: [],
              upper: [providerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerId',
              lower: [providerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerId',
              lower: [providerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerId',
              lower: [],
              upper: [providerId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AiSettingQueryFilter
    on QueryBuilder<AiSetting, AiSetting, QFilterCondition> {
  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedApiKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedApiKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedApiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      encryptedApiKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedApiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> providerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      providerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> providerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> providerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      providerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> providerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> providerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> providerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      providerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerId',
        value: '',
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      providerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerId',
        value: '',
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AiSettingQueryObject
    on QueryBuilder<AiSetting, AiSetting, QFilterCondition> {}

extension AiSettingQueryLinks
    on QueryBuilder<AiSetting, AiSetting, QFilterCondition> {}

extension AiSettingQuerySortBy on QueryBuilder<AiSetting, AiSetting, QSortBy> {
  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> sortByEncryptedApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedApiKey', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> sortByEncryptedApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedApiKey', Sort.desc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> sortByProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> sortByProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.desc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AiSettingQuerySortThenBy
    on QueryBuilder<AiSetting, AiSetting, QSortThenBy> {
  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByEncryptedApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedApiKey', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByEncryptedApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedApiKey', Sort.desc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.desc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AiSettingQueryWhereDistinct
    on QueryBuilder<AiSetting, AiSetting, QDistinct> {
  QueryBuilder<AiSetting, AiSetting, QDistinct> distinctByEncryptedApiKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedApiKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QDistinct> distinctByProviderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiSetting, AiSetting, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AiSettingQueryProperty
    on QueryBuilder<AiSetting, AiSetting, QQueryProperty> {
  QueryBuilder<AiSetting, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AiSetting, String, QQueryOperations> encryptedApiKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedApiKey');
    });
  }

  QueryBuilder<AiSetting, String, QQueryOperations> providerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerId');
    });
  }

  QueryBuilder<AiSetting, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
