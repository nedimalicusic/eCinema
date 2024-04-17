using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class MovieActorsRepository : BaseRepository<MovieActors, int, BaseSearchObject>, IMovieActorsRepository
    {
        public MovieActorsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override void Remove(MovieActors entity)
        {
            DatabaseContext.ChangeTracker.DetectChanges();
            base.Remove(entity);
        }
        public void DetachEntity(MovieActors entity)
        {
            var entry = DatabaseContext.Entry(entity);
            if (entry != null)
            {
                entry.State = EntityState.Modified;
            }
        }
    }
}
