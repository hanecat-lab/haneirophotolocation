// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkspaceLogCollection on Isar {
  IsarCollection<WorkspaceLog> get workspaceLogs => this.collection();
}

const WorkspaceLogSchema = CollectionSchema(
  name: r'WorkspaceLog',
  id: -8375507305799284646,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.byte,
      enumMap: _WorkspaceLogactionEnumValueMap,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'executedAt': PropertySchema(
      id: 2,
      name: r'executedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _workspaceLogEstimateSize,
  serialize: _workspaceLogSerialize,
  deserialize: _workspaceLogDeserialize,
  deserializeProp: _workspaceLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'executedAt': IndexSchema(
      id: -1394297690758325806,
      name: r'executedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'executedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'workspaceItem': LinkSchema(
      id: -2206844273655900441,
      name: r'workspaceItem',
      target: r'WorkspaceItem',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _workspaceLogGetId,
  getLinks: _workspaceLogGetLinks,
  attach: _workspaceLogAttach,
  version: '3.3.2',
);

int _workspaceLogEstimateSize(
  WorkspaceLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _workspaceLogSerialize(
  WorkspaceLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.action.index);
  writer.writeString(offsets[1], object.description);
  writer.writeDateTime(offsets[2], object.executedAt);
}

WorkspaceLog _workspaceLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkspaceLog();
  object.action =
      _WorkspaceLogactionValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          WorkspaceLogAction.create;
  object.description = reader.readStringOrNull(offsets[1]);
  object.executedAt = reader.readDateTime(offsets[2]);
  object.id = id;
  return object;
}

P _workspaceLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_WorkspaceLogactionValueEnumMap[reader.readByteOrNull(offset)] ??
          WorkspaceLogAction.create) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WorkspaceLogactionEnumValueMap = {
  'create': 0,
  'edit': 1,
  'ocr': 2,
  'copy': 3,
  'aiInference': 4,
  'workflowRun': 5,
};
const _WorkspaceLogactionValueEnumMap = {
  0: WorkspaceLogAction.create,
  1: WorkspaceLogAction.edit,
  2: WorkspaceLogAction.ocr,
  3: WorkspaceLogAction.copy,
  4: WorkspaceLogAction.aiInference,
  5: WorkspaceLogAction.workflowRun,
};

Id _workspaceLogGetId(WorkspaceLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workspaceLogGetLinks(WorkspaceLog object) {
  return [object.workspaceItem];
}

void _workspaceLogAttach(
    IsarCollection<dynamic> col, Id id, WorkspaceLog object) {
  object.id = id;
  object.workspaceItem
      .attach(col, col.isar.collection<WorkspaceItem>(), r'workspaceItem', id);
}

extension WorkspaceLogQueryWhereSort
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QWhere> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhere> anyExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'executedAt'),
      );
    });
  }
}

extension WorkspaceLogQueryWhere
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QWhereClause> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> executedAtEqualTo(
      DateTime executedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'executedAt',
        value: [executedAt],
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause>
      executedAtNotEqualTo(DateTime executedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [],
              upper: [executedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [executedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [executedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [],
              upper: [executedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause>
      executedAtGreaterThan(
    DateTime executedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'executedAt',
        lower: [executedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause>
      executedAtLessThan(
    DateTime executedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'executedAt',
        lower: [],
        upper: [executedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterWhereClause> executedAtBetween(
    DateTime lowerExecutedAt,
    DateTime upperExecutedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'executedAt',
        lower: [lowerExecutedAt],
        includeLower: includeLower,
        upper: [upperExecutedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WorkspaceLogQueryFilter
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QFilterCondition> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> actionEqualTo(
      WorkspaceLogAction value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      actionGreaterThan(
    WorkspaceLogAction value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      actionLessThan(
    WorkspaceLogAction value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> actionBetween(
    WorkspaceLogAction lower,
    WorkspaceLogAction upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      executedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      executedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      executedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      executedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'executedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> idBetween(
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
}

extension WorkspaceLogQueryObject
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QFilterCondition> {}

extension WorkspaceLogQueryLinks
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QFilterCondition> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition> workspaceItem(
      FilterQuery<WorkspaceItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'workspaceItem');
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterFilterCondition>
      workspaceItemIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'workspaceItem', 0, true, 0, true);
    });
  }
}

extension WorkspaceLogQuerySortBy
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QSortBy> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> sortByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy>
      sortByExecutedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.desc);
    });
  }
}

extension WorkspaceLogQuerySortThenBy
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QSortThenBy> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> thenByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy>
      thenByExecutedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension WorkspaceLogQueryWhereDistinct
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QDistinct> {
  QueryBuilder<WorkspaceLog, WorkspaceLog, QDistinct> distinctByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action');
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLog, QDistinct> distinctByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'executedAt');
    });
  }
}

extension WorkspaceLogQueryProperty
    on QueryBuilder<WorkspaceLog, WorkspaceLog, QQueryProperty> {
  QueryBuilder<WorkspaceLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkspaceLog, WorkspaceLogAction, QQueryOperations>
      actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<WorkspaceLog, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<WorkspaceLog, DateTime, QQueryOperations> executedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'executedAt');
    });
  }
}
