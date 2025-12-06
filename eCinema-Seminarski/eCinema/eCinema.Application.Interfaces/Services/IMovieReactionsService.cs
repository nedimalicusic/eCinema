using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IMovieReactionsService : IBaseService<int, MovieReactionDto, MovieReactionUpsertDto, BaseSearchObject>
    {
    }
}
