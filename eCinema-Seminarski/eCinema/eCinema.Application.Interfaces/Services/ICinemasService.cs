using eCinema.Core;
using eCinema.Core.Dtos.Cinema;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface ICinemasService : IBaseService<int,CinemaDto,CinemaUpsertDto, CinemaSearchObject>
    {
        Task<DashboardDto> GetDashboardInformation(int? cinemaId, CancellationToken cancellationToken);
    }
}
