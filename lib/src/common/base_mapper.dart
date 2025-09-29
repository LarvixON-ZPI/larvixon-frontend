abstract interface class Mapper<DTO, Entity> {
  Entity dtoToEntity(DTO dto);
  DTO entityToDto(Entity entity);
}

mixin MapperMixin<DTO, Entity> on Mapper<DTO, Entity> {
  List<Entity> dtoListToEntityList(List<DTO> dtos) {
    return dtos.map(dtoToEntity).toList();
  }

  List<DTO> entityListToDtoList(List<Entity> entities) {
    return entities.map(entityToDto).toList();
  }

  Entity? dtoToEntitySafe(DTO? dto) {
    if (dto == null) return null;
    try {
      return dtoToEntity(dto);
    } catch (e) {
      return null;
    }
  }

  DTO? entityToDtoSafe(Entity? entity) {
    if (entity == null) return null;
    try {
      return entityToDto(entity);
    } catch (e) {
      return null;
    }
  }
}
