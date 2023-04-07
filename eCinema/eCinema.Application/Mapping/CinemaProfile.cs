using eCinema.Core;

namespace eCinema.Application
{
    public class CinemaProfile : BaseProfile
    {
        public CinemaProfile()
        {
            CreateMap<CinemaDto, Cinema>().ReverseMap();

            CreateMap<CinemaUpsertDto, Cinema>();
        }
    }
}
