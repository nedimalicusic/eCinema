using eCinema.Core;
using eCinema.Core.Dtos.Photo;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IPhotosService : IBaseService<int,PhotoDto,PhotoUpsertDto,BaseSearchObject>
    {
        Task<List<Guid>> ProcessAsync(IEnumerable<PhotoUpsertModel> image);
        Task<byte[]?> GetImageAsync(Guid id, bool original);
        Task<int> GetPhotoIdByGuidId(Guid guidId, CancellationToken cancellationToken = default);
    }
}
