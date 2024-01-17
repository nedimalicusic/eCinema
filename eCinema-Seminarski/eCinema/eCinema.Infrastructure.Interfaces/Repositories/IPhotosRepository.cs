using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IPhotosRepository : IBaseRepository<Photo,int,BaseSearchObject>
    {
        Task<byte[]?> GetOriginalContet(Guid id);
        Task<byte[]?> GetThumbnailContent(Guid id);
        Task<int> GetPhotoIdByGuidId(Guid guidId, CancellationToken cancellationToken = default);
    }
}
