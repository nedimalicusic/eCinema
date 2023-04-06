using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class PhotosRepository : BaseRepository<Photo, int, BaseSearchObject>, IPhotosRepository
    {
        public PhotosRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
