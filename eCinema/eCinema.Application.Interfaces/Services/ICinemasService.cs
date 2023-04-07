using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface ICinemasService : IBaseService<int,CinemaDto,CinemaUpsertDto,BaseSearchObject>
    {
    }
}
