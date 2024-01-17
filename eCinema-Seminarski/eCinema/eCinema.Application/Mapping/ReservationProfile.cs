using eCinema.Core;

namespace eCinema.Application
{
    public class ReservationProfile : BaseProfile
    {
        public ReservationProfile()
        {
            CreateMap<ReservationDto, Reservation>().ReverseMap();

            CreateMap<ReservationUpsertDto, Reservation>();
        }
    }
}
