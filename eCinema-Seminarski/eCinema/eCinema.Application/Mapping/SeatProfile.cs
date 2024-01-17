using eCinema.Core;

namespace eCinema.Application
{
    public class SeatProfile : BaseProfile
    {
        public SeatProfile()
        {
            CreateMap<SeatDto, Seat>().ReverseMap();

            CreateMap<SeatUpsertDto, Seat>();
        }
    }
}
