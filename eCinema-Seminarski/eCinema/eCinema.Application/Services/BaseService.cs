using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public abstract class BaseService<TEntity,TDto,TUpsertDto,TSearchObject,TRepository> : IBaseService<int,TDto,TUpsertDto,TSearchObject>
        where TEntity : BaseEntity
        where TDto: BaseDto
        where TUpsertDto: BaseUpsertDto
        where TSearchObject : BaseSearchObject
        where TRepository: class,IBaseRepository<TEntity,int,TSearchObject>
    {

        private const bool ShouldSoftDelete = true;

        protected readonly IMapper Mapper;
        protected readonly UnitOfWork UnitOfWork;
        protected readonly TRepository CurrentRepository;
        protected readonly IValidator<TUpsertDto> Validator;


        protected BaseService(IMapper mapper,IUnitOfWork unitOfWork, IValidator<TUpsertDto> validator)
        {
            Mapper = mapper;
            UnitOfWork=(UnitOfWork)unitOfWork;
            Validator= validator;
            CurrentRepository = (TRepository)unitOfWork.GetType()
                                                       .GetFields()
                                                       .First(f => f.FieldType == typeof(TRepository))
                                                       .GetValue(unitOfWork)!;
        }

        public virtual async Task<TDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await CurrentRepository.GetByIdAsync(id, cancellationToken);
            return Mapper.Map<TDto>(entity);
        }


        public virtual async Task<PagedList<TDto>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            return Mapper.Map<PagedList<TDto>>(pagedList);
        }

        public virtual async Task<TDto> AddAsync(TUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<TEntity>(dto);
            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<TDto>(entity);
        }

        public virtual async Task<IEnumerable<TDto>> AddRangeAsync(IEnumerable<TUpsertDto> dtos, CancellationToken cancellationToken = default)
        {
            await ValidateRangeAsync(dtos, cancellationToken);

            var entities = Mapper.Map<IEnumerable<TEntity>>(dtos);
            await CurrentRepository.AddRangeAsync(entities, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<IEnumerable<TDto>>(entities);
        }

        public virtual async Task<TDto> UpdateAsync(TUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<TEntity>(dto);
            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<TDto>(entity);
        }

        public virtual async Task<IEnumerable<TDto>> UpdateRangeAsync(IEnumerable<TUpsertDto> dtos, CancellationToken cancellationToken = default)
        {
            await ValidateRangeAsync(dtos, cancellationToken);

            var entities = Mapper.Map<IEnumerable<TEntity>>(dtos);
            CurrentRepository.UpdateRange(entities);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<IEnumerable<TDto>>(entities);
        }

        public virtual async Task RemoveAsync(TDto dto, CancellationToken cancellationToken = default)
        {
            var entity = Mapper.Map<TEntity>(dto);
            CurrentRepository.Remove(entity);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
        }

        public virtual async Task RemoveByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            await CurrentRepository.RemoveByIdAsync(id, ShouldSoftDelete, cancellationToken);
        }

        protected async Task ValidateAsync(TUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var validationResult = await Validator.ValidateAsync(dto, cancellationToken);
            if (validationResult.IsValid == false)
            {
                throw new Core.ValidationException(Mapper.Map<List<ValidationError>>(validationResult.Errors));
            }

        }

        protected async Task ValidateRangeAsync(IEnumerable<TUpsertDto> dtos, CancellationToken cancellationToken = default)
        {
            foreach (var dto in dtos)
            {
                await ValidateAsync(dto, cancellationToken);
            }
        }

    }
}
