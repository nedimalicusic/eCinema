using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IBaseService<TPrimaryKey,TDto,TUpsertDto,TSearchObject>
        where TDto : BaseDto
        where TUpsertDto : BaseUpsertDto
        where TSearchObject : BaseSearchObject
    {
        Task<TDto?> GetByIdAsync(TPrimaryKey id, CancellationToken cancellationToken = default);
        Task<PagedList<TDto>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default);

        Task<TDto> AddAsync(TUpsertDto dto, CancellationToken cancellationToken = default);
        Task<IEnumerable<TDto>> AddRangeAsync(IEnumerable<TUpsertDto> dtos, CancellationToken cancellationToken = default);

        Task<TDto> UpdateAsync(TUpsertDto dto, CancellationToken cancellationToken = default);
        Task<IEnumerable<TDto>> UpdateRangeAsync(IEnumerable<TUpsertDto> dtos, CancellationToken cancellationToken = default);

        Task RemoveAsync(TDto dto, CancellationToken cancellationToken = default);
        Task RemoveByIdAsync(TPrimaryKey id, CancellationToken cancellationToken = default);
    }
}
