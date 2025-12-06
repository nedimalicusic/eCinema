using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class MovieReactionsRepository : BaseRepository<MovieReaction, int, BaseSearchObject>, IMovieReactionsRepository
    {
        public MovieReactionsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<List<MovieReaction>> GetMovieReactions(CancellationToken cancellationToken)
        {
            return await DbSet.ToListAsync(cancellationToken);
        }
    }
}
