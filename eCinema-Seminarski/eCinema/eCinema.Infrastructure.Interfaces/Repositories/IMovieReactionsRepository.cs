using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IMovieReactionsRepository : IBaseRepository<MovieReaction, int, BaseSearchObject>
    {
        Task<List<MovieReaction>> GetMovieReactions(CancellationToken cancellationToken);
    }
}
