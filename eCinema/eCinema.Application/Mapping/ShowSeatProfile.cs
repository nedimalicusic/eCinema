using eCinema.Core;

namespace eCinema.Application
{
    public class ShowSeatProfile : BaseProfile
    {
        public ShowSeatProfile()
        {
            CreateMap<ShowSeatDto, ShowSeat>().ReverseMap();

            CreateMap<ShowSeatUpsertDto, ShowSeat>();
        }
    }
}
